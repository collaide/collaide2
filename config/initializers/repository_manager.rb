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

  config.storage = :aws if Rails.env.production?
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = ENV.fetch('S3_BUCKET')
    config.aws_acl    = :public_read
    config.asset_host = 'http://beta.collaide.com'
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

    config.aws_credentials = {
        access_key_id:     ENV.fetch('S3_KEY'),
        secret_access_key: ENV.fetch('S3_ACCESS')
    }
  end
end