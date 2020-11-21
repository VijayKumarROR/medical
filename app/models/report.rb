class Report < ApplicationRecord
	belongs_to :user
	belongs_to :patient
	has_many :attachments
end
