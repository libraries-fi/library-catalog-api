
require 'title_holdings'
require 'open-uri'

# This class checks if there are any holds for the title
class AirPacHoldCheck < TitleHoldings

  def initialize(base_url)
    super(base_url + "/record=%{record_id}")
  end

  def has_holds(record_id)
    id_re = /b[0-9]+/
    match = id_re.match(record_id)
    url = self.construct_url(match[0])
    string_io = open(url)
    message_re = /<span class="bibHolds">([0-9]+) holds on first copy returned of [0-9]+ copies<\/span>/m
    doc = string_io.read(nil)
    puts doc
    match = message_re.match(doc)
    if match
      return match[1]
    else
      return 0
    end
  end
end
