module JrailsAutoCompleteMacroHelper
  def auto_complete_field(field_id, options = {})
    js_options = {}

#    if %w(put delete).include?(options[:method])
#      options[:defaultParams] = (options[:defaultParams].blank?? '' : options[:defaultParams] + '&') +
#        "_method=#{options[:method].to_s}"
#      options[:method] = :post
#    end
#    if options[:method] == :post and protect_against_forgery?
#      options[:defaultParams] = (options[:defaultParams].blank?? '' : options[:defaultParams] + '&') +
#        "#{h(request_forgery_protection_token.to_s)}=#{h(form_authenticity_token)}"
#    end

    js_options[:source]        = "'#{url_for(options[:source])}'"
#    js_options[:type]          = "'#{options[:method].to_s.upcase}'" if options[:method]
    js_options[:update]        = "'" + (options[:update] || "#{field_id}_auto_complete") + "'"
#    js_options[:defaultParams] = "'#{options[:defaultParams]}'" if options[:defaultParams]

    {:min_length => :minLength, :delay => :delay}.each do |k, v|
      js_options[v] = options[k] if options[k]
    end

    [:search, :open, :focus, :select, :close, :change].each do |k|
      js_options[k] = "function(event, ui) { #{options[k]} }" if options[k]
    end

    function = "#{ActionView::Helpers::PrototypeHelper::JQUERY_VAR}('##{field_id}').autocomplete("
    function << options_for_javascript(js_options) + ')'

    javascript_tag(function)
  end

  def auto_complete_result(entries, field, phrase = nil)
    return unless entries
    # items = entries.map { |entry| content_tag('li', phrase ? highlight(entry.send(field), phrase) : h(entry[field])) }
    # content_tag('ul', items.uniq)
    #entries.map! { |entry| entry[field] }
    entries.map! { |entry| { 'id' => entry[:id], 'value' => h(entry[field]), 'label' => phrase ? highlight(entry.send(field), phrase) : h(entry[field]) } }
    entries.to_json
  end

  def auto_complete_for(object, method, options = {})
    content_tag('div', '', :id => "#{object}_#{method}_auto_complete") +
      auto_complete_field("#{object}_#{method}", { :source => { :action => "auto_complete_for_#{object}_#{method}" } }.update(options))
  end

  def text_field_with_auto_complete(object, method, tag_options = {}, completion_options = {})
    text_field(object, method, tag_options) +
      auto_complete_for(object, method, completion_options)
  end

end