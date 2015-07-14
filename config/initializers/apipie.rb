Apipie.configure do |config|
  config.app_name                = "Kudoso"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api_docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.copyright = "Copyright 2014-#{Date.today.year} Kudoso Tech, LLC, All Rights Reserved"
  config.app_info = "Kudoso API for mobile client communications"
  config.validate = false
end
