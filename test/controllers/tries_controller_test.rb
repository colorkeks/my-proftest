require 'test_helper'

class TriesControllerTest < ActionController::TestCase
=begin
  setup do
    @try = tries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create try" do
    assert_difference('Try.count') do
      post :create, try: { date: @try.date, rate: @try.rate, test_id: @try.test_id, user_id: @try.user_id }
    end

    assert_redirected_to try_path(assigns(:try))
  end

  test "should show try" do
    get :show, id: @try
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @try
    assert_response :success
  end

  test "should update try" do
    patch :update, id: @try, try: { date: @try.date, rate: @try.rate, test_id: @try.test_id, user_id: @try.user_id }
    assert_redirected_to try_path(assigns(:try))
  end

  test "should destroy try" do
    assert_difference('Try.count', -1) do
      delete :destroy, id: @try
    end

    assert_redirected_to tries_path
  end
=end
end
