require "image_processing/mini_magick"

class BannerImageUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick
      .source(original)
      .convert("webp")

    {
      thumbnail:  magick.resize_to_fill!(240, 240, gravity: "south-west"),
    }
  end
end
