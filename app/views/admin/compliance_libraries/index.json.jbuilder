json.data do |json|
  json.array!(@compliance_libraries) do |compliance_library|
      json.id compliance_library.id
      json.compliance_id compliance_library.compliance_id
      json.name compliance_library.name
      json.is_leaf compliance_library.is_leaf
      json.parent_id compliance_library.parent_id
    end
end