class EqvgroupsController < ApplicationController
  before_action :set_eqvgroup, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /eqvgroups
  # GET /eqvgroups.json
  def index
    @eqvgroups = Eqvgroup.all
  end

  # GET /eqvgroups/1
  # GET /eqvgroups/1.json
  def show
  end

  # GET /eqvgroups/new
  def new
    @eqvgroup = Eqvgroup.new
  end

  # GET /eqvgroups/1/edit
  def edit
  end

  # POST /eqvgroups
  # POST /eqvgroups.json
  def create
    @eqvgroup = Eqvgroup.new(eqvgroup_params)
    if eqvgroup_params[:number].blank?
      @eqvgroup.number = @eqvgroup.test.eqvgroups.order(:number).last.number + 1
    end

    respond_to do |format|
      if @eqvgroup.save
        format.html {
          #redirect_to @eqvgroup, notice: 'Eqvgroup was successfully created.'
          redirect_to :back
        }
        format.json { render :show, status: :created, location: @eqvgroup }
      else
        format.html { render :new }
        format.json { render json: @eqvgroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eqvgroups/1
  # PATCH/PUT /eqvgroups/1.json
  def update
    respond_to do |format|
      if @eqvgroup.update(eqvgroup_params)
        format.html { redirect_to @eqvgroup, notice: 'Eqvgroup was successfully updated.' }
        format.json { render :show, status: :ok, location: @eqvgroup }
      else
        format.html { render :edit }
        format.json { render json: @eqvgroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eqvgroups/1
  # DELETE /eqvgroups/1.json
  def destroy
    @eqvgroup.destroy
    respond_to do |format|
      format.html { redirect_to eqvgroups_url, notice: 'Eqvgroup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_eqvgroup
      @eqvgroup = Eqvgroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def eqvgroup_params
      params.require(:eqvgroup).permit(:test_id, :section_id, :number)
    end
end
