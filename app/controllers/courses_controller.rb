class CoursesController < ApplicationController
  before_filter :authenticate_user!, load_and_authorize_resource
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json =>  @courses }
    end
  end
  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # Join the course
  def join
    @course = Course.find(params[:id])
    @course.users.push(current_user) if @course.users.where(:id => current_user).empty?
    @course.save
    respond_to do |format|
      format.html { redirect_to courses_path, :notice => "Welcome to #{ @course.name }"}
    end
  end

  # Leave the course
  def leave
    @course = Course.find(params[:id])
    @course.users.delete(current_user)
    respond_to do |format|
      format.html { redirect_to courses_path, :notice => "Goodbye #{ @course.name }!"}
    end
  end
  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new
      respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])
    @course.users.push(current_user)
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :json =>  @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render :json =>  @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :ok }
    end
  end
end
