# kesuzo-s3
オブジェクト数が多すぎて消せないS3のバケットをガッと消すツール

## 使い方

```
$ vim ~/.aws/credentials
[default]
aws_access_key_id = <アクセスキー>
aws_secret_access_key = <シークレットアクセスキー>

$ git clone https://github.com/buty4649/kesuzo-s3.git
$ cd kesuzo-s3
$ bundle install
$ bundle exec exec/kesuzo-s3 exec <バケット名>
```

## Tips
私が試したところ秒間450オブジェクト消せました(東京リージョン)。
