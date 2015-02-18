json.array!(@answers) do |answer|
  json.extract! answer, :id, :correct, :text, :point, :task_id
  json.url answer_url(answer, format: :json)
end
