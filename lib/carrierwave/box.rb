require 'carrierwave'
require 'carrierwave/storage/box'
require "carrierwave/box/version"

class CarrierWave::Uploader::Base
  add_config :box_client_id
  add_config :box_client_secret
  add_config :box_email
  add_config :box_password
  add_config :box_access_type
  configure do |config|
    config.storage_engines[:box] = 'CarrierWave::Storage::Box'
  end
end
