# threeR - ゴミの日通知システム

世田谷区の「さんあ〜る」ゴミ収集カレンダーをスクレイピングし、ゴミの種類をGmail経由でメール通知するシステム。

## セットアップ

### 必要環境

- Ruby 4.0.9 ([mise](https://mise.jdx.dev/) で管理)

### インストール

```bash
bundle install
```

### 環境変数

`.env` ファイルをプロジェクトルートに作成:

```
GMAIL_USER=your-email@gmail.com
GMAIL_PASSWORD=xxxxxxxxxxxxxxxx  # Googleアプリパスワード（スペースなし16文字）
NOTIFY_TO=recipient@example.com
AREA_ID=60157
```

- `GMAIL_PASSWORD` は [Googleアプリパスワード](https://myaccount.google.com/apppasswords) を使用（2段階認証が必要）
- `AREA_ID` は世田谷区の町丁目に対応する番号

## 使い方

### カレンダー取得

```bash
# 今月分を取得
bundle exec ruby bin/fetch

# 年月を指定して取得
bundle exec ruby bin/fetch 2025 6
```

`out/YYYY_MM.json` と `out/YYYY_MM.md` が生成されます。

### 通知送信

```bash
bundle exec ruby bin/notify
```

ゴミ収集があればメール送信、なければサイレント終了します。
カレンダーが未取得の場合は自動的にfetchします。

### 通知メールの例

```
件名: 🗑️ 3/16(月) 可燃ごみ

📅 3/16(月)

  🔥 可燃ごみ

──────────────
ゴミ収集通知 by three_r
```

| 種別 | 絵文字 |
|---|---|
| 可燃ごみ | 🔥 |
| 不燃ごみ | 🪨 |
| 資源 | ♻️ |
| ペットボトル | 🧴 |

## GitHub Actions

毎日 18:17 JST に自動実行されます（GitHub 側の都合で数時間遅れることがあります）。手動実行も可能です。

通知対象は、正午より前の起動なら当日、正午以降なら翌日の収集です。

### 必要な Secrets

リポジトリの Settings > Secrets and variables > Actions に設定:

| Secret | 説明 |
|---|---|
| `AREA_ID` | 地域コード |
| `GMAIL_USER` | Gmailアドレス |
| `GMAIL_PASSWORD` | Googleアプリパスワード（スペースなし16文字） |
| `NOTIFY_TO` | 通知先メールアドレス |

## ファイル構成

```
.github/workflows/
  notify.yml           # GitHub Actions ワークフロー
bin/
  fetch                # カレンダー取得 → out/ に保存
  notify               # ゴミを確認 → メール送信
lib/
  three_r.rb           # トップレベルモジュール（定数・require集約）
  three_r/
    config.rb          # ENV設定（メタプログラミングで動的生成）
    schedule_entry.rb  # Data.define による値オブジェクト
    calendar_parser.rb # HTML取得 + パース
    schedule_store.rb  # JSON/Markdown 読み書き
    notifier.rb        # Gmail SMTP送信
out/                   # 生成データ (gitignored)
```
