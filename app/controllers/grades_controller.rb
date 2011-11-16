class GradesController < ApplicationController
  before_filter :authenticate_user!, load_and_authorize_resource
  
  # GET /grades
  # GET /grades.json
  def index
    if params[:assignment_id] && current_user.teacher?
      @assignment = Assignment.find(params[:assignment_id])
      @grades = @assignment.grades
    elsif params[:id] && current_user.teacher?
      @user = User.find(params[:id])
    elsif current_user.teacher?
      @assignments = current_user.assignments
    else
      @user = current_user
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @assignment.to_json(:include => :grades ) } 
    end
  end

  # GET /grades/1
  # GET /grades/1.json
  def show
    @grade = Grade.find(params[:id])
    respond_to do |format|
      format.html 
      format.json { render :json => @grade.as_json(:include => :assignment) }
    end
  end

  # GET /grades/new
  # GET /grades/new.json
  def new
    @grade = Grade.new

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @grade }
    end
  end

  # GET /grades/1/edit
  def edit
    @grade = Grade.find(params[:id])
    redirect_to "/assignments/#{@grade.assignment_id}/turned_in" if current_user.teacher?
  end

  # POST /grades
  # POST /grades.json
  def create
    @grade = Grade.new(params[:grade])
    respond_to do |format|
      if @grade.save
        @grade.upload_to_scribd!
        format.html { redirect_to "/assignments/#{@grade.assignment_id}" }
        format.json { render json: @grade, status: :created, location: @grade }
      else
        puts "Errors: #{@grade.errors.inspect}"
        format.html { redirect_to "/404.html" }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grades/1
  # PUT /grades/1.json
  def update
    @grade = Grade.find(params[:id])
    if @grade.update_attributes(params[:grade])
      respond_to do |format|
        format.html { redirect_to "/assignments/#{@grade.assignment_id}/show" } unless @grade.graded
        format.json { head :ok }
      end
    end
  end

  # DELETE /grades/1
  # DELETE /grades/1.json
  def destroy
    @grade = Grade.find(params[:id])
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to grades_url }
      format.json { head :ok }
    end
  end
end
