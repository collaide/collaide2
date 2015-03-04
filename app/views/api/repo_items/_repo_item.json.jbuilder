json.(repo_item, :id, :name, :file_size, :content_type)
json.updated_at time_ago_in_words(repo_item.updated_at, format: :short)
json.is_folder repo_item.is_folder?
json.sender do
  json.you current_user.id == repo_item.sender.id
  json.(repo_item.sender, :id)
  json.name repo_item.sender.to_s
  json.url user_path(repo_item.sender) if repo_item.sender_type == 'User'
end