class TaskContentsController < ApplicationController
  def index
    @task_content = TaskContent.new
  end

  def edit

  end

  def create
    @task_content = TaskContent.new(content_params)
    if @task_content.save
      render json: { message: "success", fileID: @task_content.id }, :status => 200
    else
      render json: { error: @task_content.errors.full_messages.join(',')}, :status => 400
    end
  end

  def show
    @task_content = TaskContent.find(params[:id])
  end

  def destroy
    @task_content = TaskContent.find(params[:id])
    @task_content.file_content = nil
    @task_content.destroy

    respond_to do |format|
      format.html { redirect_to edit_task_path(@task_content.task_id), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def content_params
    params.require(:task_content).permit(:file_content, :task_id)
  end
end
