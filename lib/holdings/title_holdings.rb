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
