class AssociationsController < ApplicationController
  before_action :set_association, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @associations = Association.all
    respond_with(@associations)
  end

  def show
    respond_with(@association)
  end

  def new
    @association = Association.new
    respond_with(@association)
  end

  def edit
  end

  def create
    @association = Association.new(association_params)
    @association.save
    respond_with(@association)
  end

  def update
    @association.update(association_params)
    respond_with(@association)
  end

  def destroy
    @association.destroy
    respond_with(@association)
  end

  private
    def set_association
      @association = Association.find(params[:id])
    end

    def association_params
      params.require(:association).permit(:text, :serial_number, :task_id, :answer_id)
    end
end
