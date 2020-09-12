class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, length: { maximum: 140 }
  
  validates :image, presence: true, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'],
                     message: "must be a valid image format" },
                        size: { less_than: 5.megabytes,
                               message: "shoud be less than 5MB" }
                               
  #投稿にいいねする
  def like(user)
    favorites.create(user_id: user.id)
  end
  
  #いいねを削除
  def unlike(user)
    favorites.find_by(user_id: user.id).destroy
  end
  
  #投稿がユーザーにお気に入りに入っているかどうか
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end              
                
  # 表示用のリサイズ済み画像を返す
  def square_image
    image.variant(resize_to_fill: [400, 400])
  end
  
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
  
  def create_notification_like!(current_user)
    #すでにいいねされているかを検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and micropost_id = ? and action = ?", current_user.id, user_id, id, 'like'])
    #いいねされていなければレコードを作成する
    if temp.blank?
      notification = current_user.active_notifications.new(
        micropost_id: id,
        visited_id: user_id,
        action: 'like'
      )
      #自分の投稿へのいいねは通知済みにする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end
  
  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
  # 投稿を検索する
  def self.search(search)
    if search
      where(['content LIKE ?', "%#{search}%"])
    else
      all
    end
  end
end
