class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :user_name
      t.string :hash_tag

      t.timestamps null: false
    end
  end
end
