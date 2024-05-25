require "image_processing/mini_magick"

class BannerImageUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick
      .source(original)
      .convert("webp")

    {
      banner: magick.resize_to_fill!(1600, 400),
      thumbnail:  magick.resize_to_fill!(180, 360, gravity: "south-west"),
    }
  end
end
