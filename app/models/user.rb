class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :tries
  has_many :tests
  has_many :test_modes
  has_many :assigned_tests
  has_one :doctor_dbf, :foreign_key => :drcode, primary_key: 'drcode'
  validates :first_name, presence: true
  validates :second_name, presence: true
  validates :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  if Rails.env.production?
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  else
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable
  end


  def self.search(search_users)
    if search_users
      self.where('first_name LIKE ? OR second_name LIKE ? OR last_name LIKE ? OR job LIKE ?', "%#{search_users}%", "%#{search_users}%", "%#{search_users}%", "%#{search_users}%")
    else
      self.all
    end
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def generate_token
    while true do
      random_number = Random.rand(99999999)
      break unless User.where(token: random_number).exists?
    end

    self.token = random_number
    self.token_expire_at = Date.today + 1.day
    self.save
  end

  def self.check_token(token)
    Role.find_by(name: 'Тестируемый').users.where('token = ? AND token_expire_at >= ? ', token, Time.now ).first
  end

  def create_role(roles)
    roles.each do |role|
      self.roles << Role.find_by_name(role)
    end
  end

end
