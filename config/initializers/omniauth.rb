OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

#Master app for Heroku, comment out others if pushing to development or master. 
# provider :facebook, '1811499959110148', 'c7144ee5f37f5d0c2d3c89e1db5db818', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}




#Jessica's test FB, comment out if pushing to development or master 
provider :facebook, '165763490548205', 'ddf2723786c1f581c7a28a9dd4095ac9', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}

end
