if repo_item.parent.nil?
  json.parent nil
else
  json.parent do |json|
    json.(repo_item.parent, :id, :name)
  end
end