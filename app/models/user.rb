class User < ActiveRecord::Base
  has_many :grades
  has_and_belongs_to_many :courses
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :teacher, :courses, :course_ids

  validates_presence_of :first_name, :last_name, :password_confirmation, :courses, :message => " is needed to sign up"

  def none
    Assignment.where(:id => nil)
  end

  def full_name
  	self.first_name + " " + self.last_name
  end
  def student?
    true unless self.teacher?
  end
  def homework_for_grading
    @homework = []
    self.courses.each do |course|
      @homework += course.assignments.where("due < ?", Date.tomorrow).reject { |assignment| assignment.ready_for_grading? == false } if DateTime.now.hour > 14
      @homework += course.assignments.where("due < ?", Date.today).reject { |assignment| assignment.ready_for_grading? == false } unless DateTime.now.hour > 14
    end
    @homework
  end
  def homework(current_user)
    @homework = []
    self.courses.each do |course|
      @homework += course.assignments.where("due > ?", Date.today).reject { |assignment| assignment.graded?(current_user) }
    end
    @homework
  end
  def assignments
    @assignments = []
    self.courses.each do |course|
      @assignments += course.assignments.where("due > ?", Date.today)
    end
    @assignments.sort_by &:due
  end
end
