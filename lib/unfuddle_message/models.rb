class Comment < UnfuddleMessage
end

class Message < UnfuddleMessage
  attr_accessor :title
end

class Person
  def self.load_all
    response = UnfuddleApi.new.get('people')    
    doc = Hpricot.parse(response.body)

    @people = {}
    (doc /:people/:person).each do |person|
      @people[(person /:email).text] = (person /:id).text
    end
  end

  def self.find_by_email(email)
    @people[email]
  end
end

