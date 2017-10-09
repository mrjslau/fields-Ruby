# spec/spec_helper.rb

require 'simplecov'
SimpleCov.start do
  add_filter ".bundle/"
end

require 'reservation'
require 'field'
require 'invoice'
require 'client'
require 'admin'
