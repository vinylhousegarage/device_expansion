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

  # セッションからユーザーを取得
  def self.find_from_session(session)
    user_id = session[:user_id]
    find_by(id: user_id) if user_id.present?
  end

  # id情報を含んだ QRコード読み取りによる遷移先の URL を変数に代入
  def generate_qr_code(session)
    new_post_url = generate_new_post_url(session)
    generate_qr_code_svg(new_post_url)
  end

  private

  # ログインフォームURL の id を取得
  # id情報を含んだ QRコード読み取りによる遷移先の URL を生成
  def generate_new_post_url(session)
    Rails.application.routes.url_helpers.new_post_url(
      host: 'https://device-expansion.onrender.com',
      params: { session_id: session[:user_id], ref: login_form_url }
    )
  end

  # ログインフォームURLを取得
  def login_form_url
    Rails.application.routes.url_helpers.login_form_user_url(
      self,
      host: 'https://device-expansion.onrender.com'
    )
  end

  # QRコードをSVG形式で出力
  def generate_qr_code_svg(new_post_url)
    qrcode = RQRCode::QRCode.new(new_post_url)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 3,
      standalone: true
    )
  end
end
