require 'test/unit'
require 'rubygems'
require 'active_support'
require 'action_mailer'

RAILS_ROOT           = '..' unless defined?(RAILS_ROOT)
RAILS_DEFAULT_LOGGER = Logger.new(STDOUT) unless defined?(RAILS_DEFAULT_LOGGER)

ActionMailer::Base.delivery_method = :test

$:.unshift File.join(File.dirname(__FILE__), '../lib')