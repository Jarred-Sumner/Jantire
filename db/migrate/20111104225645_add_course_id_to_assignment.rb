class AddCourseIdToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :course_id, :integer
  end
end
