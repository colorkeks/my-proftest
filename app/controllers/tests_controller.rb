class TestsController < ApplicationController
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode
  before_action :set_test, only: [:show, :trash, :edit, :update, :destroy, :settings]
  load_and_authorize_resource
  # GET /tests
  # GET /tests.json
  layout proc { request.format.symbol == :js ? false: 'admin' }

  def index
    @tests = Test.all
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
    @task = Task.new
    @test_id = params[:id]
    if params.has_key?('selected_section_id') && params[:selected_section_id].present?
      @selected_section = @test.sections.find(params[:selected_section_id])
      @tasks = @test.tasks.where(section: @selected_section)
      @last_eqvgroup = @selected_section.eqvgroups.order(:number).last
    else
      @last_eqvgroup = @test.eqvgroups.order(:number).last
    end

    if params.has_key?('selected_chain_id') && params[:selected_chain_id].present?
      @selected_chain = @test.chains.find(params[:selected_chain_id])
      @tasks = @test.tasks.where(chain: @selected_chain).order(:chain_position)
      @last_eqvgroup = @selected_chain.eqvgroup
    else
      #
    end

    @tasks = @tasks.existing.order('id ASC').paginate(:page => params[:page], :per_page => params[:per_page] || 30)
    @eqvgroups = @test.eqvgroups.order('number')

    if params[:old]
      render 'tests/show_old', layout: 'application'
      return
    end
  end

  def trash
    @trash = true
    @tasks = @test.tasks.deleted.order('deleted_at DESC').paginate(:page => params[:page], :per_page => params[:per_page] || 30)
    @eqvgroups = []
    @task = Task.new
    @test_id = params[:id]

    render action: 'show'
  end

  def create_task
    @task = Task.new
    @test_id = params[:id]
  end

  # GET /tests/new
  def new
    @test = Test.new(test_group_id: params[:test_group_id])
    @test.algorithm='Все задания'
  end

  # GET /tests/1/edit
  def edit
  end

  def settings
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)

    if @test.directory == false
      respond_to do |format|
        if @test.save
          format.html {
            #redirect_to current_user, notice: 'тест успешно создан'
            redirect_to @test.test_group, notice: 'тест успешно создан'
          }
          format.json { render :show, status: :created, location: @test }
        else
          format.html { redirect_to current_user, alert: 'Поле "Заголовок" не заполнено' }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        if @test.save
          format.html { redirect_to current_user, notice: 'Папка успешно создана' }
          format.json { render :show, status: :created, location: @test }
        else
          format.html { redirect_to current_user, alert: 'Поле "Заголовок" не заполнено' }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.directory == false
        if @test.update(test_params)
          format.html {
            redirect_to(:back)
            #redirect_to @test, notice: 'Тест был успешно обновлен'
          }
          format.json { render :show, status: :ok, location: @test }
        else
          format.html { render :edit }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
      else
        if @test.update(test_params)
          format.html {
            redirect_to(:back)
            #redirect_to current_user, notice: 'Папка была успешно обновлена'
          }
          format.json { render :show, status: :ok, location: @test }
        else
          format.html { render :edit }
          format.json { render json: @test.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    #@test.destroy
    test_group = @test.test_group
    @test.test_group = TestGroup.trash
    @test.soft_delete!

    respond_to do |format|
      format.html { redirect_to test_group, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @tasks = Task.all.where(:test_id => params[:id])
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(:title, :directory, :timer, :algorithm, :attestation, :count_tries, :percent_tasks, :description, :user_id, :test_group_id)
    end
end
