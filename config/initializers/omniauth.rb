OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

provider :facebook, '1811499959110148', 'c7144ee5f37f5d0c2d3c89e1db5db818', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}

end
