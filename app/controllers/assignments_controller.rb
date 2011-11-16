class AssignmentsController < ApplicationController
  before_filter :authenticate_user!, load_and_authorize_resource
  respond_to :html, :json, :js

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = current_user.homework_for_grading if current_user.teacher?
    @assignments = current_user.homework(current_user) if current_user.student?
    puts "Student: #{current_user.student?}"
    respond_with @assignments
  end
  
  # GET /assignments/1
  # GET /assignments/1.json
  def turn_in
    @assignment = Assignment.find(params[:id])
    @grade = Grade.where(:assignment_id => @assignment.id, :user_id => current_user.id).first
    @grade = Grade.create(:assignment_id => @assignment.id, :user_id => current_user.id) unless @grade
    respond_with @assignment
  end

  def egp
    @assignment = Assignment.find(params[:id])
    @grades = @assignment.grades.to_a
    respond_with @grades
  end

  def grade
    @assignment = Assignment.find(params[:id])
    @grades = @assignment.grades
    respond_with @assignment
  end

  # GET /assignments/new
  # GET /assignments/new.json
  def new
    @assignment = Assignment.new
    # Some nice defaults
    @assignment.due = Date.tomorrow
    @assignment.score = 10.0
    respond_with @assignment
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id])
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      redirect_to assignments_path # Shows turned in view
    else
      respond_with @assignment
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.json
  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      redirect_to "/assignments"
    else
      respond_with @assignment.errors
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    redirect_to "/assignments"
  end
end