class TaskResultsController < ApplicationController
  before_action :set_task_result, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  # GET /task_results
  # GET /task_results.json
  def index
    @task_results = TaskResult.all
  end

  # GET /task_results/1
  # GET /task_results/1.json
  def show
  end

  # GET /task_results/new
  def new
    @task_result = TaskResult.new
  end

  # GET /task_results/1/edit
  def edit
  end

  # POST /task_results
  # POST /task_results.json
  def create
    @task_result = TaskResult.new(task_result_params)

    respond_to do |format|
      if @task_result.save
        format.html { redirect_to @task_result, notice: 'Task result was successfully created.' }
        format.json { render :show, status: :created, location: @task_result }
      else
        format.html { render :new }
        format.json { render json: @task_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_results/1
  # PATCH/PUT /task_results/1.json
  def update
    respond_to do |format|
      if @task_result.update(task_result_params)
        format.html { redirect_to @task_result, notice: 'Task result was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_result }
      else
        format.html { render :edit }
        format.json { render json: @task_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_results/1
  # DELETE /task_results/1.json
  def destroy
    @task_result.destroy
    respond_to do |format|
      format.html { redirect_to task_results_url, notice: 'Task result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_result
      @task_result = TaskResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_result_params
      params.require(:task_result).permit(:point, :text, :status, :task_id, :try_id)
    end
end
