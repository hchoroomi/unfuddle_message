require File.dirname(__FILE__) + '/spec_helper.rb'

describe Person do

  before(:each) do
    people_xml =<<-STR
      <people>
        <person>
          <id>1</id>
          <email>h@g.com</email>
        </person>
        <person>
          <id>2</id>
          <email>a@b.com</email>
        </person>
      </people>
    STR
    @response = mock('Response', :body => people_xml)
    
    @unfuddle_api = mock(UnfuddleApi)
    UnfuddleApi.stub!(:new).and_return(@unfuddle_api)
    @unfuddle_api.stub!(:get).with('people').and_return(@response)
  end

  it "should load all people" do 
    @unfuddle_api.should_receive(:get).with('people').and_return(@response)
    Person.load_all
  end

  it "should find id by its email" do
    Person.load_all
    Person.find_by_email('h@g.com').should == '1'
  end

  it "should return nil when email not found" do 
    Person.load_all
    Person.find_by_email('not@found.com').should be_nil
  end

end
