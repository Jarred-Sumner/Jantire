class Grade < ActiveRecord::Base
  before_save :defaults
  belongs_to :assignment
  belongs_to :user
  has_attached_file :answer, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"

  def document
    Scribd::Document.find(self.document_id)
  end

  def upload_to_scribd!
    self.document_id = Scribd::Document.upload(:file => self.answer.url).id
    self.document_access_key = self.document.access_key
    self.save
    @document = self.document
    @document.title = self.answer_file_name
    @document.access = 'private'
    @document.tags = "#{ self.id },#{ self.assignment.id }"
    @document.show_ads = false
    @document.save
    puts "Document #{ self.document_id } uploaded successfully at #{ Time.now }"
  end

  def defaults
    self.graded = false if self.graded.nil?
  end
end
