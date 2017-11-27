# spec/spec_helper.rb

require 'simplecov'
SimpleCov.start do
  add_filter '.bundle/'
end

# require 'admin'
require 'client'
require 'field'
require 'invoice'
require 'reservation'
# require 'timetable'
