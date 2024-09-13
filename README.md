## リポジトリの概要
（リポジトリの目的や使い方などの概要を記載します）
### アーキテクチャ
![](/figure/architecture.drawio.png)
## リポジトリ内での個別ルール
（リポジトリ内での個別ルールがあれば記載してください）
### ブランチルール
（現状ブランチに関する統一ルールはありません。各リポジトリごとに作成し、ここに記載してください）
## 開発環境の概要および構築手順
### venvの構築&開始
python3 -m venv env
source env/bin/activate

### ライブラリのinstall
cd functions/src
pip install -r requirements.txt

## 開発手順
（開発時における作業の流れやトラブルシューティングなどを記載します）

### functionsのdeployコマンド
cd functions/src
gcloud functions deploy gcp_error_trapping --gen2 --runtime=python311 --region=us-central1 --source=. --entry-point=main --trigger-http --project=log-sinks

## 必要な環境変数やコマンド一覧
（環境変数の一覧およびコマンドの一覧を記載します）
## ディレクトリ構成
コマンド(仮想環境、環境変数以外のファイルを取ってくる)
tree -I 'env'

<pre>

</pre>
## その他必要事項
（上記以外に必要な事項があれば記載をお願いします）
## 参考資料
（コンフルなどGitHub外に参考資料があればリンクを貼っておいてください）
[コンフル](https://rizapg.atlassian.net/wiki/spaces/DATAMANAGEMENT/)