class RemoveScribdIdAndHandoutFromAssignment < ActiveRecord::Migration
  def up
    remove_column :assignments, :scribd_id
    remove_column :assignments, :handout
  end

  def down
    add_column :assignments, :handout, :binary
    add_column :assignments, :scribd_id, :integer
  end
end
