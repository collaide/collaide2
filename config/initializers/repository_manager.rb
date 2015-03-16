RepositoryManager.setup do |config|

  # Default repo_item permissions that an object has on the repo_item after a sharing.
  config.default_repo_item_permissions = {
    can_read: true, can_create: false, can_update:false, can_delete:false, can_share: false
  }

  # Default sharing permissions that an object has when he is added in a sharing.
  config.default_sharing_permissions = { can_add: false, can_remove: false }

  # Default path for generating the zip file when a user want to download a folder
  # WARNING: DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING
  # Default is : "download/#{member.class.to_s.underscore}/#{member.id}/#{self.class.to_s.underscore}/#{self.id}/"
  #config.default_zip_path = true

  # Define if we enable or not the versioning on the repo_item
  config.has_paper_trail = false

  # Define if a repo item with the same name will be automaticaly overwrited when a new item is create
  config.auto_overwrite_item = false

  config.storage = :fog if Rails.env.production?
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
        provider:              'AWS',                        # required
        aws_access_key_id:     ENV['S3_KEY'],                        # required
        aws_secret_access_key: ENV['S3_ACCESS'],                        # required
        region:                's3-eu-west-1',                  # optional, defaults to 'us-east-1'
        path_style: true
        # host:                  's3.example.com',             # optional, defaults to nil
        # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = ENV['S3_BUCKET']                          # required
    config.fog_public     = false                                        # optional, defaults to true
    #config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
  end
end