class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_many :tries
  has_many :tests
  has_many :test_modes
  has_many :assigned_tests
  has_many :avatars
  has_one :doctor, :foreign_key => :drcode, primary_key: 'drcode'
  belongs_to :role
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
    return !!self.roles.where(name: role).any?
  end


  def self.search_user(q)
    q = q.strip.mb_chars.upcase.to_s
    if q.empty?
      User.all
    else
      qs = q.split(' ').map{|i| i+'%'}
      query = %w(first_name last_name second_name drcode).permutation(qs[0..3].length).map do|p|
        fields = p.each_with_index.map{|f,i| "#{f} LIKE(#{self.sanitize(qs[i])})"}.join(' AND ')
        "(#{fields})"
      end.join(' OR ')

      User.where(query)
    end
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

  def clean_token
    self.token = nil
    self.token_expire_at = nil
    self.save
  end

  def capitalize_name
    self.first_name = self.first_name.mb_chars.capitalize
    self.second_name = self.second_name.mb_chars.capitalize
    self.last_name = self.last_name.mb_chars.capitalize
  end

  def self.check_token(token)
    Role.find_by(name: 'Тестируемый').users.where('token = ? AND token_expire_at >= ? ', token, Time.now).first
  end

  def create_role(roles)
    if roles.drop(1).any?
      self.roles.clear
      Role.find(roles.drop(1)).each do |role|
        self.roles << role
      end
    elsif self.roles.exists?
      p '11111'
      # если роли уже есть и ничего не изменилось, то ничего не делаем
    else
      self.roles << Role.find_by_name('Тестируемый') # если ролей нету то добавляем
      p '============='
    end
  end
end
