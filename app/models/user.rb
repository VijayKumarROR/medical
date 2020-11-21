class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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


end
