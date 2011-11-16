class AddDocumentIdToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :document_id, :integer
  end
end
