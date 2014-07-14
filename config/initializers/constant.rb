ALLMESSAGES = YAML.load_file("#{Rails.root.to_s}/config/locales/messages.yml")
MESSAGES =  ALLMESSAGES["en"]
HOST_URL = YAML.load_file("#{Rails.root.to_s}/config/locales/constants.yml")["site_url"][Rails.env]