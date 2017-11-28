# spec/spec_helper.rb

require 'simplecov'
SimpleCov.start do
  add_filter '.bundle/'
end

require 'client'
require 'admin'
require 'field'
require 'invoice'
require 'reservation'
# require 'timetable'
