require File.join(File.dirname(__FILE__), *%w[.. lib jrails_auto_complete])
require File.join(File.dirname(__FILE__), *%w[.. lib jrails_auto_complete_macros_helper])
require File.join(File.dirname(__FILE__), *%w[.. lib jrails_auto_complete_form_builder_helper])
require File.join(File.dirname(__FILE__), *%w[.. lib jrails_auto_complete_tag_helper])

ActionController::Base.send :include, JrailsAutoComplete
ActionController::Base.helper JrailsAutoCompleteMacrosHelper
ActionView::Helpers::FormBuilder.send :include, JrailsAutoCompleteFormBuilderHelper
ActionView::Helpers::TagHelper.send :include, JrailsAutoCompleteTagHelper