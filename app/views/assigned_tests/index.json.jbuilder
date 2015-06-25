json.array!(@assigned_tests) do |assigned_test|
  json.extract! assigned_test, :id
  json.url assigned_test_url(assigned_test, format: :json)
end
