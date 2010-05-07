require 'rubygems'
require 'test/unit'
require 'action_controller'
require 'active_record'
require 'jrails'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jrails_auto_complete'
require 'jrails_auto_complete_form_builder_helper'
require 'jrails_auto_complete_macros_helper'
require 'jrails_auto_complete_tag_helper'
require File.join(File.dirname(__FILE__), '..', 'rails', 'init')

ActiveRecord::Base.establish_connection({ :adapter => 'sqlite3', :database => ':memory:' })
ActiveRecord::Migration.verbose = false
