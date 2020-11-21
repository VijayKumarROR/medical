class Attachment < ApplicationRecord
	belongs_to :report
	mount_uploader :name, AvatarUploader
end
