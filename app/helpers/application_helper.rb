module ApplicationHelper
  def icon(name, options = {})
    render partial: "icons/heroicons/#{name}", locals: { class: options[:class] || "w-6 h-6" }
  end
end
