require 'test_helper'
require 'ostruct'

require 'exception_notifiable'
require 'exception_notifier'

class StubController
  include ExceptionNotifiable
  attr_accessor :request
  
  attr_reader :rendered
  def render_404; @rendered = "404 Not Found"; end
  def render_500; @rendered = "500 Error"; end
  
  def controller_name; 'controller'; end
  def action_name;     'action'; end
end

module ActiveRecord
  class RecordNotFound < StandardError; end
end

class ExceptionNotifiableTest < Test::Unit::TestCase

  def setup
    @controller = StubController.new
    @controller.request = OpenStruct.new(:env => {})
    
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  def test_rescue_action_in_public_with_a_404_exception
    @controller.send :rescue_action_in_public, ActiveRecord::RecordNotFound.new
    assert_equal '404 Not Found', @controller.rendered
    assert_equal 0, @emails.size
  end
  def test_rescue_action_in_public_with_a_500_exception
    @controller.send :rescue_action_in_public, RuntimeError.new
    assert_equal '500 Error', @controller.rendered
    assert_equal 1, @emails.size
  end
  def test_rescue_action_in_public_with_a_500_exception_and_a_condition
    ExceptionNotifier.condition = lambda { |request, error| false }
    @controller.send :rescue_action_in_public, RuntimeError.new
    assert_equal '500 Error', @controller.rendered
    assert_equal 0, @emails.size
  end
end