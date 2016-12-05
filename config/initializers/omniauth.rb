OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

provider :facebook, ENV.fetch('FB_APP_ID'), ENV.fetch('FB_SECRET_KEY'), {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}

end
