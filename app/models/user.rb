class User < ActiveRecord::Base
  before_create :create_role
  has_and_belongs_to_many :roles
  has_many :tries
  has_many :tests, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  private
  def create_role
    self.roles << Role.find_by_name(:Методолог)
  end
end
