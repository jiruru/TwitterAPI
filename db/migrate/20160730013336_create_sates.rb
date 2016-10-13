class CreateSates < ActiveRecord::Migration
  def change
    create_table :sates do |t|

      t.timestamps null: false
    end
  end
end
