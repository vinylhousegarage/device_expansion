## みんなで香典集計

### 1. 概要
  - **目的**
    - 通夜・葬儀でいただいた香典の情報を複数の投稿者で分担して入力し、入力された情報を一元管理のもとで集計する。
      - 複数の投稿者が、自身が所有するスマートフォンで、通夜・葬儀でいただいた香典の情報を投稿
      - 管理者が、自身が所有するスマートフォンで、全体の集計を確認
  - **範囲**
    - **投稿者**
      - 香典の情報を投稿するための権限を持つユーザー
      - あらかじめ設定された「投稿者１」～「投稿者５」
    - **管理者**
      - 投稿者を招待する権限と、投稿と集計を管理する権限を合わせ持つユーザー
      - あらかじめ設定された「集計担当」
### 2. 機能要件
  - **投稿者機能**
     - 香典の「お名前、金額、住所、電話番号、備考」の投稿
     - 投稿の編集と削除
     - 投稿件数と合計金額の表示
  - **管理者機能**
    - QRコードによる投稿者の招待
    - 投稿総数と合計金額の確認
    - 投稿者別の投稿件数と合計金額の表示
    - 投稿の編集と削除

### 3. データ要件
  - **usersテーブル**

    | カラム名 | データ型 | 制約 | 説明 |
    |---|---|---|---|
    | id | bigint | PRIMARY KEY | 投稿者・管理者の一意な識別子 |
    | name | string || 投稿者・管理者の名前|
    | created_at | timestamp(6) without time zone | not null | 設定日時 |
    | updated_at | timestamp(6) without time zone | not null | 編集日時 |

  - **postsテーブル**

    | カラム名 | データ型 | 制約 | 説明 |
    |---|---|---|---|
    | id | bigint | PRIMARY KEY | 投稿の一意な識別子 |
    | name | string || お名前 |
    | amount | integer || 金額 |
    | address | string || 住所 |
    | tel | string |  | 電話番号 |
    | others | string || 備考 |
    | user_id | bigint | FOREIGN KEY (users.id) | 投稿者・管理者を参照する外部キー |
    | created_at | timestamp(6) without time zone | not null | 投稿日時 |
    | updated_at | timestamp(6) without time zone | not null | 編集日時 |

  - **初期データ**
    ```ruby
    USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５ 集計担当].freeze
    USERS.each do |user_name|
      User.find_or_create_by(name: user_name)
    end
    ```

### 4. システム要件
  - **技術スタック**
    - プログラミング言語：Ruby 3.1.0
    - フレームワーク：Ruby on Rails 7.0.8.4
    - データベース：PostgreSQL 14.13
    - バージョン管理：Git, GitHub, GitHub Container Registry
    - コンテナ化：Docker Compose
    - ホスティング：Render（アプリケーションの稼働サーバー）
    - CI/CD：GitHub Actions（テスト）/ Render（デプロイ）
    - テストフレームワーク：Minitest（単体・機能・統合テスト）/ capybara（システムテスト）

  - **インフラ要件**
    - サーバー構成：Puma, PostgreSQLサーバー
    - ネットワーク要件：RenderによるホスティングとDNS管理
    - ドメイン：https://device-expansion.onrender.com

  - **開発環境**
    - OS：Windows 10
    - エディタ/IDE：Visual Studio Code
    - コンテナ開発環境：Docker Compose
    - バージョン管理の方法
      - **ブランチ戦略**
        - mainブランチと作業ブランチ（featureブランチやtestブランチなど）に分けて管理
        - Pull Requestを通してmainブランチにマージ
        - 現在は個人開発であるため、コードレビューは任意で行うことが可能
      - コミットメッセージ規約
        - Conventional Commits (feature, fix, testなどを使用)
