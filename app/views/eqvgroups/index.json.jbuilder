json.array!(@eqvgroups) do |eqvgroup|
  json.extract! eqvgroup, :id, :test_id, :section_id, :number
  json.url eqvgroup_url(eqvgroup, format: :json)
end
