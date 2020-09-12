class AddPhotoToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :photo, :string
  end
end
