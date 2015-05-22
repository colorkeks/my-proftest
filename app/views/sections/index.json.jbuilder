json.array!(@sections) do |section|
  json.extract! section, :id, :test_id, :name
  json.url section_url(section, format: :json)
end
