class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :preview, :check_user_answer ]
  load_and_authorize_resource
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    respond_to do |format|
      format.js { render :show, layout: false }
    end
  end

  def preview
    render 'tasks/preview', layout: 'admin'
  end

  # GET /tasks/new
  def new
    @task_contents =TaskContent.new
    @answer =Answer.new
    @task = Task.new
    @test_id = params[:task][:test_id]
    @type = params[:task][:task_type]
    @task.section_id = params[:task][:section_id]
    @task.eqvgroup_id = params[:task][:eqvgroup_id]
    @task.chain_id = params[:task][:chain_id]
    @task.test_id = params[:task][:test_id]
    @task.task_type = params[:task][:task_type]

    @task.task_contents.build

    2.times.each do
      @task.answers.build
      @task.associations.build
    end
    render :new, layout: 'admin'
  end

  # GET /tasks/1/edit
  def edit
    @test_id = @task.test_id
    @type = @task.task_type
    render :edit, layout: 'admin'
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @test_id = @task.test_id

    respond_to do |format|
      if @task.save

        format.html {
          if params[:preview_flag] == 'true'
            redirect_to preview_task_path(@task)
          else
            redirect_to edit_task_path(@task), notice: 'Задание успешно создано'
          end
        }
        format.json { render :show, status: :created, location: @task }
      else
        format.html {
          flash[:error] = 'Задание не создано'
          render :new, layout: 'admin'
        }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_user_answer
    @result = @task.check_answer(params[:answers])
    # redirect_to preview_task_path(@task, correct: result[:correct], point: result[:point])
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html {
          if params[:preview_flag] == 'true'
            redirect_to preview_task_path(@task)
          else
            redirect_to edit_task_path(@task), notice: 'Задание успешно изменено'
          end
        }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html {
          flash[:error] = 'Ошибка при сохранении задания'
          render :new, layout: 'admin'
        }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to test_path(@task.test_id), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_destroy
    @trash = params[:trash]
    @test = Test.find(params[:test_id])
    @tasks = @test.tasks.where(id: params[:task_ids].split(','))
    if @trash.present?
      @tasks.destroy_all
    else
      Task.transaction do
        @tasks.each do |task|
          task.move_to_trash!
        end
      end
    end

    redirect_to :back #@test
  end

  def bulk_move_edit
    @test = Test.find(params[:test_id])
    if params[:task_ids].present?
      @task_count = params[:task_ids].split(',').count
    else
      @task_count = 0
    end
  end

  def bulk_move_update
    @test = Test.find(params[:test_id])
    tasks = @test.tasks.where(id: params[:task_ids].split(','))
    if params[:destination_section_id].present?
      destination_section = @test.sections.find(params[:destination_section_id])
      eqvgroup = destination_section.eqvgroups.order('number').last
    else
      destination_section = nil
      eqvgroup = @test.eqvgroups.where(section:nil).order('number').last
    end

    full_chains = @test.chains.full_chains_from_task_ids(params[:task_ids])

    begin
      Task.transaction do
        full_chains.each do |chain|
          chain.change_section_and_eqvgroup!(destination_section)
        end
        tasks.each do |task|
          next if task.section == destination_section
          task.section = destination_section
          task.eqvgroup = eqvgroup
          task.restore! if task.deleted?
          task.save!
        end
      end
      @success = true
    rescue
      @success = false
    end

    if @success
      redirect_to @test
    else
      flash[:error] = 'Невозможно переместить группу элементов'
      redirect_to @test
    end
  end

  def bulk_change_eqvgroup
    @test = Test.find(params[:test_id])
    @tasks = @test.tasks.where(id: params[:task_ids].split(','))
    @eqvgroup = @test.eqvgroups.find(params[:eqvgroup_id])

    full_chains = @test.chains.full_chains_from_task_ids(params[:task_ids])
    begin
      Task.transaction do
        full_chains.each do |chain|
          chain.change_eqvgroup!(@eqvgroup)
        end
        @tasks.each do |task|
          task.eqvgroup = @eqvgroup
          task.save!
        end
      end
      @success = true
    rescue
      @success = false
    end

    if @success
      redirect_to :back
    else
      flash[:error] = 'Невозможно назначить эквивалентную группу'
      redirect_to :back
    end
  end

  def bulk_join_chain
    @test = Test.find(params[:test_id])
    @tasks = @test.tasks.where(id: params[:task_ids].split(',')).order(:id)

    if params[:destination_chain_id].present?
      @chain = @test.chains.find(params[:destination_chain_id])
    else
      @chain = @test.chains.build
      @chain.section = @tasks.first.section
      @chain.eqvgroup = @tasks.first.eqvgroup
    end

    begin
     Task.transaction do
        @chain.save!
        @tasks.each do |task|
          task.reload
          @chain.add_task!(task)
        end
      end
      @success = true
    rescue #ActiveRecord::RecordInvalid => e
      @success = false
    end

    if @success
      redirect_to :back
    else
      flash[:error] = 'Невозможно объединить в цепочку'
      redirect_to :back
    end

  end

  def bulk_remove_chain
    @test = Test.find(params[:test_id])
    @tasks = @test.tasks.where(id: params[:task_ids].split(',')).order(:id)

    begin
      Task.transaction do
        @tasks.each do |task|
          task.reload
          task.remove_from_list
        end
      end
      @success = true
    rescue
      @success = false
    end

    if @success
      redirect_to :back
    else
      flash[:error] = 'Невозможно удалить из цепочки'
      redirect_to :back
    end

  end

  def bulk_join_chain_select
    @test = Test.find(params[:test_id])
    if params[:task_ids].present?
      @task_count = params[:task_ids].split(',').count
    else
      @task_count = 0
    end
    @chains = @test.chains.order(:id)
  end

  def bulk_change_position
    @test = Test.find(params[:test_id])
    @tasks = @test.tasks.where(id: params[:task_ids].split(',')).order(:chain_position)
    @task = @tasks.first

    if !@task
      redirect_to :back
      return
    end

    position = params[:position].to_i
    #@eqvgroup = @test.eqvgroups.find(params[:eqvgroup_id])

    #full_chains = @test.chains.full_chains_from_task_ids(params[:task_ids])
    begin
      Task.transaction do
        @task.insert_at(position)
      end
      @success = true
    rescue
      @success = false
    end

    if @success
      redirect_to :back
    else
      flash[:error] = 'Невозможно переместить задание'
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:text, :hint, :task_type, :point, :test_id, :section_id, :eqvgroup_id, :chain_id, :preview_flag,
                    answers_attributes: [ :id, :task_id, :text, :correct, :serial_number, :point, :_destroy],
                    task_contents_attributes: [:id,:file_content, :task_id, :_destroy],
                    associations_attributes: [:id, :text, :serial_number, :task_id, :_destroy])
    end
end
