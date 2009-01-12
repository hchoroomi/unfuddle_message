require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/unfuddle_message_spec.rb'

describe Comment do
  it_should_behave_like 'UnfuddleMessage'
end
