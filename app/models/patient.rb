class Patient < ApplicationRecord
	validates_presence_of :first_name
	validates_presence_of :last_name
	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
	belongs_to :company, optional: true
	has_many :reports
	has_many :users, through: :reports

end
