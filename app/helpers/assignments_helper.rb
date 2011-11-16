module AssignmentsHelper
  def next_due(current_user)
    @assignment = current_user.assignments.first
    unless @assignment.nil?
      @assignment.due.to_s
    end
  end
	# This returns an assignment's URL
	def next_due_link(current_user)
    @assignment = current_user.assignments.first
    unless @assignment.nil?
      "/assignments/#{@assignment.id}/edit"
    end
	end
  
end
