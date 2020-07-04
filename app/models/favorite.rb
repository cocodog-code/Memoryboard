class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  #一つの投稿につき、一人１いいねしかできないようにする
  validates :user_id, uniqueness: { scope: :micropost_id }
  validates :micropost_id, presence: true
end
