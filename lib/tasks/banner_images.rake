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

  desc "Re-generates derivates for banner images"
  task regenerate_derivatives: :environment do
    BannerImage.find_each do |banner_image|
      attacher = banner_image.image_attacher

      next unless attacher.stored?

      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})                    # clear derivatives
      attacher.create_derivatives                     # reprocess derivatives

      begin
        attacher.atomic_persist                       # persist changes if attachment has not changed in the meantime
        attacher.delete_derivatives(old_derivatives)  # delete old derivatives
      rescue Shrine::AttachmentChanged,               # attachment has changed
             ActiveRecord::RecordNotFound             # record has been deleted
        attacher.delete_derivatives                   # delete now orphaned derivatives
      end
    end
  end
end
