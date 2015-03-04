json.repo_items @repo_items do |item|
  #json.id item.id
  #json.partial! 'group/repo_items/repo_item', repo_item: item
  json.(item, :id, :name, :file_size, :content_type)
  json.updated_at l(item.updated_at, format: :short)
  json.is_folder item.is_folder?
  json.sender do
    json.you current_user.id == item.sender.id
    json.(item.sender, :id)
    json.name item.sender.to_s
    json.url user_path(item.sender) if item.sender_type == 'User'
  end
end