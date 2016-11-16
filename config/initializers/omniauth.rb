OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

# previous app?
provider :facebook, '650539935119010', 'da24fe256450fed8ee06f569fb9958c3', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}} 

#currently, this is the ID and AS for the test application 
# provider :facebook, '165788530545701', '42740cec0bcc849919de16d105e714f7', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}} 

# provider :facebook, '1811499959110148', 'c7144ee5f37f5d0c2d3c89e1db5db818', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}

end
