class BaseUploader < CarrierWave::Uploader::Base
  storage Rails.env.test? ? :file : :fog
end
