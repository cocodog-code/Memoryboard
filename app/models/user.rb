class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fav_posts, through: :favorites, source: :micropost
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy                      
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :full_name, presence: true, unless: :uid?, length: { maximum: 50 }
  validates :user_name, presence: true, unless: :uid?, length: { maximum: 50 }
  VALID_EMAIL_REGAX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, unless: :uid?, length: { maximum: 255 },
                format: { with: VALID_EMAIL_REGAX },
                uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },
  allow_nil: true, unless: :uid?
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
              WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
              OR user_id = :user_id", user_id: id)
  end
  
  def follow(other_user)
    following << other_user
  end
  
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def following?(other_user)
    following.include?(other_user)
  end
  
  def like(micropost)
    favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unlike(micropost)
    favorite = favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def self.from_omniauth(auth)
  user = User.where('email = ?', auth.info.email).first
  if user.blank?
     user = User.new
  end
  user.uid   = auth.uid
  user.username  = auth.info.name
  user.email = auth.info.email
  user.oauth_token = auth.credentials.token
  user.oauth_expires_at = Time.at(auth.credentials.expires_at)
  user
end
end
