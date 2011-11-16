class AddAttachmentAnswerToGrade < ActiveRecord::Migration
  def self.up
    add_column :grades, :answer_file_name, :string
    add_column :grades, :answer_content_type, :string
    add_column :grades, :answer_file_size, :integer
    add_column :grades, :answer_updated_at, :datetime
  end

  def self.down
    remove_column :grades, :answer_file_name
    remove_column :grades, :answer_content_type
    remove_column :grades, :answer_file_size
    remove_column :grades, :answer_updated_at
  end
end
