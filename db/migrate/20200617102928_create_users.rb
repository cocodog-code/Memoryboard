class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :full_name
      t.string  :user_name
      t.string  :email
      t.string  :website
      t.string  :introduction
      t.string  :phone_number
      t.integer :gender
      t.timestamps
    end
  end
end
