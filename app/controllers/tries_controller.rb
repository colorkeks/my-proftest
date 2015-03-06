class TriesController < ApplicationController
  before_action :set_try, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
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
    @try = Try.find(params[:id])
    @test = Test.find_by_id(@try.test_id)
    @current_task = @try.task_results.where(:status => 'правильно').count + @try.task_results.where(:status => 'не правильно').count + @try.task_results.where(:status => 'частично правильно').count
    @tasks_count =@try.task_results.count
    @sorted_task_result = @try.task_results.where(:status => 'ответ не дан').order('RANDOM()').first

    if @sorted_task_result.nil?
      redirect_to try_result_try_path
    end
  end

  def try_result
    @sorted_task_result = TaskResult.where(:status => 'ответ не дан', :try_id => params[:id]).order('RANDOM()').first
    @try = Try.find(params[:id])
    max_points = 0
    user_points = 0

    @try.task_results.each do |task_result|
        max_points = max_points + task_result.task.point
        user_points = user_points + task_result.point
    end
    @max = max_points
    @current = user_points
    @percent = user_points*100/max_points

    if @sorted_task_result != nil
      redirect_to show_question_try_path
    else
      @try.rate = @percent
      @try.save!
    end
  end

  def check_user_answer
    @task_result = TaskResult.find(params[:task_result_id])

    # Если мультичойс
    count_true = 0
    percent_points = 0
    if @task_result.task_type == 'Множественный выбор'
      params[:user_answers].each do |id|
        @user_answer = UserAnswer.find(id)
        @user_answer.user_reply = true
        @user_answer.save!
      end

      @task_result.user_answers.where(:correct => true).each do |user_answer|
        count_true = count_true + 1
      end
      coefficient = @task_result.point.to_f/count_true

      @task_result.user_answers.each do |user_answer|
        if user_answer.correct == true
          user_answer.point = coefficient.to_f
        else
          user_answer.point = -coefficient.to_f
        end
        user_answer.save!
      end

      params[:user_answers].each do |id|
        @user_answer = UserAnswer.find(id)
        percent_points = percent_points + @user_answer.point.to_f
        p @user_answer.point.to_f
        p '=========='
      end

      if percent_points.round  == @task_result.point
        @task_result.status = 'правильно'
      elsif percent_points <= 0
        @task_result.status = 'не правильно'
        @task_result.point = 0
      else
        @task_result.status = 'частично правильно'
        @task_result.point = percent_points
      end
    # если синглчойс
    elsif @task_result.task_type == 'Единичный выбор'
      @user_answer = UserAnswer.find(params[:user_answers])
      @user_answer.user_reply = true
      (@user_answer.correct == true)? (@task_result.status = 'правильно') :
                                      (@task_result.status = 'не правильно'; @task_result.point = 0)
      @user_answer.save!
    # если открытый вопрос
    elsif @task_result.task_type == 'Открытый вопрос'
      i = 0
      @task_result.user_answers.each do |user_answer|
        user_answer.user_reply = params[:user_answer]
        if user_answer.text.mb_chars.downcase.to_s == params[:user_answer].mb_chars.downcase.to_s
          i = i + 1
        end
        user_answer.save!
      end
      if i > 0
        @task_result.status = 'правильно'
      else
        @task_result.status = 'не правильно'
        @task_result.point = 0
      end
    end
    @task_result.save!
    respond_to do |format|
      if @task_result.save
        format.html { redirect_to show_question_try_path }
      else
        format.json { render json: @try.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /tries
  # POST /tries.json
  def create
    @try = Try.new(try_params)
    @test = Test.find_by_id(@try.test_id)

    Task.all.where(:test_id => @test.id).each do |task|
          @task_result = @try.task_results.build(:point => task.point, :text => task.text,:hint => task.hint, :task_type => task.task_type, :status => 'ответ не дан', :task_id => task.id, :try_id => @try.id)
        Answer.all.where(:task_id => task.id).each do |answer|
          @task_result.user_answers.build(:user_reply => false,:correct => answer.correct, :text => answer.text, :point => answer.point, :task_id => task.id, :task_result_id => @task_result.id)
        end
    end

    respond_to do |format|
      if @try.save
        format.html { redirect_to show_question_try_path(@try) }
        format.json { render :show, status: :created, location: @try }
      else
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
        format.html { redirect_to @try, notice: 'Try was successfully updated.' }
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
      format.html { redirect_to tries_path, notice: 'Try was successfully destroyed.' }
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
      params.require(:try).permit(:date, :rate, :user_id, :test_id)
    end
end
