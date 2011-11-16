class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.string :instructions
      t.date :due
      t.integer :scribd_id
      t.decimal :score

      t.timestamps
    end
  end
end
