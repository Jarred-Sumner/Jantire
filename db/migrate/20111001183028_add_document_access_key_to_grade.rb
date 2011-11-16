class AddDocumentAccessKeyToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :document_access_key, :string
  end
end
