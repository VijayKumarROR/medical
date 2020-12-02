class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_one :company
  has_many :reports
	has_many :patients, through: :reports
  after_create :add_company

  def add_company
  	self.create_company(name: "Company #{self.id}") if !self.company
  end

  def patients
    attributes = %w{id last_name first_name email}
    patients = self.company.patients
    CSV.generate(headers: true) do |csv|
      csv << attributes
      patients.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |u|
        u.email = auth.info.email
        u.password = Devise.friendly_token[0, 20]                
        u.save
    end    
  end


end
