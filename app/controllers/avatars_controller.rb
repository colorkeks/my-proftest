class AvatarsController < ApplicationController
  load_and_authorize_resource
  def index
    @avatar = Avatar.new
  end

  def edit

  end

  def create
    @avatar = Avatar.new(avatar_params)
    if @avatar.save
      redirect_to personal_info_user_path(current_user.id)
    else
      render json: { error: @avatar.errors.full_messages.join(',')}, :status => 400
    end
  end

  def show
    @avatar = Avatar.find(params[:id])
  end

  def update
    @avatar.touch
    respond_to do |format|
      if @avatar.update(avatar_params)
        format.html { redirect_to personal_info_user_path(current_user.id)}
      else
        format.html { redirect_to personal_info_user_path(current_user.id), alert: 'Что-то пошло не так' }
      end
    end
  end

  def destroy
    @avatar = Avatar.find(params[:id])
    @avatar.file_content = nil
    @avatar.destroy
    redirect_to personal_info_user_path(current_user.id)
  end

  private
  def avatar_params
    params.require(:avatar).permit(:file_content, :user_id)
  end
end