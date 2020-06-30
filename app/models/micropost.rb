class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, length: { maximum: 140 }
  validates :image, presence: true, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg'],
                     message: "must be a valid image format" },
              size:   { less_than: 5.megabytes,
                              message: "shoud be less than 5MB" }
  # 表示用のリサイズ済み画像を返す
  def square_image
    image.variant(resize_to_fill: [400, 400])
  end
  
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
