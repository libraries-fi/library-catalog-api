
require 'nokogiri'
require 'open-uri'

class TitleHoldings

  def initialize(url_template)
    @url_template = url_template
  end

  def holdings(record_id)
    url = self.construct_url(record_id)
    begin
      result = Nokogiri::HTML(open(url))
    rescue Exception => e
      return [{:error => "There was an error retrieving the holdings information."}]
    end
    return parse_results(result)
  end

  protected

  def parse_results(doc)
    raise NotImplementedError, ""
  end

  def construct_url(record_id)
    @url_template % { :record_id => record_id }
  end

end
