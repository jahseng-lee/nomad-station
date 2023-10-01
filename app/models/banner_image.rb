class BannerImage < ApplicationRecord
  include BannerImageUploader::Attachment(:image)

  belongs_to :location
end
