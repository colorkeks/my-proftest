class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task_contents =TaskContent.new
    @answer =Answer.new
    @task = Task.new
    @test_id = params[:task][:test_id]
    @type = params[:task][:task_type]
    @task.section_id = params[:task][:section_id]
    @task.test_id = params[:task][:test_id]

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
        format.html { redirect_to edit_task_path(@task), notice: 'Задание успешно создано' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to edit_task_path(@task), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
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
    @test = Test.find(params[:test_id])
    @tasks = @test.tasks.where(id: params[:task_ids].split(',')).destroy_all
    redirect_to @test
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:text, :hint, :task_type, :point, :test_id, :section_id,
                    answers_attributes: [ :id, :task_id, :text, :correct, :serial_number, :point, :_destroy],
                    task_contents_attributes: [:id,:file_content, :task_id, :_destroy],
                    associations_attributes: [:id, :text, :serial_number, :task_id, :_destroy])
    end
end
