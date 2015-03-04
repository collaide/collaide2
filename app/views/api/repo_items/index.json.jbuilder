json.array! @repo_items do |item|
  json.partial! 'api/repo_items/repo_item', repo_item: item
end