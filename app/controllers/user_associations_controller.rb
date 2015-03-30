class UserAssociationsController < ApplicationController
  before_action :set_user_association, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_associations = UserAssociation.all
    respond_with(@user_associations)
  end

  def show
    respond_with(@user_association)
  end

  def new
    @user_association = UserAssociation.new
    respond_with(@user_association)
  end

  def edit
  end

  def create
    @user_association = UserAssociation.new(user_association_params)
    @user_association.save
    respond_with(@user_association)
  end

  def update
    @user_association.update(user_association_params)
    respond_with(@user_association)
  end

  def destroy
    @user_association.destroy
    respond_with(@user_association)
  end

  private
    def set_user_association
      @user_association = UserAssociation.find(params[:id])
    end

    def user_association_params
      params.require(:user_association).permit(:user_reply, :text, :serial_number, :task_id, :association_id, :task_result_id, :user_answer_id)
    end
end
