class Course < ActiveRecord::Base
	has_and_belongs_to_many :users 
	has_many :assignments
	def teacher
		self.users.find_by_teacher(true)
	end

	def teacher?
		self.teacher
	end

	def students
		self.users.where(:teacher => false)
	end
	validates_presence_of :name
end
