require "image_processing/mini_magick"

class BannerImageUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      thumbnail:  magick.resize_to_fill!(480, 480, gravity: "south-west"),
    }
  end

  # TODO custom storage path
end
