class ChainsController < ApplicationController
  before_action :set_chain, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  layout proc { request.format.symbol == :js ? false: 'admin' }

  # GET /chains
  # GET /chains.json
  def index
    @test = Test.find(params[:test_id])
    @chains = @test.chains.order(:id).paginate(:page => params[:page], :per_page => params[:per_page] || 30)
    @tasks = @chains
    #@eqvgroups = []
    @eqvgroups = @test.eqvgroups.order('number')
    @last_eqvgroup = @test.eqvgroups.where(section: nil).order(:number).last
    @chains_mode = true

    @task = Task.new
    @test_id = @test.id

    render template: 'tests/show'
  end

  # GET /chains/1
  # GET /chains/1.json
  def show
  end

  # GET /chains/new
  def new
    @chain = Chain.new
  end

  # GET /chains/1/edit
  def edit
  end

  # POST /chains
  # POST /chains.json
  def create
    @chain = Chain.new(chain_params)

    respond_to do |format|
      if @chain.save
        format.html {
          #redirect_to @chain, notice: 'Chain was successfully created.'
          redirect_to :back, notice: 'Цепочка создана'
        }
        format.json { render :show, status: :created, location: @chain }
      else
        format.html {
          flash[:error] = 'Ошибка при создании цепочки'
          redirect_to :back
        }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chains/1
  # PATCH/PUT /chains/1.json
  def update
    respond_to do |format|
      if @chain.update(chain_params)
        format.html { redirect_to @chain, notice: 'Chain was successfully updated.' }
        format.json { render :show, status: :ok, location: @chain }
      else
        format.html { render :edit }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chains/1
  # DELETE /chains/1.json
  def destroy
    @test = Test.find(params[:test_id])
    Chain.transaction do
      @chain.tasks.each do |task|
        task.move_to_trash!
      end
      @chain.destroy
    end

    respond_to do |format|
      format.html { redirect_to test_chains_path(@test), notice: 'Chain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_move_edit
    @test = Test.find(params[:test_id])
    if params[:chain_ids].present?
      @task_count = params[:chain_ids].split(',').count
    else
      @task_count = 0
    end
  end

  def bulk_move_update
    @test = Test.find(params[:test_id])
    chains = @test.chains.where(id: params[:chain_ids].split(',')).order(:id)
    if params[:destination_section_id].present?
      destination_section = @test.sections.find(params[:destination_section_id])
      eqvgroup = destination_section.eqvgroups.order('number').last
    else
      destination_section = nil
      eqvgroup = @test.eqvgroups.where(section:nil).order('number').last
    end

    begin
      Chain.transaction do
        chains.each do |chain|
          chain.change_section_and_eqvgroup!(destination_section, eqvgroup)
        end
      end
      @success = true
    rescue
      @success = false
    end

    if @success
      redirect_to test_chains_path(@test)
    else
      flash[:error] = 'Невозможно переместить группу элементов'
      redirect_to test_chains_path(@test)
    end
  end



  def bulk_destroy
    @trash = params[:trash]
    @test = Test.find(params[:test_id])
    @chains = @test.chains.where(id: params[:chain_ids].split(',')).order(:id)
    Chain.transaction do
      @chains.each do |chain|
        chain.destroy
      end
    end

    redirect_to test_chains_path(test_id: @test)
  end

  def bulk_change_eqvgroup
    @test = Test.find(params[:test_id])
    @chains = @test.chains.where(id: params[:chain_ids].split(',')).order(:id)
    @eqvgroup = @test.eqvgroups.find(params[:eqvgroup_id])

    begin
      Chain.transaction do
        @chains.each do |chain|
          chain.change_eqvgroup!(@eqvgroup)
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

  def bulk_split
    @trash = params[:trash]
    @test = Test.find(params[:test_id])
    @chains = @test.chains.where(id: params[:chain_ids].split(',')).order(:id)
    Chain.transaction do
      @chains.each do |chain|
        chain.split!
      end
    end

    redirect_to test_chains_path(test_id: @test)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chain
      @chain = Chain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chain_params
      params.require(:chain).permit(:test_id, :section_id, :eqvgroup_id)
    end
end
