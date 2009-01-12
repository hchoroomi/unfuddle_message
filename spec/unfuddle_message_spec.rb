require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'UnfuddleMessage', :shared => true do

  before(:each) do
    @unfuddle_message = UnfuddleMessage.new(:author_id => '123', :body => 'body content')
  end
  
  it "should convert all instance variables into xml string" do
    @unfuddle_message.to_xml.should == 
      '<unfuddlemessage><author_id>123</author_id><body>body content</body></unfuddlemessage>'
  end

  it "should get the attribute" do
    @unfuddle_message.author_id.should == '123'
  end

  it "should return the class_name" do
    @unfuddle_message.class_name.should == 'unfuddlemessage'
  end

  it "should return its attributes" do
    @unfuddle_message.attributes.should == ["author_id", "body"]
  end

  it "should respond to url" do
    UnfuddleMessage.url = 'http://sample.com'
    UnfuddleMessage.url.should == 'http://sample.com'
  end

  describe 'message_id' do
    it "should get the message id with msg identifer in the subject" do
      subject = "[LANG-MSG-1234] Test subject..."
      UnfuddleMessage.message_id(subject).should == '1234'
    end

    it "should return nil without no msg identifer" do
      subject = "No message identifer"
      UnfuddleMessage.message_id(subject).should be_nil
    end
  end
end
