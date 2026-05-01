# 関数型DDD in Rust — パターン詳細

SKILL.md の中核パターンの詳細版。対話中、ユーザーが具体的な書き方を知らなさそうな時や、トレードオフを提示する時に必要な部分だけ読む。全部を先に読む必要はない。

## 目次

1. [newtype pattern](#newtype-pattern)
2. [Smart Constructor](#smart-constructor)
3. [状態型分離](#状態型分離)
4. [Make Illegal States Unrepresentable](#make-illegal-states-unrepresentable)
5. [Railway Oriented Programming](#railway-oriented-programming)
6. [DTO 境界](#dto-境界)
7. [永続化分離](#永続化分離)
8. [型シグネチャ契約](#型シグネチャ契約)

---

## newtype pattern

プリミティブに意味を持たせる。

```rust
// Before: 引数の取り違えに気付けない
fn charge(user_id: i32, amount: i32) { ... }

// After: 型で区別
struct UserId(i32);
struct Amount(u64); // 負の金額が表現不可能

fn charge(user_id: UserId, amount: Amount) { ... }
```

**使うべきサイン**: 関数シグネチャに同じプリミティブ型の引数が2つ以上並んだら検討。IDや金額、コード値は大半がnewtype候補。

**やり過ぎの兆候**: 1回しか使わない内部ヘルパーにまで newtype を作っている。ドメインの「名前を持つ概念」にだけ使う。

---

## Smart Constructor

値の生成時に検証を走らせ、「不正な値を持つインスタンスが存在しない」を型で保証する。

```rust
pub struct String50(String);

impl String50 {
    pub fn new(s: impl Into<String>) -> Result<Self, ValidationError> {
        let s = s.into();
        if s.is_empty() || s.chars().count() > 50 {
            return Err(ValidationError::InvalidLength);
        }
        Ok(Self(s))
    }

    pub fn as_str(&self) -> &str { &self.0 }
}
```

**重要**: フィールドは `pub` にしない。`new` を経由しないと作れないようにする。これで「`String50` が存在する = 長さ制約は満たされている」が不変条件になる。

**トレードオフ**: 検証失敗が `Result` になるため、呼び出し側が毎回扱う必要がある。DTO境界で一度検証すれば、以降のドメインロジックでは安心して使える。

---

## 状態型分離

同じ概念の異なる状態を、**別々の型**として表現する。

```rust
// Before: 1つの型が全状態を兼ねる
struct Order {
    status: String,  // "draft" | "validated" | "paid"
    items: Vec<Item>,
    payment_id: Option<PaymentId>,  // paidの時だけ意味がある
}

// After: 状態ごとに型を分ける
struct UnvalidatedOrder { items: Vec<RawItem> }
struct ValidatedOrder   { items: NonEmptyList<ValidItem> }
struct PaidOrder        { items: NonEmptyList<ValidItem>, payment: PaymentId }
```

**効果**:
- `fn ship(order: PaidOrder)` のように、関数が要求する状態を型で表明できる
- 未検証の注文を発送関数に渡すとコンパイルエラー

**状態遷移は関数で表現**:

```rust
fn validate(o: UnvalidatedOrder) -> Result<ValidatedOrder, ValidationError>;
fn pay(o: ValidatedOrder, payment: PaymentId) -> PaidOrder;
```

**トレードオフ**: 状態数が多いと型も増える。5つ以上になるなら、状態を軸で分解できないか再検討（例: `PaymentState` と `ShippingState` を独立させる）。

---

## Make Illegal States Unrepresentable

最重要原則。**矛盾する状態の組み合わせが型レベルで作れない**ようにする。

### アンチパターン: フラグ + Option

```rust
struct Customer {
    email: String,
    is_email_verified: bool,         // これと
    verified_at: Option<DateTime>,   // これが矛盾しうる
}
// is_email_verified = true だが verified_at = None のインスタンスが作れてしまう
```

### ベストパターン: enum で状態を保持

```rust
enum CustomerEmail {
    Unverified { address: EmailAddress },
    Verified { address: EmailAddress, verified_at: DateTime<Utc> },
}

struct Customer {
    email: CustomerEmail,
    // ...
}
```

「検証済みなら `verified_at` が必ずある」が型で保証される。

### AND/OR による構造化の指針

- **全部必要 → struct (AND)**: 注文には商品も金額も配送先も**全部**必要
- **どれか1つ → enum (OR)**: 支払い方法は「クレカ**か**銀行振込**か**コンビニ」

ユーザーの説明から「〜かつ〜」「〜または〜」を拾って構造に落とす。

---

## Railway Oriented Programming

複数のステップを `Result` で連結し、どこかで失敗したら以降をバイパス。

```rust
fn place_order(input: UnvalidatedOrder) -> Result<PaidOrder, OrderError> {
    let validated = validate(input)?;
    let priced = price(validated)?;
    let paid = charge(priced)?;
    Ok(paid)
}
```

**エラー型の設計**:

```rust
enum OrderError {
    Validation(ValidationError),
    Pricing(PricingError),
    Payment(PaymentError),
}
```

`thiserror` で `From` を自動導出すると `?` が自然に動く。

**やらない方がいい**: `Result<_, String>` や `Result<_, Box<dyn Error>>` を多用。どのステップで何が起きたかが型から失われる。

---

## DTO 境界

外部の世界（HTTP、DB、ファイル）との境界で、プリミティブな DTO とドメイン型を変換する。

```rust
// DTO: serde でシリアライズ可能、制約なし
#[derive(Deserialize)]
struct CreateOrderDto {
    email: String,
    quantity: i32,
}

// Domain: 制約付き
struct CreateOrderCommand {
    email: EmailAddress,
    quantity: PositiveInt,
}

impl TryFrom<CreateOrderDto> for CreateOrderCommand {
    type Error = ValidationError;
    fn try_from(dto: CreateOrderDto) -> Result<Self, Self::Error> {
        Ok(Self {
            email: EmailAddress::new(dto.email)?,
            quantity: PositiveInt::new(dto.quantity)?,
        })
    }
}
```

**原則**: ハンドラ層で DTO を受け、`try_into()` でドメイン型に変換してからユースケースに渡す。**ドメイン層は DTO を知らない**。

---

## 永続化分離

ドメインロジックは純粋関数にし、I/O はワークフローの**端**だけで行う。

```rust
// ワークフロー = 純粋関数
fn validate_order(
    check_product_exists: impl Fn(&ProductCode) -> bool,
    order: UnvalidatedOrder,
) -> Result<ValidatedOrder, ValidationError> {
    // I/O はしない。渡された関数を呼ぶだけ
}

// ユースケース層で I/O をつなぐ
async fn place_order_usecase(input: UnvalidatedOrder, repo: &Repo) -> Result<()> {
    let check = |code: &ProductCode| repo.exists(code);
    let validated = validate_order(check, input)?;  // 純粋
    repo.save(validated).await?;                     // I/O は端
    Ok(())
}
```

**効果**: `validate_order` はモックなしでテストできる。関数を渡すだけ。

---

## 型シグネチャ契約

ワークフロー全体を、実装より先に**関数シグネチャの連なり**として設計する。

```rust
// 実装より先に、型で契約を書く
type ValidateOrder = fn(UnvalidatedOrder) -> Result<ValidatedOrder, ValidationError>;
type PriceOrder   = fn(ValidatedOrder)   -> Result<PricedOrder, PricingError>;
type SendAck      = fn(&PricedOrder)     -> Result<(), SendError>;
```

シグネチャだけ先に固めると、**各ステップの責務と依存が明確になる**。実装は後から埋める。

---

## よくある質問への回答テンプレ

ユーザーからこう聞かれたら、だいたいこう答える：

- **「newtype 毎回作るの面倒では？」** → ドメインの中心概念だけで十分。1回しか登場しない一時的な値は普通の型で良い。
- **「enum 分けすぎでパターンマッチが大変」** → 状態を軸で分解できないか。`PaymentStatus` と `ShippingStatus` を別フィールドにすれば組み合わせで表現できる。
- **「DB スキーマが Optional だらけだけど？」** → それはスキーマの都合。ドメイン型はスキーマを反映するのではなく、不変条件を反映する。変換層を挟む。
- **「trait で抽象化しなくていい？」** → まず struct/enum で具体的に形を出してから、本当に必要なら trait 化する。抽象化は後から足せる。
