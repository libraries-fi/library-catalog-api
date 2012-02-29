
require 'nokogiri'
require 'open-uri'

class TitleHoldings

  def initialize(url_template)
    @url_template = url_template
  end

  def holdings(record_id)
    url = self.construct_url(record_id)
    in_there = false
    partial_doc = ""
    # todo: preformance?
    foo = open(url) do |file|
      while line = file.gets
        if line.match(/<div  class="additionalCopies">/)
          in_there = true
        elsif in_there and line.match(/<\/div>/)
          in_there = false
          partial_doc += line
        end
        if in_there
          partial_doc += line
        end
      end
    end
    begin
      result = Nokogiri::HTML(partial_doc)
    rescue Exception => e
      return [{:error => "There was an error retrieving the holdings information. #{e}"}]
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
