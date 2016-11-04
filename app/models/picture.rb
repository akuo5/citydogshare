class Picture < ActiveRecord::Base

  belongs_to :movie
  # attr_accessible :image

  #paperclip multiple pictures
  has_attached_file :image, 
                    :styles => { :small    => '150x',
                                 :medium   => '300x',
                                 :large    => '600x'},
                    :default_url => "",
                    :storage => :s3,
                    :bucket => ENV["AWS_BUCKET_NAME"],
                    :path => "/:class/:pictures/:id/:style/:basename.:extension"

  validates_attachment_presence :image, :message => "Photo can't be blank"
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']


end