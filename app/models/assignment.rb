class Assignment < ActiveRecord::Base
  before_destroy :destroy_grades
  has_many :grades
  belongs_to :course

  def finished_grading?
    @grades = Grade.where(:assignment_id => self.id, :graded => false)
    true if @grades.empty?
  end
  def graded?(user)
    @grade = Grade.where(:user_id => user.id, :assignment_id => self.id).first
    @grade
  end
  def destroy_grades
    self.grades.each do |grade|
      grade.destroy
    end
  end
  def turned_in_at_all?
    true unless Grade.where(:assignment_id => self.id).empty?
  end
  def ungraded!
    # This is just here for development
    self.grades.each do |grade|
      grade.graded = false
      grade.score = nil
      grade.note = nil
      grade.save
    end
    self.due = Date.yesterday
    self.save
  end
  def ready_for_grading?
    # Doesn't check due dates because it's it gets the assignments by due date
    @ready = true
    @ready = false if not self.turned_in_at_all? or self.finished_grading? or self.grades.empty?
    @ready
  end
  validates_presence_of :name, :instructions, :due, :score, :course, :message => "This item is needed. Please fill it in."
end
