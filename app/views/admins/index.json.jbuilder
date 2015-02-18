json.array!(@admins) do |admin|
  json.extract! admin, :id, :first_name, :last_name
  json.url admin_url(admin, format: :json)
end
