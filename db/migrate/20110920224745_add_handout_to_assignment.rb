class AddHandoutToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :handout, :string
  end
end
