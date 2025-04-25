module VueHelper
  def vue_component(name, props = {}, options = {})
    data_attributes = {
      'data-vue-component': name,
      'data-vue-props': props.to_json
    }
    
    html_options = options.merge(data_attributes)
    
    content_tag(:div, "", html_options)
  end
end