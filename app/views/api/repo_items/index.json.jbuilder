json.repo_items @repo_items do |item|
  #json.id item.id
  #json.partial! 'group/repo_items/repo_item', repo_item: item
  json.(item, :id, :name, :file_size, :content_type)
  json.is_folder item.is_folder?
  json.sender do
    json.(item.sender, :id)
    json.name item.sender.to_s
    case item.sender_type
      when 'User'
        json.url user_url(item.sender)
    end
  end
end