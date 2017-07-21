require 'yaml'
require 'net/http'

namespace :app do
  task import_zip_codes: :environment do
    uri = URI('https://raw.githubusercontent.com/monterail/zip-codes/master/lib/data/US.yml')

    file = YAML.load(Net::HTTP.get(uri), headers: true)
    progressbar = ProgressBar.create(total: file.size)

    file.each do |key, hash|
      zip_code = ZipCode.find_or_initialize_by(value: key)
      zip_code.assign_attributes(
        state_code: hash[:state_code],
        state_name: hash[:state_name],
        city:       hash[:city],
        time_zone:  hash[:time_zone]
      )
      zip_code.save!
      progressbar.increment
    end
  end
end
