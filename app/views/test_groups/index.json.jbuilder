json.array!(@test_groups) do |test_group|
  json.extract! test_group, :id, :name, :parent_id
  json.url test_group_url(test_group, format: :json)
end
