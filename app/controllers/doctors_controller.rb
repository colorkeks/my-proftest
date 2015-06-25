class DoctorsController < ApplicationController
  layout 'admin'

  def index
  end

  def show
    @doctor = DoctorDbf.where(drcode: params[:id]).first
    @users = User.all
    @user = User.new
  end

  def search
    query = DoctorDbf.search_doctor(params[:q])
    @doctors = query.limit(10)
    @count = query.count
    render 'search', layout: false
  end

end