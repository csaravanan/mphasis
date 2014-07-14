json.data do |json|
  json.array!(@privileges) do |privilege|
      json.id privilege.id
      json.role_name privilege.role_title
      json.model_name privilege.modular_model_name
      json.action_name privilege.modular_action_name
    end
end