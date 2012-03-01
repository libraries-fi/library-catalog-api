
require 'nokogiri'
require 'open-uri'

class TitleHoldings
  attr_accessor :base_url, :url_template

  def initialize(url_template = nil)
    @url_template = url_template
  end

  def holdings(record_id)
    url = self.construct_url(record_id)
    string_io = open(url)
    partial_doc = self.preprocess_results(string_io)
    begin
      result = Nokogiri::HTML(partial_doc)
    rescue Exception => e
      return [{:error =>
                "There was an error retrieving the holdings information. #{e}"}]
    end
    return parse_results(result)
  end

  protected

  def construct_url(record_id)
    @url_template % {
      :record_id => record_id}
  end

  # might implement in subclasses:
  def preprocess_results(string_io)
    return string_io
  end

  # must implement in subclasses:
  def parse_results(doc)
    raise NotImplementedError, ""
  end

end
