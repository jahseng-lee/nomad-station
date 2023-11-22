class ProfilePicture < ApplicationRecord
  include ProfilePictureUploader::Attachment(:image)

  belongs_to :user

  validates :image, presence: true
end
