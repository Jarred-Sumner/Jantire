class RemoveUserIdFromCourseId < ActiveRecord::Migration
  def up
    remove_column :courses, :user_id
  end

  def down
    add_column :courses, :user_id, :integer
  end
end
