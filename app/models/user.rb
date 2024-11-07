class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :posts, dependent: :destroy

  # 管理者を「集計担当」として定義
  ADMIN_USERS = ['集計担当'].freeze
  # 管理者をデータベースから取得するスコープを定義
  scope :admin_users, -> { where(name: ADMIN_USERS) }

  # 投稿者を定義
  POSTER_USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５].freeze
  # 投稿者をデータベースから取得するスコープを定義
  scope :poster_users, -> { where(name: POSTER_USERS) }

  # すべてのユーザーを定義
  USERS = %w[投稿者１ 投稿者２ 投稿者３ 投稿者４ 投稿者５ 集計担当].freeze
  # すべてのユーザーをデータベースから取得するスコープを定義
  scope :users, -> { where(name: USERS) }

  # セッションからユーザーを取得
  def self.find_from_session(session)
    user_id = session[:user_id]
    find_by(id: user_id) if user_id.present?
  end

  # QRコード生成メソッドを実行
  def generate_qr_code_for_login_poster_redirect
    login_poster_redirect_url = generate_login_poster_redirect_url
    generate_qr_code_for_login_poster_redirect_svg(login_poster_redirect_url)
  end

  private

  # login_poster_redirect のURLを取得
  def generate_login_poster_redirect_url
    Rails.application.routes.url_helpers.login_poster_redirect_user_url(
      self,
      host: 'https://device-expansion.onrender.com'
    )
  end

  # QRコードをSVG形式で生成
  def generate_qr_code_for_login_poster_redirect_svg(url)
    qrcode = RQRCode::QRCode.new(url)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 3,
      standalone: true
    )
  end
end
