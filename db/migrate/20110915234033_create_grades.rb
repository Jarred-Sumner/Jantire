class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :assignment_id
      t.integer :user_id
      t.integer :scribd_id
      t.decimal :score
      t.text :note

      t.timestamps
    end
  end
end
