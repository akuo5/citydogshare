OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

# previous app?
#provider :facebook, '940146309424515', 'b78f11ced7744092c8a8c59164749f41', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}} 

#currently, this is the ID and AS for the test application 
#provider :facebook, '165788530545701', '42740cec0bcc849919de16d105e714f7', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}} 

provider :facebook, '1792736311000850', '9c971547583630fe20616ff3c802cec3', {:info_fields => 'email,first_name,last_name,location,gender', :client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}

end
