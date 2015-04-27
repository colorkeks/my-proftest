class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  delegate :can?, :cannot?, :to => :ability
  load_and_authorize_resource
  # GET /users
  # GET /users.json

  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @users = User.search(params[:search_users])
    @user_id = params[:id]
    @attestation_tests = Test.find(@user.attestation_tests)
    @test = Test.new
  end

  def custom_create
    @user = User.create!(user_params)
    respond_to do |format|
        format.html { redirect_to current_user, notice: 'Пользователь успешно создан' }
        format.json { render :show, status: :created, location: @user }
    end
  end

  def profile
    @tests_search = Test.search(params[:search_tests])
    @attestation_tests = Test.find(@user.attestation_tests)
  end

  def add_attestation_tests
    if params[:attestation_id].nil?
      redirect_to profile_user_path(@user), alert: 'Вы не выбрали тест'
    else
      @attestation_test = Test.find(params[:attestation_id])
      if @attestation_test.attestation == false
        redirect_to profile_user_path(@user), alert: 'Тест не аттестационный'
      else
        @user.attestation_tests << params[:attestation_id]
        if @user.save
          redirect_to profile_user_path(@user), notice: 'Тест успешно добавлен'
        end
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
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
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
      format.html { redirect_to current_user, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @tests = Test.all
    @tries = Try.all.where(:user_id => params[:id])
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :second_name, :last_name, :attestation_tests, :job, :email, :password, :password_confirmation)
  end
end
