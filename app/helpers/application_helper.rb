module ApplicationHelper
# creating the URL with subdomain
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end

  def add_active_class(params)
    case params[:controller]
    when 'audits'
      'Audit'
    when 'users'
      'User'
    when 'risks'
      'Risk'
    else
      return ''
    end
  end

  def overview_header
    return true if (request.fullpath.include?("user/edit") == true ||  request.fullpath == "/" || request.fullpath.include?("activities") == true || request.fullpath.include?("user/password") == true || request.fullpath.include?("user/update_password") == true)
  end

# def link_to_add_fields(name, f, association)
#   new_object = f.object.class.reflect_on_association(association).klass.new
#   fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
#     render(association.to_s.singularize + "_fields", :f => builder)
#   end
#   link_to "#{name}" ,'javascript:void(0)',  {onclick: "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: "plus-icon"}
# end

def link_to_add_nc_question_fields(name, f, association, audit)
  new_object = f.object.class.reflect_on_association(association).klass.new
  fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
    render(association.to_s.singularize + "_fields", :f => builder, audit: audit)
  end
  link_to "#{name}" ,'javascript:void(0)',  {onclick: "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: "plus-icon"}
end

def link_to_add_choices(name, f, association)
  new_object = f.object.class.reflect_on_association(association).klass.new
  fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
    render(association.to_s.singularize + "_fields", :f => builder)
  end
  link_to "#{name}" ,'javascript:void(0)',  {onclick: "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", class: "plusround-icon plus-background"}
end

def link_to_add_auditee(name, association)
  link_to "#{name}" ,'javascript:void(0)',  {onclick: "add_auditees(this, \"#{association}\")", class: "plusround-icon plus-background"}
end

def link_to_remove_fields(name, f)
  f.hidden_field(:_destroy) + link_to("#{name}", 'javascript:void(0)', {onclick: "remove_fields(this)", class: "minus-icon"})
end

def link_to_remove_choices(name, f)
  f.hidden_field(:_destroy) + link_to("#{name}", 'javascript:void(0)', {onclick: "remove_options(this)", class: "minusround-icon"})
end

def link_to_remove_auditee(name, f)
  f.hidden_field(:_destroy, {class: "auditee-remove"}) + link_to("#{name}", 'javascript:void(0)', {onclick: "remove_options(this)", class: "minusround-icon"})
end

def check_stage(stage, compliance_url, non_compliance_url)
 return true if ((request.fullpath.include?('stage=do') || request.fullpath.include?(non_compliance_url) || request.fullpath.include?(compliance_url)) == true)
end

  def company_modules_check(module_name)
    module_id = Section.find_by_name(module_name).id
    current_company.plan.subscription_section_ids.include?("#{module_id}")
  end
end
