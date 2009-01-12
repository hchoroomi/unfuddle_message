class UnfuddleMessage

  VERSION = '0.0.1'
  
  attr_accessor :body, :author_id

  class << self
    attr_accessor :url
  end

  def initialize(options)
    options.each do |key, value|
      self.instance_variable_set "@#{key}", value
    end
  end

  def class_name
    self.class.to_s.downcase
  end

  def to_xml
    result  = ''
    result += "<#{class_name}>"
    attributes.map.each do |attr_name|
      result += "<#{attr_name}>#{xml_escape(self.send(attr_name))}</#{attr_name}>"
    end
    result += "</#{class_name}>"
  end
  
  def xml_escape(s)
    s.gsub('&', '&amp;').gsub('<','&lt;').gsub('>', '&gt;') if s.is_a?(String)
  end
  
  def attributes
    (methods - Object.instance_methods).select { |name| name =~ /=/ }.map { |name| name.sub('=', '')}.uniq.sort
  end

  def post
    puts UnfuddleApi.new.post(self.class.url, self.to_xml) 
  end

  def self.message_id(subject)
    subject.match(/\[LANG-MSG-(\d+)\]/i)[1] rescue nil
  end

end

