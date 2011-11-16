class AddTurnedInAndGradedToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :turned_in, :boolean
    add_column :grades, :graded, :boolean
  end
end
