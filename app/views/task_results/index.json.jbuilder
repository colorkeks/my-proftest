json.array!(@task_results) do |task_result|
  json.extract! task_result, :id, :point, :text, :status, :task_id, :try_id
  json.url task_result_url(task_result, format: :json)
end
