# Railsのロジック配置シグナル

いずれも調査の入口。名前、行数、副作用の存在だけで移動を勧めず、責務分散や変更・検証への具体的な影響を示す。

### 1. Service → PORO 推奨
`app/services/` 内の処理に、独立した概念として取り出す実益のあるドメイン知識があるかを見る。副作用の有無や配置名だけでは判断しない。
- 外部への副作用（DB書き込み・API呼び出し・メール送信等）がない
- `call` メソッド内が自己完結した計算・判定・変換のみ
- 他オブジェクトへの委譲が1つ以下
- 例: `TaxCalculationService`→`TaxCalculator`、`CsvParseService`→`CsvParser`、`EligibilityCheckService`→`EligibilityPolicy`

### 2. Model/PORO → Service 推奨
モデルやPOROにオーケストレーションが混入している。
- モデル内に他モデルの更新や外部サービス呼び出しを含むメソッドがある
- `after_save` / `after_commit` で複雑なオーケストレーションをしている
- POROが複数のActiveRecordモデルを直接 create/update/destroy している
- トランザクションブロックがモデルのメソッド内にある
- 例: `User#create_with_profile_and_send_welcome_email`、`Order#process!` 内で決済・在庫・通知を実行、`after_create :sync_to_external_system, :send_notification, :update_analytics`

### 3. Controller → Model/PORO 推奨
コントローラ、APIコントローラ、serializer、helper、view用privateメソッドにドメイン知識が混入している。
単なるJSONキー名の整形、HTTPステータス制御、薄いDTO詰め替えは対象外。
以下のように「値の意味」「状態の解釈」「派生状態の決定」を知っていないと書けない処理を対象にする。

- privateメソッドがモデル固有の値表現（enum、bitmask、三値状態、初期値、リセット値など）を解釈・変換している
- 保存値、初期値、推奨値、外部分析結果、デフォルト値などの優先順位をコントローラが決めている
- `nil` / `0` / 空配列 / 空文字などの意味づけがモデルや業務ルールに依存している
- 表示用・API用の派生状態を作るために、複数のドメイン概念を組み合わせて判定している
- 同種の値変換、fallback、派生状態構築が複数コントローラやserializerに重複している

提案先は、既存の責務に合わせて選ぶ。
- モデル自身の概念・不変条件ならモデルメソッド
- API表示用・フォーム表示用の派生状態なら ResponseBuilder / FormState / Presenter などのPORO
- 外部I/OやDB更新を伴う手順ならService

### 4. Fat Model 検出
ActiveRecordモデルに埋もれた抽出可能なドメインロジック。
- privateメソッドが増え、モデル本来の責務と無関係な変更理由が混在している（個数だけで判定しない）
- concernsの中身がモデルの責務と無関係な計算ロジック
- メソッドが `self`（インスタンス属性）を参照せず引数だけで完結する
- `calculate_xxx` / `format_xxx` / `validate_xxx_logic` 系メソッドが多い
- 同じ計算ロジックが複数モデルに重複している

### 5. 集約設計の提案
[SKILL.md](../SKILL.md) の集約判断に加え:
- 子モデルのバリデーションが `parent.status` 等の親状態を参照している
- 複数モデルにまたがる計算結果の整合性（例: OrderItemの合計とOrder.total_amountの一致）

提案には必ず次を含める: 集約ルートのクラス名 / 含まれるモデル範囲 / 保証する不変条件 / 永続化の責務（リポジトリ or サービス）。
