class AssignedTestsController < ApplicationController
  before_action :set_assigned_test, only: [:show, :edit, :update, :destroy]

  # GET /assigned_tests
  # GET /assigned_tests.json
  def index
    @assigned_tests = AssignedTest.all
  end

  # GET /assigned_tests/1
  # GET /assigned_tests/1.json
  def show
  end

  # GET /assigned_tests/new
  def new
    @assigned_test = AssignedTest.new
  end

  # GET /assigned_tests/1/edit
  def edit
  end

  # POST /assigned_tests
  # POST /assigned_tests.json
  def create
    @assigned_test = AssignedTest.find_or_initialize_by(assigned_test_params)

    respond_to do |format|
      if @assigned_test.save
        format.html { redirect_to profile_user_path(@assigned_test.user_id), notice: 'Тест успешно назначен' }
        format.json { render :show, status: :created, location: @assigned_test }
      else
        format.html { render :new }
        format.json { render json: @assigned_test.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_batch
    tests = Test.where(id: params[:assigned_test][:test_ids])
    tests.each do |test|
      AssignedTest.find_or_create_by(
          test_id: test.id,
          user_id: params[:assigned_test][:user_id],
          test_mode_id: params[:assigned_test][:test_mode_id]
      )
    end
    redirect_to profile_user_path(id: params[:assigned_test][:user_id]), notice: 'Тесты успешно назначены'
  end

  # PATCH/PUT /assigned_tests/1
  # PATCH/PUT /assigned_tests/1.json
  def update
    respond_to do |format|
      if @assigned_test.update(assigned_test_params)
        format.html { redirect_to @assigned_test, notice: 'Assigned test was successfully updated.' }
        format.json { render :show, status: :ok, location: @assigned_test }
      else
        format.html { render :edit }
        format.json { render json: @assigned_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigned_tests/1
  # DELETE /assigned_tests/1.json
  def destroy
    @assigned_test.destroy
    respond_to do |format|
      format.html { redirect_to assigned_tests_url, notice: 'Assigned test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assigned_test
      @assigned_test = AssignedTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assigned_test_params
      params.require(:assigned_test).permit(:user_id, :test_id, :test_mode_id, :test_ids)
    end
end
