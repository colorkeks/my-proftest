class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :profile, :modes_history, :generate_token, :clean_token, :personal_info]
  delegate :can?, :cannot?, :to => :ability
  load_and_authorize_resource
  # GET /users
  # GET /users.json

  def index
    @users = User.all
  end

  def test_persons
    @test_persons = User.includes(:roles).where(roles:{name: 'Тестируемый'}).order(:id).paginate(:page => params[:page], :per_page => params[:per_page] || 30)
    render 'test_persons', layout: 'admin'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user && current_user.roles.find(current_user.priority_role_id).name == 'Администратор'
      redirect_to :doctors
      return
    elsif current_user && current_user.roles.find(current_user.priority_role_id).name == 'Регистратор'
      redirect_to :doctors
      return
    elsif current_user && current_user.roles.find(current_user.priority_role_id).name == 'Методолог'
      redirect_to :test_groups
      return
    elsif current_user && current_user.roles.find(current_user.priority_role_id).name == 'Тестируемый'
      redirect_to testee_tab_users_path
      return
    end
  end

  def profile
    @test_mode = TestMode.new
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    @user_tries = Try.all.where(user_id: @user.id, test_mode_id: @current_mode.id) if @current_mode
    render 'users/profile', layout: 'admin'
  end

  def personal_info
    @avatars = Avatar.all.where(user_id: @user.id)
    render 'users/personal_info', layout: 'admin'
  end

  def view_test_results
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    render 'users/view_test_results', layout: 'admin'
  end

  def print_test_results
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    respond_to do |format|
      format.pdf do
        render pdf: @user.drcode ? @user.drcode + '_' + DateTime.now.strftime('%Y-%m-%d').to_s : @user.last_name + ' ' + DateTime.now.strftime('%Y-%m-%d').to_s , # Excluding ".pdf" extension.
               :page_size => 'A4',
               formats: :html, encoding: 'utf8'
      end
    end
  end

  def save_pdf
    @current_mode = @user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: @user.id, test_mode_id: @current_mode)
    respond_to do |format|
      format.pdf do
        file_name = @user.drcode ? @user.drcode + '_' + DateTime.now.strftime('%Y-%m-%d').to_s : @user.last_name + ' ' + DateTime.now.strftime('%Y-%m-%d').to_s + '.pdf'
        pdf = render_to_string pdf: file_name  , # Excluding ".pdf" extension.
               :page_size => 'A4',
               template: '/users/save_pdf.erb',
               formats: :html,
               encoding: 'utf8'
        send_data(pdf, filename: file_name , :type=> 'application/pdf', :disposition => "attachment; filename=#{file_name}.pdf")
      end
    end
  end

  def modes_history
    @test_modes = TestMode.all.where(user_id: @user.id).where.not(name: 'Нейтральный').order('created_at DESC').paginate(:page => params[:page], :per_page => params[:per_page] || 30)
    render 'users/modes_history', layout: 'admin'
  end

  def testee_tab
    @tests = Test.all.where(:directory => false)
    @current_mode = current_user.test_modes.order('created_at DESC').first
    @assigned_tests = AssignedTest.all.where(user_id: current_user.id, test_mode_id: @current_mode)
    @users = User.search(params[:search_users])
    @tries = Try.all.where(:user_id => params[:id]).paginate(:page => params[:page], :per_page => params[:per_page] || 30)
  end

  def search_tests
    query = Test.search_test(params[:q], params[:mode])
    @tests = query.limit(5)
    @count = query.count
    render 'search', layout: false
  end

  def custom_create
    @user = User.create(user_params)
    @user.capitalize_name
    @user.create_role(params[:user][:role_ids])

    @user.test_modes.build(name: 'Нейтральный', date_beg: Date.today)
    @user.priority_role_id = @user.roles.order('created_at DESC').first.id
    if @user.save
      redirect_to profile_user_path(@user), notice: 'Пользователь успешно создан'
    else
      redirect_to :back, alert: 'Какие-то поля не заполнены'
    end
  end

  # GET /users/new
  def new
    @user = User.new
    render 'users/new', layout: 'admin'
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
  # PATCH/PUT /users/1.jsonx
  def update
    @user.create_role(params[:user][:role_ids])
    @user.priority_role_id = @user.roles.order('created_at DESC').first.id
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :back, notice: 'Пользователь успешно обновлен.' }
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

  def generate_token
    if @user.generate_token
      redirect_to profile_user_path(@user), notice: 'Токен успешно сгенерирован.'
    else
      redirect_to profile_user_path(@user), alert: 'Токен не сгенерирован.'
    end
  end

  def clean_token
    if @user.clean_token
      redirect_to profile_user_path(@user), notice: 'Токен удален.'
    else
      redirect_to profile_user_path(@user), alert: 'Токен не удален.'
    end
  end

  def token_auth
  end

  def check_token
    user = User.check_token(params[:token])
    if user
      sign_in(user)
      redirect_to user_path(user)
    else
      redirect_to new_user_session_path, alert: 'Токен не найден.'
    end

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
                                 :job, :email, :password, :password_confirmation, :token, :priority_role_id)
  end
end
