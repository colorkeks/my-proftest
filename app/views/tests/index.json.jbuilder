json.array!(@tests) do |test|
  json.extract! test, :id, :title, :description, :admin_id
  json.url test_url(test, format: :json)
end
