json.(repo_item, :id, :name, :file_size, :content_type)
json.is_folder repo_item.is_folder?