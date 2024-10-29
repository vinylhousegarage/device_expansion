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
    session[:user_id] = params[:id]
    user_id = session[:user_id]
    find_by(id: user_id) if user_id.present?
  end

  # QRコードを生成
  def generate_qr_code(session)
    url = Rails.application.routes.url_helpers.user_url(
      self,
      host: 'https://device-expansion.onrender.com',
      params: { session_id: session[:user_id] }
    )

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
