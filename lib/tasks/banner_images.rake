namespace :banner_images do
  desc "Generates derivates for banner images"
  task generate_derivatives: :environment do
    BannerImage.find_each do |banner_image|
      attacher = banner_image.image_attacher

      next unless attacher.stored?

      attacher.create_derivatives

      begin
        attacher.atomic_persist            # persist changes if attachment has not changed in the meantime
      rescue Shrine::AttachmentChanged,    # attachment has changed
             ActiveRecord::RecordNotFound  # record has been deleted
        attacher.delete_derivatives        # delete now orphaned derivatives
      end
    end
  end
end
