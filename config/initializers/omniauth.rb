OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
#previous app?
#   provider :facebook, '940146309424515', 'b78f11ced7744092c8a8c59164749f41', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}} 

provider :facebook, '165763490548205', 'ddf2723786c1f581c7a28a9dd4095ac9', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}} 

end
