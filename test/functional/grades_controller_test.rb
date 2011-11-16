require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  setup do
    @grade = grades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade" do
    assert_difference('Grade.count') do
      post :create, grade: @grade.attributes
    end

    assert_redirected_to grade_path(assigns(:grade))
  end

  test "should show grade" do
    get :show, id: @grade.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grade.to_param
    assert_response :success
  end

  test "should update grade" do
    put :update, id: @grade.to_param, grade: @grade.attributes
    assert_redirected_to grade_path(assigns(:grade))
  end

  test "should destroy grade" do
    assert_difference('Grade.count', -1) do
      delete :destroy, id: @grade.to_param
    end

    assert_redirected_to grades_path
  end
end
