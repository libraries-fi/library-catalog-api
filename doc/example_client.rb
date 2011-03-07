require "net/http"
require "json"

class Helmet
  def self.search_by_title(title)
    request = Net::HTTP::Get.new("/search/title.json?query=#{CGI.escape(title)}")
    http = Net::HTTP.new("localhost", 3000)
    response = http.start { |http| http.request(request) }
    
    if response.class.superclass == Net::HTTPSuccess
      return JSON.parse(response.body)
    else
      raise "HTTP request failed: #{response.code}"
    end
  end
end

Helmet.search_by_title("ja") # Returns Ruby hash generated from the JSON
