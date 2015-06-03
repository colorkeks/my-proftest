json.array!(@chains) do |chain|
  json.extract! chain, :id, :test_id, :section_id, :eqvgroup_id
  json.url chain_url(chain, format: :json)
end
