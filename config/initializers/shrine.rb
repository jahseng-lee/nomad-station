require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/google_cloud_storage"
require "shrine/storage/memory"

if Rails.env == "production"
  storage_config = {
    project: "nomadr",
    credentials: JSON.parse(ENV["GCS_CREDENTIALS"]),
  }

  Shrine.storages = {
    cache: Shrine::Storage::GoogleCloudStorage.new(bucket: ENV["CACHE_BUCKET"], **storage_config),
    store: Shrine::Storage::GoogleCloudStorage.new(bucket: ENV["STORE_BUCKET"], **storage_config),
  }
elsif Rails.env == "test"
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :pretty_location
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file

