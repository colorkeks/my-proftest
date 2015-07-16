class TriesController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :set_try, only: [:show, :edit, :update, :destroy, :try_result, :show_question]
  load_and_authorize_resource
  # GET /tries
  # GET /tries.json
  def index
    @tries = Try.all
  end

  # GET /tries/1
  # GET /tries/1.json
  def show
  end

  # GET /tries/new
  def new
    @try = Try.new
  end

  # GET /tries/1/edit
  def edit
  end

  def show_question
    # если все задания пройдены
    if @try.task_results.where(:status => 'ответ не дан').count == 0
      respond_to do |format|
        if @try.save
          format.html { redirect_to try_result_try_path }
        else
          format.json { render json: @try.errors, status: :unprocessable_entity }
        end
      end
      # если не все задания пройдены
    else
      @test = Test.find_by_id(@try.test_id)
      @current_task = @try.task_results.where(:status => 'правильно').count + @try.task_results.where(:status => 'не правильно').count + @try.task_results.where(:status => 'частично правильно').count
      @tasks_count =@try.task_results.count
      @current_task_index = params[:current_task_index].nil? ? 0 : params[:current_task_index].to_i

      #таймер
      duration = (Time.now - @try.created_at.to_time).to_f
      remaining_time = @try.test.timer - Time.utc(2000, 01, 01) - duration
      @timer = remaining_time
      @hours = (@timer/3600).to_i
      @minutes = (@timer/60).to_i - @hours*60
      @seconds = (@timer%60).to_i

      # если таймер дошел до ограниченного времени
      if remaining_time <= 0 #@hours >= @try.test.timer.strftime('%H').to_i && @minutes >= @try.test.timer.strftime('%M').to_i
        @try.task_results.where(:status => 'ответ не дан').each do |task_result|
          task_result.status = 'не правильно'
          task_result.point = 0
          task_result.save!
        end
        respond_to do |format|
          format.html { redirect_to try_result_try_path }
        end
        # если таймер еще не дошел до ограниченного времени
      else
        @task_result = @try.get_question(@current_task_index)
        @current_task_index = @try.task_results_queue.index(@task_result.id)
      end
    end
  end

  def try_result
    @task_result = TaskResult.where(:status => 'ответ не дан', :try_id => params[:id]).order('RANDOM()').first
    max_points = 0
    user_points = 0

    @try.task_results.each do |task_result|
      max_points = max_points + task_result.task_was.point
      user_points = user_points + task_result.point
    end
    @max = max_points
    @current = user_points
    @percent = user_points*100/max_points

    if @task_result != nil
      redirect_to show_question_try_path
    else
      if @try.status == 'Не выполнен'
        @timer = (Time.now - @try.created_at.to_time).to_f
        @hours = (@timer/3600).to_i
        @minutes = (@timer/60).to_i - @hours*60

        @try.status = 'Выполнен'
        @try.rate = @percent
        @try.timer = format('%02d:%02d', @hours, @minutes)
        @try.save!
      end
    end
  end

  def check_user_answer
    task_result = @try.task_results.find(params[:task_result_id])
    # если на вопрос действительно еще не отвечали
    if @try.can_show_task_result?(task_result)
      task_result.check_user_answer!(params)
      task_results = @try.process_chain_for_task_result!(task_result)

      respond_to do |format|
        if task_result.save && task_results.all?(&:save)
          # если на цепочку ответили не правильно, то прервать цепочку и отметить как не правильно
          format.html { redirect_to show_question_try_path(:current_task_index => params[:current_task_index]) }
        else
          format.json { render json: @try.errors, status: :unprocessable_entity }
        end
      end
      # если на вопрос уже ответили
    else
      respond_to do |format|
        format.html { redirect_to show_question_try_path(:current_task_index => params[:current_task_index]), :alert => 'Вы не можете ответить на данный вопрос' }
      end
    end
  end


  # POST /tries
  # POST /tries.json
  def create
    @try = Try.new(try_params)
    @test = Test.existing.find(@try.test_id)
    result = @try.prepare

    respond_to do |format|
      if result
        format.html { redirect_to show_question_try_path(@try) }
        format.json { render :show, status: :created, location: @try }
      else
        puts @try.errors.inspect
        format.html { render :new }
        format.json { render json: @try.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /tries/1
# PATCH/PUT /tries/1.json
  def update
    respond_to do |format|
      if @try.update(try_params)
        format.html { redirect_to @try, notice: 'Попытка успешно обновлена.' }
        format.json { render :show, status: :ok, location: @try }
      else
        format.html { render :edit }
        format.json { render json: @try.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /tries/1
# DELETE /tries/1.json
  def destroy
    @try.destroy
    respond_to do |format|
      format.html { redirect_to tries_path, notice: 'Попытка успешно удалена.' }
      format.json { head :no_content }
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_try
    @try = Try.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def try_params
    params.require(:try).permit(:date, :status, :timer, :rate, :task_results_queue, :user_id, :test_id, :test_mode_id, :assigned_test_id)
  end

end
