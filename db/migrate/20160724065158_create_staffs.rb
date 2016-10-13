class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|

      t.integer :staff_id
      t.string  :staff_name
      t.integer :salary
      t.string  :belong
      t.integer :chief
      t.timestamps null: false
    end
  end
end
