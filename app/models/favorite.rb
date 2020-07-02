class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  #モデルレベルでのuser_idの一意性を保つ
  validates :user_id, uniqueness: { scope: :board_id }
end
