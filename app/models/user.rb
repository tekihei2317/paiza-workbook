class User < ApplicationRecord
  has_many :solveds
  has_many :solved_problems, through: :solveds, source: :problem

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  attr_accessor :current_password

  validates :name, presence: true
  validates :email, presence: true
  # validates :password, presence: true

  validates :name, uniqueness: true
  validates :email, uniqueness: true

  def self.find_for_oauth(auth)
    user = User.find_by(uid: auth.uid, provider: auth.provider)

    if user.nil?
      user = User.create(
        name: 'hoge',
        uid: auth.uid,
        email: User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
      )
    end

    user
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
