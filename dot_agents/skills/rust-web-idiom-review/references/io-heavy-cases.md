# I/Oが多いwebバックエンドで特に効くケース集

DB・外部API・キューを多用するアプリケーション（axum + tokio + sqlx 構成を想定）で
検出頻度が高く、直したときの効果が大きいケースを集めた。
各ケースは「症状 → なぜRustらしくないか → 直し方 → 指摘しない条件」の順。
**「指摘しない条件」に該当するものを指摘すると偽陽性になる。必ず確認すること。**

## 目次

- 型設計: ケース1〜4
- エラー設計: ケース5〜6
- 所有権: ケース7〜8
- 非同期I/O: ケース9〜12
- 境界とトランザクション: ケース13〜15

---

## ケース1: プリミティブなIDの混在

**症状:** `user_id: i64`、`assessment_id: i64`、`room_id: u64` のように、複数種のIDが
生の整数のまま同じ関数シグネチャに並ぶ。型が同じなので引数の取り違えがコンパイルで検出されない。
場所によって同じIDが `i64` / `u64` で揺れていることもある。

**なぜ:** Rustのnewtypeはゼロコストで、IDの取り違えという「テストでも見つけにくく本番で致命的」な
バグをコンパイル時に消せる。使わないのは型システムの放棄。

**直し方:**

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Serialize, serde::Deserialize)]
#[serde(transparent)]
pub struct UserId(i64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, sqlx::Type)]
#[sqlx(transparent)]
pub struct AssessmentId(u64);
```

`#[serde(transparent)]` / `#[sqlx(transparent)]` を使えば、ワイヤ・DB表現は変えずに
コード内だけ型を分けられる。導入コストはシグネチャの書き換えのみ。

**指摘しない条件:** IDが1種類しか登場しないモジュール内で閉じている場合。
まず取り違えリスクが実在する箇所（同一関数に複数ID、ID間の変換がある箇所)から提案する。

---

## ケース2: 範囲・単位の保証がない数値

**症状:** `latitude: f64, longitude: f64` が生のままハンドラからドメイン、DB層まで流れる。
`(lat, lng)` の順序間違い、範囲外の値、距離の km/m 混同がどこでも起こりうる。

**なぜ:** バリデーションをHTTP境界（garde等）でやっていても、その証明は型に残らない。
下流の関数は「多分検証済みのf64」を信じるしかない。

**直し方:**

```rust
pub struct Coordinate { lat: f64, lng: f64 }  // フィールドは private

impl Coordinate {
    pub fn new(lat: f64, lng: f64) -> Result<Self, CoordinateError> {
        if !(-90.0..=90.0).contains(&lat) { return Err(CoordinateError::LatitudeOutOfRange(lat)); }
        if !(-180.0..=180.0).contains(&lng) { return Err(CoordinateError::LongitudeOutOfRange(lng)); }
        Ok(Self { lat, lng })
    }
    pub fn lat(&self) -> f64 { self.lat }
    pub fn lng(&self) -> f64 { self.lng }
}
```

DTO → ドメイン変換（`TryFrom`）の中で一度だけ構築し、以降は `Coordinate` で流す。
lat/lng をペアで持たせると引数順の取り違えも消える。

**指摘しない条件:** その数値が1関数内で完結する中間計算値の場合。
既存コードベース全体で順序・範囲の扱いが一貫しており実バグの兆候がなく、
導入の波及範囲（クエリ組み立て、DBカラム、ジョブ等）が大きい場合は、
High/Medium にせず Low または「検討の余地あり」で境界1箇所からの段階導入を提案する。

---

## ケース3: kind フィールド + Option ペイロード（enumで書くべきstruct）

**症状:**

```rust
pub struct AssessmentOutcome {
    pub kind: OutcomeKind,             // Assessed | Unassessable
    pub result: Option<RegressionResult>, // Assessed のときだけ Some
    pub reason: Option<String>,           // Unassessable のときだけ Some
}
```

**なぜ:** `kind == Assessed && result == None` という不正な状態が作れてしまい、
使う側は毎回 `unwrap` か防御的 `if` を書く。Rust の enum はペイロード付き直和型であり、
この不正状態を表現不可能にできる。

**直し方:**

```rust
pub enum AssessmentOutcome {
    Assessed(Box<RegressionResult>),   // 大きい variant は Box でサイズを均す
    Unassessable { reason: UnassessableReason },
}
```

match が exhaustive になり、variant追加時にコンパイルエラーで全対応箇所が分かる。

**指摘しない条件:** DBのRow型やDTOなど、ワイヤ表現の都合で flat にしている境界型。
その場合は「境界型 → enum への変換関数があるか」を代わりに確認する。

---

## ケース4: 空コレクションの意味の多重化

**症状:** `Vec<SimilarRoom>` の空が「検索したが0件」と「検索していない」の両方を意味し、
呼び出し側が文脈で判断している。あるいは `Option<Vec<T>>` の `None` / `Some(vec![])` の
使い分けが暗黙。

**なぜ:** I/Oが絡むと「まだ取得していない」「取得したが空」「取得に失敗した」は
業務的に別の状態。名前のない状態は必ず取り違えられる。

**直し方:** 状態を enum で命名する。

```rust
pub enum RoomSearch {
    NotSearched,
    Found(Vec<SimilarRoom>),      // 空 Vec は「検索して0件」のみを意味する
}
```

0件を特別扱いする業務ルール（例: 査定不能）があるなら、それも variant にする。

**指摘しない条件:** 空と未取得の区別が業務上存在しない場合。

---

## ケース5: 構造のないエラー（`Internal(String)` への集約）

**症状:** `AppError::Internal(String)` や `anyhow::Error` に、DB障害・外部API障害・
データ不整合など性質の違う失敗が全部流れ込む。リトライ可否やHTTPステータスの判断が
呼び出し側の文字列マッチや場当たり分岐になる。

**なぜ:** エラーは呼び出し側が「分岐できる」ことに価値がある。文字列化した時点で
match も is_retryable も書けなくなり、障害対応がログの grep 頼みになる。

**直し方:** 失敗の単位ごとに thiserror の enum を定義し、分類をエラー型自身に持たせる。

```rust
#[derive(Debug, thiserror::Error)]
pub enum DsApiError {
    #[error("ds-api returned {status}")]
    Status { status: StatusCode, body: String },
    #[error("ds-api request failed")]
    Transport(#[from] reqwest::Error),
}

impl DsApiError {
    pub fn is_retryable(&self) -> bool {
        match self {
            Self::Status { status, .. } => status.is_server_error(),
            Self::Transport(e) => e.is_timeout() || e.is_connect(),
        }
    }
}
```

アプリ最上位の enum（`AppError`）には `#[from]` で吸い上げ、`IntoResponse` の実装
一箇所でステータス対応・ログレベル・クライアントへの詳細マスキングを決める。

**指摘しない条件:** バイナリ／アプリ最上位での `anyhow` + `.context()` は妥当なイディオム。
指摘対象は「再利用されるinfra層クライアントが構造のないエラーを公開している」場合。

---

## ケース6: 文脈のない `?` の連鎖

**症状:** usecase が `let rooms = self.reader.search(&spec).await?;` のような `?` を
10連発しており、障害時のログに「sqlx error: pool timed out」だけが残り、
どの業務操作のどの段階かが分からない。

**なぜ:** `?` は伝播はするが文脈を足さない。I/Oが多い処理では「何をしようとして
失敗したか」がエラー値に乗っていないと、リカバリも調査もできない。

**直し方:** エラー型の variant に業務文脈を持たせる（`#[error("failed to search similar rooms for condition {index}")]`）か、
anyhow 圏なら `.context("searching similar rooms")` を足す。
tracing の span（`#[instrument]`）で文脈を持たせる設計なら、それでも良い——
その場合は span にリクエストIDや対象IDが乗っているかを確認する。

**指摘しない条件:** tracing span で十分な文脈が構造化ログに乗っている場合。

---

## ケース7: タスク境界での大きなデータの clone

**症状:** 検索結果の `Vec<SimilarRoom>`（1件が100フィールド級 × 数百件）を、
バックグラウンドジョブへの dispatch のたびに `.clone()` している。

```rust
self.dispatcher.dispatch(CacheRoomsJob {
    rooms: similar_rooms.clone(),   // 数百件 × 大型struct のディープコピー
    metas: room_metas.clone(),
}).await;
```

**なぜ:** ジョブ側もレスポンス生成側も読むだけなら、所有の複製ではなく共有で足りる。
clone は「独立した所有が必要」という設計判断の表明であるべきで、
借用チェッカを黙らせる手段ではない。

**直し方:** まず消費者を数える。消費者が1つなら move（所有権の移動）で足り、
Arc も clone も不要。複数の消費者が読み取り専用で共有するときだけ `Arc` に載せ替える。

```rust
let rooms: Arc<[SimilarRoom]> = similar_rooms.into();  // Vec<T> -> Arc<[T]>
self.dispatcher.dispatch(CacheRoomsJob { rooms: Arc::clone(&rooms), .. }).await;
build_response(&rooms)   // レスポンス生成は借用で
```

`Arc<[T]>` は clone がポインタコピーになり、ジョブとレスポンス生成で同一データを共有できる。

**指摘しない条件:** データが小さい（目安: 数KB未満）、または片方がデータを変更する場合。
サイズ・頻度の根拠を添えられないなら「検討の余地あり」に格下げする。
また、clone 箇所より先に呼び出され側のシグネチャ（ケース8）を疑うこと。

---

## ケース8: 所有権を取りすぎるシグネチャ

**症状:** 保存も変換もしないのに `fn build_query(spec: QuerySpec) -> String` のように
値を受け取り、呼び出し側が `spec.clone()` を強いられている。

**なぜ:** シグネチャは所有権の契約。不要に所有を要求すると、clone がコードベース全体に
波及する。clone 多発の根本原因はしばしば呼び出され側のシグネチャにある。

**直し方:** 借用をデフォルトにする（`&QuerySpec`、`&str`、`&[T]`）。
所有を取るのは、格納・変換・別タスクへの移動がある場合のみ。
clone を指摘するときは、まず「呼び出され側のシグネチャを直せば clone 自体が消えるか」を確認する。

**指摘しない条件:** builderパターンの consuming self（`self` を取って `Self` を返す）は
Rustらしいイディオムであり、指摘対象ではない。

---

## ケース9: 独立したI/Oの逐次 await

**症状:** 互いに依存しない複数条件の検索や、複数の外部API呼び出しを for ループで逐次 await している。

```rust
let mut outcomes = Vec::new();
for condition in &draft.conditions {
    outcomes.push(process_condition(&self.reader, &self.gateway, condition).await?);
}
```

**なぜ:** レイテンシが件数に比例して積み上がる。async の価値は「待ちの重ね合わせ」であり、
逐次 await はそれを捨てている。

**直し方:**

```rust
let futs = draft.conditions.iter().map(|c| process_condition(&self.reader, &self.gateway, c));
let outcomes = futures::future::try_join_all(futs).await?;
// 全件成功が不要で個別失敗を許容するなら join_all + Result の回収
```

失敗セマンティクスを選ぶこと: `try_join_all` は1件失敗で全体中断（残りはキャンセル）、
`join_all` は全件完走。業務要件（1条件失敗で査定全体を失敗させるか）に合わせる。

**指摘しない条件:** 後の呼び出しが前の結果に依存する場合。DBコネクションプールの
同時消費上限や外部APIのレート制限を意図して逐次にしている場合（コメントや設定から確認する）。
並行化を提案するときは必ず「これらのI/Oは独立か」の確認を添える。

---

## ケース10: ロック・コネクションを await 越しに保持

**症状:**

```rust
let guard = state.cache.lock().unwrap();          // std::sync::Mutex
let fresh = fetch_from_api(&client).await?;      // guard を持ったまま await
guard.insert(key, fresh);
```

または、`sqlx` のコネクション／トランザクションを握ったまま外部API呼び出しを await している。

**なぜ:** `std::sync::Mutex` のガードを await をまたいで保持すると、同じロックを待つ
他タスクがワーカースレッドごとブロックされ、最悪デッドロックする（そもそも guard が
`Send` でなく spawn できないことが多い）。コネクション保持はプール枯渇の典型原因。

**直し方:** ロックスコープを await の前後に分割する。

```rust
let cached = { state.cache.lock().unwrap().get(&key).cloned() };  // 即drop
if let Some(v) = cached { return Ok(v); }
let fresh = fetch_from_api(&client).await?;
state.cache.lock().unwrap().insert(key, fresh.clone());
```

保持が本当に必要なら `tokio::sync::Mutex` だが、まず「またがない」設計を探す。
ワーカープールで `Arc<tokio::sync::Mutex<Receiver>>` を共有する場合は、
`recv().await` の直後にガードを drop するブロックスコープになっているかを確認する。

**指摘しない条件:** `tokio::sync::Mutex` を意図的に選び、保持時間が短いことが
コードから明らかな場合。

---

## ケース11: 管理されない fire-and-forget タスク

**症状:** `tokio::spawn(async move { cache_rooms(job).await; });` のように投げっぱなしで、
失敗しても誰も気づかず、graceful shutdown 時に処理中のタスクが切り捨てられる。

**なぜ:** spawn されたタスクの panic・エラーは黙って消える。I/Oを伴うジョブ
（キャッシュ書き込み、通知など）が静かに失敗し続けるのは、障害としては
「エラーが出る」より発見が遅く悪質。

**直し方:** 最低ラインは結果の観測。

```rust
tokio::spawn(async move {
    if let Err(e) = cache_rooms(job).await {
        tracing::error!(error = %e, "cache_rooms job failed");
        metrics.jobs_failed.fetch_add(1, Ordering::Relaxed);
    }
});
```

本格的には bounded mpsc + ワーカープール（背圧が得られる）か `TaskTracker` / `JoinSet` で
shutdown 時に完走を待つ。失敗をDBに状態として記録して再実行可能にする
（`mark_cache_failed` のようなパターン）とさらに良い。

**指摘しない条件:** 既にワーカープール＋メトリクス＋shutdown 待ちが整備されており、
その仕組みに乗っている場合。

---

## ケース12: timeout・リトライ・冪等性の欠落

**症状:** `reqwest` クライアントに timeout 未設定、リトライなし。あるいは逆に、
非冪等な POST（採番や課金を伴う）に無条件リトライが付いている。

**なぜ:** timeout のない外部呼び出しは、相手の障害を自分のコネクション枯渇として輸入する。
無分別なリトライは二重登録を作る。リトライは「エラーが retryable」かつ「操作が冪等」の
両方が揃って初めて安全。

**直し方:** クライアント構築時に timeout を必須にする。リトライは backon 等で
ポリシーを宣言的に書き、対象をエラー分類で絞る。

```rust
let resp = (|| self.client.post(&url).json(&req).send())
    .retry(ExponentialBuilder::default().with_max_times(3))
    .when(|e: &DsApiError| e.is_retryable())     // ケース5の分類を使う
    .notify(|e, dur| tracing::warn!(error = %e, ?dur, "retrying ds-api"))
    .await?;
```

非冪等な操作をリトライするなら、冪等キーをリクエストに載せるか、リトライ自体を諦める。

**指摘しない条件:** メッシュ／ゲートウェイ層（Envoy等）でリトライ・timeout を
一元管理しているとプロジェクト規約にある場合。

---

## ケース13: Row型・DTOが内部モデルとして流通

**症状:** ClickHouse の `#[derive(Row)]` 付き struct や、serde属性まみれのレスポンスDTOが、
そのままドメインロジックの引数・戻り値として何層も流れている。カラム順依存・
custom deserializer の都合がドメイン型の形を決めてしまっている。

**なぜ:** ワイヤフォーマットは外部システムの都合で変わる。それが内部モデルを兼ねると、
スキーマ変更のたびに業務ロジックが壊れ、逆に業務都合の型改善（enum化・newtype化）が
「デシリアライズが壊れるから」できなくなる。

**直し方:** 境界で変換する。Row/DTOは infra 層に閉じ、`TryFrom<Row>` でドメイン型に
変換してから返す。変換関数が失敗しうるならそれはエラー型の variant（`Decode` 等）にする。

**指摘しない条件:** フィールドが少なく変換がほぼ恒等写像で、かつそのモジュール内で
閉じている場合は、分離のコストが利益を上回る。「ドメインロジックがRow型のフィールドを
直接参照している箇所が何箇所あるか」を数えてから判断する。

---

## ケース14: トランザクション内の外部I/O

**症状:**

```rust
let mut tx = pool.begin().await?;
let id = insert_assessment(&mut tx, &draft).await?;
let result = ds_api.assess(&draft).await?;      // TXを開いたまま外部API（30秒かかりうる）
insert_results(&mut tx, id, &result).await?;
tx.commit().await?;
```

**なぜ:** 外部APIの応答時間だけDBコネクションとロックを占有し、プール枯渇・
ロック競合の原因になる。外部APIが成功してDBが失敗した場合の扱いも曖昧になる。

**直し方:** 外部I/OをTXの外に出し、TXは書き込みの整合性単位に絞る。

```rust
let result = ds_api.assess(&draft).await?;           // 1. 外部I/O（TXなし）
let saved = {                                        // 2. 短いTXで一括保存
    let mut tx = pool.begin().await?;
    let id = insert_assessment(&mut tx, &draft).await?;
    insert_results(&mut tx, id, &result).await?;
    tx.commit().await?;
    ...
};
dispatch_background_jobs(&saved).await;              // 3. 後続ジョブはTX外
```

「検索 → 外部API → TX保存 → ジョブ投入」の各段の失敗時にどの状態で止まるかを
指摘の中で言語化する。中間状態が許容できないなら、状態カラム＋再実行で回収する設計を提案する。

**指摘しない条件:** TX内のI/Oが同一DBへのクエリのみの場合（それは普通のTX）。

---

## ケース15: 並行リクエストの競合をアプリ側チェックで守る

**症状:** 「既存の件数を SELECT で数えて次の連番を決めて INSERT」のような
read-modify-write が、トランザクションだけで守られている（分離レベルによっては守られない）。

**なぜ:** 同時リクエストで同じ番号を二重採番する。Rustの型システムはプロセス内の
競合は守れるが、DB越しの競合は守れない。DB側の機構が必要。

**直し方:** `SELECT ... FOR UPDATE` で行ロックを取る、DBの一意制約に最終防衛させる、
または楽観ロック（versionカラム）。どれを選ぶかは競合頻度と失敗時のUXで決める。
一意制約違反をエラー型の variant として受け、リトライまたはユーザーエラーに翻訳する。

**指摘しない条件:** 単一ワーカー構成が保証されている、または一意制約が既に張られていて
違反時のハンドリングもある場合。
