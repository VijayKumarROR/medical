class Company < ApplicationRecord
	belongs_to :user
	has_many :patients
end
