json.array!(@tries) do |try|
  json.extract! try, :id, :date, :rate, :user_id, :test_id
  json.url try_url(try, format: :json)
end
