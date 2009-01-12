# TODO do something with errors!
class UnfuddleApi

  BASE_URL = "/api/v1/projects/#{UNFUDDLE_SETTINGS['project_id']}/"

  def initialize
    @http = Net::HTTP.new("#{UNFUDDLE_SETTINGS['subdomain']}.unfuddle.com", 
                             UNFUDDLE_SETTINGS['ssl'] ? 443 : 80)    
    
    if UNFUDDLE_SETTINGS['ssl']
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def post(url, xml)
    request = Net::HTTP::Post.new(BASE_URL + url, {'Content-type' => 'application/xml'})
    request.basic_auth UNFUDDLE_SETTINGS['username'], UNFUDDLE_SETTINGS['password']
    request.body = xml 
    @http.request(request)
  end

  def get(url)
    request = Net::HTTP::Get.new(BASE_URL + url, {'Content-type' => 'application/xml'})
    request.basic_auth UNFUDDLE_SETTINGS['username'], UNFUDDLE_SETTINGS['password']
    @http.request(request)
  end
end
