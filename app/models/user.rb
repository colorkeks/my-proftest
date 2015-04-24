class User < ActiveRecord::Base
  before_create :create_role
  has_and_belongs_to_many :roles
  has_many :tries
  has_many :tests, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  if Rails.env.production?
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable
  end


  def self.search(search_users)
    if search_users
      self.where("first_name LIKE ? OR last_name LIKE ? OR job LIKE ?", "%#{search_users}%", "%#{search_users}%", "%#{search_users}%")
    else
      self.all
    end
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  private
  def create_role
    # self.roles << Role.find_by_name(:Администратор)
    self.roles << Role.find_by_name(:Тестируемый)
    # self.roles << Role.find_by_name(:Методолог)
  end
end
