require File.dirname(__FILE__) + '/spec_helper.rb'
require File.dirname(__FILE__) + '/unfuddle_message_spec.rb'

describe Message do
  it_should_behave_like 'UnfuddleMessage'

  it "should respond to title" do
    message = Message.new(:title => 'subject')
    message.title.should == 'subject'
  end
end
