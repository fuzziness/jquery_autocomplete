require File.expand_path(File.dirname(__FILE__) + '/helper')

ActionController::Routing::Routes.draw do |map|
  map.connect  ':controller/:action/:id'
end

class JrailsAutoCompleteTest < ActionController::TestCase
  include JrailsAutoComplete
  include JrailsAutoCompleteMacrosHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  include ActionController::Integration

  def setup
    @controller = Class.new(ActionController::Base) do

      auto_complete_for :some_model, :some_field

      auto_complete_for :some_model, :some_other_field do |items, params|
        items.scoped( { :conditions => [ "a_third_field = ?", params['some_model']['a_third_field'] ] })
      end

      attr_reader :items

      def url_for(options)
        url =  "http://www.example.com/"
        url << options[:action].to_s if options and options[:action]
        url
      end

      class << self
        def name
          'test_controller'
        end
      end
    end
    @controller = @controller.new

    ActiveRecord::Base.connection.create_table :some_models, :force => true do |table|
      table.column :title, :string
      table.column :id, :integer
    end
    Object.const_set("SomeModel", Class.new(ActiveRecord::Base)) unless Object.const_defined?("SomeModel")

    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_auto_complete_field
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" });
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({source:'http://www.example.com/some_action', update:'update_div'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :update => 'update_div');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({search:function(event,ui){do_search}, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :search => 'do_search');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({open:function(event,ui){do_open}, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :open => 'do_open');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({focus:function(event,ui){do_focus}, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :focus => 'do_focus');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({select:function(event,ui){do_select}, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :select => 'do_select');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({close:function(event,ui){do_close}, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :close => 'do_close');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({change:function(event,ui){do_change}, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :change => 'do_change');
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({minLength:5, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :min_length => 5);
    assert_equal %(<script type="text/javascript">\n//<![CDATA[\njQuery('#some_input').autocomplete({delay:300, source:'http://www.example.com/some_action', update:'some_input_auto_complete'})\n//]]>\n</script>),
      auto_complete_field("some_input", :source => { :action => "some_action" }, :delay => 300);
  end

#FIXME
#  def test_auto_complete_result
#    result = [ SomeModel.new(:title => 'test1', :id => 1), SomeModel.new(:title => 'test2', :id => 2) ]
#    assert_equal '[{"label":"test1","id":1,"value":"test1"},{"label":"test2","id":2,"value":"test2"}]',
#      auto_complete_result(result, :title)
#    assert_equal '[{"label":"t<strong class="highlight">est</strong>1","id":1,"value":"test1"},{"label":"t<strong class="highlight">est</strong>2","id":2,"value":"test2"}]',
#      auto_complete_result(result, :title, "est")
#
#    resultuniq = [ SomeModel.new(:title => 'test1'), SomeModel.new(:title => 'test1') ]
#    assert_equal '[{"label":"t<strong class="highlight">est</strong>1","id":1,"value":"test1"}]',
#      auto_complete_result(resultuniq, :title, "est")
#  end

  def test_text_field_with_auto_complete
    #assert_match %(<style type="text/css">),
    #  text_field_with_auto_complete(:message, :recipient)

    assert_equal %(<input id=\"message_recipient\" name=\"message[recipient]\" size=\"30\" type=\"text\" /><div id=\"message_recipient_auto_complete\"></div><script type=\"text/javascript\">\n//<![CDATA[\njQuery('#message_recipient').autocomplete({source:'http://www.example.com/auto_complete_for_message_recipient', update:'message_recipient_auto_complete'})\n//]]>\n</script>),
      text_field_with_auto_complete(:message, :recipient, {}, :skip_style => true)
  end

#FIXME
#  # auto_complete_for :some_model, :some_field
#  def test_default_auto_complete_for
#    get :auto_complete_for_some_model_some_field, :some_model => { :some_field => "some_value" }
#    default_auto_complete_find_options = @controller.items.proxy_options
#    assert_equal "\"some_models\".some_field ASC", default_auto_complete_find_options[:order]
#    assert_equal 10, default_auto_complete_find_options[:limit]
#    assert_equal ["LOWER(\"some_models\".some_field) LIKE ?", "%some_value%"], default_auto_complete_find_options[:conditions]
#  end
#
  # auto_complete_for :some_model, :some_other_field do |items, params|
  #   items.scoped( { :conditions => [ "a_third_field = ?", params['some_model']['a_third_field'] ] })
  # end
  def test_auto_complete_for_with_block
    get :auto_complete_for_some_model_some_other_field, :some_model => { :some_other_field => "some_value", :a_third_field => "some_value" }
#    custom_auto_complete_find_options = @controller.items.proxy_options
#    assert_equal [ "a_third_field = ?", 'some_value' ], custom_auto_complete_find_options[:conditions]
#
#    default_auto_complete_scope = @controller.items.proxy_scope
#    assert !default_auto_complete_scope.nil?
#    default_auto_complete_find_options = default_auto_complete_scope.proxy_options
#    assert_equal "\"some_models\".some_other_field ASC", default_auto_complete_find_options[:order]
#    assert_equal 10, default_auto_complete_find_options[:limit]
#    assert_equal ["LOWER(\"some_models\".some_other_field) LIKE ?", "%some_value%"], default_auto_complete_find_options[:conditions]
  end

  # Quoted table name seems to have changed in Rails 2.3...
  # For Rails 2.2 or earlier:

  # def test_default_auto_complete_for
  #   get :auto_complete_for_some_model_some_field, :some_model => { :some_field => "some_value" }
  #   default_auto_complete_find_options = @controller.items.proxy_options
  #   assert_equal "`some_models`.some_field ASC", default_auto_complete_find_options[:order]
  #   assert_equal 10, default_auto_complete_find_options[:limit]
  #   assert_equal ["LOWER(`some_models`.some_field) LIKE ?", "%some_value%"], default_auto_complete_find_options[:conditions]
  # end

  # def test_auto_complete_for_with_block
  #   get :auto_complete_for_some_model_some_other_field, :some_model => { :some_other_field => "some_value", :a_third_field => "some_value" }
  #   custom_auto_complete_find_options = @controller.items.proxy_options
  #   assert_equal [ "a_third_field = ?", 'some_value' ], custom_auto_complete_find_options[:conditions]
  #
  #   default_auto_complete_scope = @controller.items.proxy_scope
  #   assert !default_auto_complete_scope.nil?
  #   default_auto_complete_find_options = default_auto_complete_scope.proxy_options
  #   assert_equal "`some_models`.some_other_field ASC", default_auto_complete_find_options[:order]
  #   assert_equal 10, default_auto_complete_find_options[:limit]
  #   assert_equal ["LOWER(`some_models`.some_other_field) LIKE ?", "%some_value%"], default_auto_complete_find_options[:conditions]
  # end

end

