class TestGroupsController < ApplicationController
  before_action :set_test_group, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /test_groups
  # GET /test_groups.json
  def index
    root_test_group = TestGroup.root
    redirect_to root_test_group
    #@test_groups = TestGroup.all
  end

  # GET /test_groups/1
  # GET /test_groups/1.json
  def show
    @test_groups = TestGroup.all
    @tests = @test_group.tests.order(:lft)
    @child_groups = @test_group.children.order(:lft)
    @elements = (@child_groups + @tests).paginate(:page => params[:page], :per_page => params[:per_page]||30)
  end

  # GET /test_groups/new
  def new
    @test_group = TestGroup.new(parent_id: params[:parent_id])
  end

  # GET /test_groups/1/edit
  def edit
  end

  # POST /test_groups
  # POST /test_groups.json
  def create
    @test_group = TestGroup.new(test_group_params)

    respond_to do |format|
      if @test_group.save
        format.html { redirect_to @test_group, notice: 'Test group was successfully created.' }
        format.json { render :show, status: :created, location: @test_group }
      else
        format.html { render :new }
        format.json { render json: @test_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_groups/1
  # PATCH/PUT /test_groups/1.json
  def update
    respond_to do |format|
      if @test_group.update(test_group_params)
        format.html { redirect_to @test_group, notice: 'Test group was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_group }
      else
        format.html { render :edit }
        format.json { render json: @test_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_groups/1
  # DELETE /test_groups/1.json
  def destroy
    @test_group.destroy
    respond_to do |format|
      format.html { redirect_to test_groups_url, notice: 'Test group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_group
      @test_group = TestGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_group_params
      params.require(:test_group).permit(:name, :parent_id)
    end
end
