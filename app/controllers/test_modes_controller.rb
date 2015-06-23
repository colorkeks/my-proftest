class TestModesController < ApplicationController
  before_action :set_test_mode, only: [:show, :edit, :update, :destroy]

  def index
    @test_modes = TestMode.all
  end

  def show

  end

  def edit

  end

  def new
    @test_mode = TestMode.new
  end

  def create
    @test_mode = TestMode.new(test_mode_params)

    respond_to do |format|
      if @test_mode.save
        format.html { redirect_to :back, notice: 'Test_Mode result was successfully created.' }
        format.json { render :show, status: :created, location: @test_mode }
      else
        format.html { render :new }
        format.json { render json: @test_mode.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @test_mode.update(test_mode_params)
        format.html { redirect_to @test_mode, notice: 'Test_Mode result was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_mode }
      else
        format.html { render :edit }
        format.json { render json: @test_mode.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @test_mode.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: 'Task result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_test_mode
    @test_mode = TestMode.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def test_mode_params
    params.require(:test_mode).permit(:date_beg, :date_end, :name, :user_id)
  end
end