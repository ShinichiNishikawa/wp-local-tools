# WordPress Local Tools

Let's automate installing WordPress, creating remote backups, starting coding themes with gulp, all by one command.

WordPress を使う人たちの開発や運用の作業を楽ちんにするローカルのツールキットです。

WordPress のインストール、リモート環境のバックアップ作成、gulp を使ったテーマ開発のスタートアップなどをコマンド一つで半自動化しちゃいましょう。

## 要件

このツールを利用するために必要なツールは以下のものになります。

- [Command line interface for WordPress | WP-CLI](http://wp-cli.org/)
- [welaika/wordmove: Capistrano for Wordpress](https://github.com/welaika/wordmove)
- [Git](https://git-scm.com/)

## ツールの紹介

### WP Backup

クライアントワークなどで、バックアップやアップデートをコマンド一つで実行するためのものです。

リモート環境と対になっているローカル環境で実すると、以下の処理が行われます。

- ドロップボックス内に`/Backups/{フォルダ名}/{現在時刻}/ フォルダを作ります。
- ローカル環境のDBのバックアップを上記フォルダに保存します。
- リモート環境から WordPress のコアファイル、テーマ、プラグイン、メディアなどのすべてのファイル（の差分）をダウンロード。
- リモート環境のデータベースのダンプファイルを作成、ダウンロードし、ローカルにインポートし、ドメイン名を置換。
- WordPress とプラグインをすべてアップデート
- このスクリプト自体が実行した処理のログをテキストファイルにして上記フォルダに保存。
- クライアントに報告するためのメールの本文を作成。

### WP init

WordPress の新規プロジェクトを作成する際に便利です。新しいディレクトリで実行すると以下の処理が行われます。

- WordPress のコアファイルのダウンロード。
- wp-config.php を作成
- データベースの作成 
- WP_DEBUG を trueにセット
- Movefile, wp-cli.local.yml, .gitignore のテンプレートを設置

### Theme init

テーマの開発がすぐに始められるように環境設定を勝手にしてくれます。

テーマフォルダの中で実行すると、以下の処理が行われます。

- テーマの開発をすぐに始めるための環境設定
  - sass
  - auto prefixer
  - browser sync
  - sass source map
- ブラウザで表示
- テーマフォルダ内の変更を検知してブラウザリロード

## 使い方

このレポジトリをクローンして、実行可能にして使ってください。










