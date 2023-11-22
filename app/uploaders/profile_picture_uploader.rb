require "image_processing/mini_magick"

class ProfilePictureUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      # 3x usage size
      chat: magick.resize_to_fill!(360, 360), # TODO determine size
      main: magick.resize_to_fill!(540, 540),
    }
  end
end
