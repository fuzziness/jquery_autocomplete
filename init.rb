ActionController::Base.send :include, JrailsAutoComplete
ActionController::Base.helper JrailsAutoCompleteMacroHelper
ActionView::Helpers::FormBuilder.send :include, JrailsAutoCompleteFormBuilderHelper
ActionView::Helpers::TagHelper.send :include, JrailsAutoCompleteTagHelper
