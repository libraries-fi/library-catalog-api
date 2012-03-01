# This file is part of Library Catalog API
# Copyright (C) 2011,2012  Kisko Labs Oy
#
# Library Catalog API is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'title_holdings'
require 'nokogiri'
require 'date'

# Holdings info for an innovative interfaces Millennium AirPac
class AirPacHoldings < TitleHoldings

  def initialize(base_url)
    super(base_url + "/search~S9?/.%{record_id}/.%{record_id}/1,1,1,B/holdings~")
  end

  def parse_results(doc)
    results = []
    doc.css('tr.bibItemsEntry').each do |row|
      cells = row.css('td')
      resultrow = {
        :location => self.clean_value(cells[0].text),
        :shelf => self.clean_value(cells[1].text),
        :status => self.clean_value(cells[2].text)
      }
      if resultrow[:status].match(/^DUE/)
        resultrow[:date] = self.parse_date(self.clean_value(cells[2].text))
        resultrow[:status] = 'DUE'
      end
      results.push(resultrow)
    end
    results
  end

  def preprocess_results(string_io)
    in_there = false
    partial_doc = ""
    # todo: preformance?
    string_io.each_line do |line|
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
    partial_doc
  end

  def clean_value(str)
    nbsp = Nokogiri::HTML("&nbsp;").text
    str.gsub(nbsp, '').strip
  end

  def parse_date(dstring)
    match = dstring.match(/[0-9]{2}-[0-9]{2}-[0-9]{2}/)
    if match
      Date.strptime(match[0], '%d-%m-%y')
    else
      nil
    end
  end

end
