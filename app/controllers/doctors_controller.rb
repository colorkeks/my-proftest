class DoctorsController < ApplicationController
  delegate :can?, :cannot?, :to => :ability
  load_and_authorize_resource find_by: :drcode
  layout 'admin'

  def index
  end

  def show
    @doctor = Doctor.where(drcode: params[:id]).first
    @users = User.all
    @user = User.new
  end

  def search
    query = Doctor.search_doctor(params[:q])
    @doctors = query.limit(10)
    @count = query.count
    render 'search', layout: false
  end

end