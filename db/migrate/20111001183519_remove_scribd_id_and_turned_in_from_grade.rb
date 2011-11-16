class RemoveScribdIdAndTurnedInFromGrade < ActiveRecord::Migration
  def up
    remove_column :grades, :scribd_id
    remove_column :grades, :turned_in
  end

  def down
    add_column :grades, :turned_in, :boolean
    add_column :grades, :scribd_id, :integer
  end
end
