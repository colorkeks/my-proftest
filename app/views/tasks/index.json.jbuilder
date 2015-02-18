json.array!(@tasks) do |task|
  json.extract! task, :id, :text, :task_type, :point, :test_id
  json.url task_url(task, format: :json)
end
