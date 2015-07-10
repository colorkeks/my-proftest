require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do
  include Devise::TestHelpers

  before :each do
    @doctor = create(:doctor_dbf)
    @lpu = create(:lpu_dbf)
  end

  def setup
    user = create(:user)
    sign_in(user)
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'load doctor data' do
      get :show, id: 'А1234'

      expect(assigns(:doctor)).to eq(@doctor)
    end

    it 'renders the show template' do
      get :show, id: 'А1234'
      expect(response).to render_template('show')
    end
  end

  describe 'POST #search' do
    it 'search doctors' do
      post :search, q: 'Иванов иван иванович А1234', format: :js

      expect(assigns(:doctors)).to eq([@doctor])
    end

    it 'renders the show template' do
      post :search, q: 'Иванов иван иванович А1234', format: :js
      expect(response).to render_template('search')
    end
  end

end
