json.partial! 'api/repo_items/repo_item', repo_item: @repo_item
json.partial! 'api/repo_items/parent', repo_item: @repo_item
json.children @children do |child|
  json.partial! 'api/repo_items/repo_item', repo_item: child
end
json.breadcrumb @repo_item.path do |element|
  json.id element.id
  json.url api_repo_item_path(@group, element)
  json.name element.name
end