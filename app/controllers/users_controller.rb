class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :profile, :modes_history]
  delegate :can?, :cannot?, :to => :ability
  load_and_authorize_resource
  # GET /users
  # GET /users.json

  def index
    @users = User.all
  end

  def test_persons
    @test_persons = Role.find_by(name: 'Тестируемый').users.order(:id).paginate(:page => params[:page], :per_page => params[:per_page] || 30)
    render 'test_persons', layout: 'admin'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user && current_user.role?('Методолог')
      redirect_to :test_groups
      return
    elsif current_user && current_user.role?('Администратор')
      redirect_to :doctors
      return
    end
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    @users = User.search(params[:search_users])
    @user_id = params[:id]
    # @attestation_tests = Test.find(@user.attestation_tests)
    @test = Test.new
  end

  def custom_create
    @user = User.create(user_params)
    @user.test_modes.build(name: 'Нейтральный', date_beg: Date.today)
      if @user.save
        redirect_to profile_user_path(@user), notice: 'Пользователь успешно создан'
      else
        redirect_to :back, alert: 'Пароль или Email не введен'
      end
  end

  def profile
    @test_mode = TestMode.new
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    @user_tries = Try.all.where(user_id: @user.id, test_mode_id: @current_mode.id) if @current_mode
    render 'users/profile', layout: 'admin'
  end

  def view_test_results
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    render 'users/view_test_results', layout: 'admin'
  end

  def print_test_results
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    render 'users/print_test_results', layout: 'admin'
  end

  def modes_history
    @test_modes = TestMode.all.where(user_id: @user.id)
    render 'users/modes_history', layout: 'admin'
  end

  def search_tests
    query = Test.search_test(params[:q], params[:mode])
    @tests = query.limit(5)
    @count = query.count
    render 'search', layout: false
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    render 'users/edit', layout: 'admin'
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Пользователь успешно создан.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_user_path, notice: 'Пользователь успешно обновлен.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Пользователь успешно удален.' }
      format.json { head :no_content }
    end
  end

  def add_find_stub
    render 'users/add_find_stub', layout: 'admin'
  end

  def profile_stub
    render 'users/profile_stub', layout: 'admin'
  end

  def search_stub
    render 'users/search_stub', layout: 'admin'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @tests = Test.all.where(:directory => false)
    @tries = Try.all.where(:user_id => params[:id])
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :second_name, :last_name, :birthday, :drcode,
                                 :job, :email, :password, :password_confirmation)
  end
end
