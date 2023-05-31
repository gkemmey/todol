# inspired by: https://rubyplus.com/articles/3401-Customize-Field-Error-in-Rails-5
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  result = html_tag

  form_fields = ["textarea", "input", "select"]
  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css((["label"] + form_fields).join(", "))

  elements.each do |e|
    if e.node_name == "label"
      # not doing anything, but wanted to capture how to do something for futures 🔮

    elsif form_fields.include?(e.node_name)
      _html_tag = Nokogiri::HTML::DocumentFragment.parse(html_tag)

      form_field = _html_tag.elements.first
      form_field["class"] = [form_field["class"], "input-error"].compact.join(" ")

      errors = Array(instance.error_message).map(&:humanize).
                                             uniq.
                                             collect { |e| "<li class=\"text-error\">#{e}</li>" }.
                                             join.
                                             then { |lis|
                                               "<ul class=\"label-text-alt\">#{lis}</ul>"
                                             }.
                                             then { |ul|
                                               "<label class=\"label\">#{ul}</label>"
                                             }
      form_field.add_next_sibling(errors)

      result = _html_tag.to_s
    end
  end

  result.html_safe
end
