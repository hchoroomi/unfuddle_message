$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'net/https'
require 'unfuddle_message/pop' # POP3 lib from Ruby 1.9 with SSL support
require 'tmail' # gem to be installed
require 'hpricot'
require 'open-uri'

setting = YAML.load(
            File.read(
              File.dirname(__FILE__) + "/../config/settings.yml"))

UNFUDDLE_SETTINGS = setting['unfuddle']
POP3_SETTINGS     = setting['pop3']

require 'unfuddle_message'
require 'unfuddle_message/models'
require 'unfuddle_message/unfuddle_api'

class UnfuddleMessageRunner

  def self.run!
    Person.load_all

    Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)

    Net::POP3.start(POP3_SETTINGS['server'], 
                    POP3_SETTINGS['port'], 
                    POP3_SETTINGS['username'], 
                    POP3_SETTINGS['password']) do |pop|

      pop.each_mail { |message|
        email = TMail::Mail.parse(message.pop)

        if person = Person.find_by_email(email.from.first)
          puts "Processing #{email.subject} from #{email.from}..."

          if message_id = UnfuddleMessage.message_id(email.subject)
            Comment.url = "messages/#{message_id}/comments"
            comment = Comment.new(:body      => email.body, 
                                  :author_id => person)

            puts "Posting comment to unfuddle..."
            comment.post
          else
            Message.url = "messages"
            message = Message.new(:title     => email.subject, 
                                  :body      => email.body, 
                                  :author_id => person)

            puts "Posting message to unfuddle..."
            message.post
          end

        end

        message.delete if POP3_SETTINGS[:delete]
      }

    end
  end

end

