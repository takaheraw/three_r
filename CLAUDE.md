# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

threeR - 世田谷区「さんあ〜る」ゴミ収集カレンダーをスクレイピングし、Gmail経由でメール通知するシステム。

## Commands

```bash
bundle install                        # 依存インストール
bundle exec ruby bin/fetch            # 今月のカレンダー取得
bundle exec ruby bin/fetch 2026 4     # 年月指定で取得
bundle exec ruby bin/notify           # 通知送信（翌日にゴミ収集があれば）
```

テストフレームワーク・リンターは未導入。

## Architecture

```
bin/notify → lib/three_r.rb → Config (ENV)
                             → ScheduleStore (out/*.json) ← CalendarParser (HTTP+Nokogiri)
                             → ScheduleEntry (Data.define)
                             → Notifier (Mail gem → Gmail SMTP)
```

- **エントリポイント**: `lib/three_r.rb` が全モジュールをrequireし、共有定数 `WDAYS` を定義
- **Config**: `define_method` メタプログラミングでENV変数(`AREA_ID`, `GMAIL_USER`, `GMAIL_PASSWORD`, `NOTIFY_TO`)のアクセサを動的生成
- **ScheduleEntry**: `Data.define(:date, :kinds)` による不変値オブジェクト。日付フォーマット・絵文字マッピングを集約
- **CalendarParser**: POSTリクエストでHTML取得 → Nokogiriでパース → `ScheduleEntry` 配列を返却
- **ScheduleStore**: `out/YYYY_MM.json` と `out/YYYY_MM.md` の読み書き。`ScheduleEntry` ⇔ JSON変換を担当
- **Notifier**: Mail gemでGmail SMTP送信。`ScheduleEntry` を受け取りメール本文を構築

## Ruby Style

- Ruby 4.0.1、モダン構文を積極使用: `Data.define`, `filter_map`, `case/in` パターンマッチング, endless methods, Hash shorthand (`key:`), numbered block params (`_1`)
- 環境変数は `.env` (dotenv) で管理、`.gitignore` 済み
- GitHub Actions (`notify.yml`) で毎日21:00 JST自動実行、Secretsで認証情報管理
