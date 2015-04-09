require 'test_helper'

class UserAssociationsControllerTest < ActionController::TestCase
  setup do
    @user_association = user_associations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_associations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_association" do
    assert_difference('UserAssociation.count') do
      post :create, user_association: { answer_id: @user_association.answer_id, serial_number: @user_association.serial_number, task_id: @user_association.task_id, text: @user_association.text }
    end

    assert_redirected_to user_association_path(assigns(:user_association))
  end

  test "should show user_association" do
    get :show, id: @user_association
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_association
    assert_response :success
  end

  test "should update user_association" do
    patch :update, id: @user_association, user_association: { answer_id: @user_association.answer_id, serial_number: @user_association.serial_number, task_id: @user_association.task_id, text: @user_association.text }
    assert_redirected_to user_association_path(assigns(:user_association))
  end

  test "should destroy user_association" do
    assert_difference('UserAssociation.count', -1) do
      delete :destroy, id: @user_association
    end

    assert_redirected_to user_associations_path
  end
end
