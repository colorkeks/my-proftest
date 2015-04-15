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
    @test = Test.find_by_id(@try.test_id)
    @current_task = @try.task_results.where(:status => 'правильно').count + @try.task_results.where(:status => 'не правильно').count + @try.task_results.where(:status => 'частично правильно').count
    @tasks_count =@try.task_results.count
    @current_task_index = params[:current_task_index].nil? ? 0 : params[:current_task_index].to_i

    #таймер
    @timer = (Time.now - @try.created_at.to_time).to_f
    @hours = (@timer/3600).to_i
    @minutes = (@timer/60).to_i - @hours*60
    @seconds = (@timer%60).to_i

    # если таймер дошел до ограниченного времени
    if  @hours >= @try.timer.strftime('%H').to_i && @minutes >= @try.timer.strftime('%M').to_i
      @try.task_results.where(:status => 'ответ не дан').each do |task_result|
        task_result.status = 'не правильно'
        task_result.point = 0
        task_result.save!
      end
      respond_to do |format|
        format.html { redirect_to try_result_try_path(:current_task_index => params[:current_task_index]) }
      end
    else
      @try.task_results_queue.each_with_index do |id, index|
        if index < @current_task_index
        else
          if @try.task_results.find(id).status == 'ответ не дан'
            @task_result = @try.task_results.find(id)
            @current_task_index = index
            break
          end
        end
      end
      if @task_result.nil?
        @try.task_results_queue.each do |id|
          if @try.task_results.find(id).status == 'ответ не дан'
            @task_result = @try.task_results.find(id)
            @current_task_index = @try.task_results_queue.index(id)
            break
          end
        end
        if @task_result.nil?
          @try.timer = format('%02d:%02d', @hours, @minutes)
          respond_to do |format|
            if @try.save
              format.html { redirect_to try_result_try_path }
            else
              format.json { render json: @try.errors, status: :unprocessable_entity }
            end
          end
        end
      end
    end
  end

  def try_result
    @task_result = TaskResult.where(:status => 'ответ не дан', :try_id => params[:id]).order('RANDOM()').first
    @try.status = 'Выполнен'
    max_points = 0
    user_points = 0

    @try.task_results.each do |task_result|
      max_points = max_points + task_result.task.point
      user_points = user_points + task_result.point
    end
    @max = max_points
    @current = user_points
    @percent = user_points*100/max_points

    if @task_result != nil
      redirect_to show_question_try_path
    else
      @try.rate = @percent
      @try.save!
    end
  end

  def check_user_answer
    @task_result = TaskResult.find(params[:task_result_id])
    # МНОЖЕСТВЕННЫЙ ВЫБОР
    percent_points = 0
    if @task_result.task_type == 'Множественный выбор'
      params[:user_answers].each do |id|
        @user_answer = UserAnswer.find(id)
        @user_answer.user_reply = true
        @user_answer.save!
      end
      coefficient = @task_result.point.to_f/@task_result.user_answers.where(:correct => true).count

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
      end

      if percent_points == @task_result.point
        @task_result.status = 'правильно'
      elsif percent_points <= 0
        @task_result.status = 'не правильно'
        @task_result.point = 0
      else
        @task_result.status = 'частично правильно'
        @task_result.point = percent_points
      end
      # ЕДИНИЧНЫЙ ВЫБОР
    elsif @task_result.task_type == 'Единичный выбор'
      @user_answer = UserAnswer.find(params[:user_answers])
      @user_answer.user_reply = true
      (@user_answer.correct == true) ? (@task_result.status = 'правильно') :
          (@task_result.status = 'не правильно'; @task_result.point = 0)
      @user_answer.save!
      # ОТКРЫТЫЙ ВОПРОС
    elsif @task_result.task_type == 'Открытый вопрос'
      i = 0
      @task_result.user_answers.each do |user_answer|
        user_answer.user_reply = params[:user_answer]
        if strip_tags(user_answer.text).mb_chars.downcase.to_s == params[:user_answer].mb_chars.downcase.to_s
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
      # ПОСЛЕДОВАТЕЛЬНОСТЬ
    elsif @task_result.task_type == 'Последовательность'
      params[:user_answers].each do |arr|
        @user_answer = UserAnswer.find(arr.first)
        @user_answer.user_reply = arr.second[0].to_i
        if @user_answer.answer.serial_number == arr.second[0].to_i
          @user_answer.correct = true
        end
        @user_answer.save!
      end
      if @task_result.user_answers.where(:correct => false).exists?
        @task_result.status = 'не правильно'
        @task_result.point = 0
      else
        @task_result.status = 'правильно'
      end
      # СОПОСТАВЛЕНИЕ
    elsif @task_result.task_type == 'Сопоставление'
      answer_points = @task_result.point.to_f/@task_result.user_answers.count
      task_result_points = 0
      params[:associations].each do |arr|
        @user_answer = UserAnswer.find(arr.first)
        if arr.second[0] == 'Не выбрано'
          # если не выбрано но ассоциации как таковой нету
          if @task_result.user_associations.where(:serial_number => @user_answer.serial_number).exists?
            @user_answer.correct = false
            @user_answer.point = 0
          else
            @user_answer.correct = true
            @user_answer.point = 0
          end
        else
          @user_association = UserAssociation.find(arr.second[0].to_i)
          # если выбрано верно
          if @user_answer.serial_number == @user_association.serial_number
            @user_answer.correct = true
            @user_answer.point = answer_points.to_f
            @user_answer.user_association_id = arr.second[0].to_i
            @user_association.user_answer_id = arr.first
          else # если выбрано не верно
            @user_answer.correct = false
            @user_answer.point = -answer_points.to_f
            @user_answer.user_association_id = arr.second[0].to_i
            @user_association.user_answer_id = arr.first
          end
        end
        @user_answer.save!
        @user_association.save! if @user_association
      end

      @task_result.user_answers.each do |user_answer|
        task_result_points = task_result_points + user_answer.point
      end

      if @task_result.user_answers.where(:correct => true).count == @task_result.user_answers.count
        @task_result.status = 'правильно'
      elsif task_result_points <= 0
        @task_result.status = 'не правильно'
        @task_result.point = 0
      else
        @task_result.status = 'частично правильно'
        @task_result.point = task_result_points
      end
    end

    respond_to do |format|
      if @task_result.save
        format.html { redirect_to show_question_try_path(:current_task_index => params[:current_task_index]) }
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
      @task_result = @try.task_results.build(:point => task.point, :text => task.text, :hint => task.hint, :task_type => task.task_type, :status => 'ответ не дан', :task_id => task.id, :try_id => @try.id)
      Answer.all.where(:task_id => task.id).each do |answer|
        @task_result.user_answers.build(:user_reply => false, :correct => answer.correct, :text => answer.text, :serial_number => answer.serial_number, :point => answer.point, :task_id => task.id, :answer_id => answer.id, :task_result_id => @task_result.id, :user_association_id => nil)
      end
      Association.all.where(:task_id => task.id).each do |association|
        @task_result.user_associations.build(:text => association.text, :serial_number => association.serial_number, :task_id => task.id, :association_id => association.id, :task_result_id => @task_result.id, :user_answer_id => nil)
      end
    end
    @try.save!
    if @test.algorithm == 'Все задания'
      @try.task_results.order('RANDOM()').each do |task_result|
        @try.task_results_queue << task_result.id
      end
    elsif @test.algorithm == 'Все задания'
      @try.task_results.order('RANDOM()').each do |task_result|
        @try.task_results_queue << task_result.id
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
    params.require(:try).permit(:date, :status, :timer, :rate, :task_results_queue, :user_id, :test_id)
  end

end
