class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def records_as_json(records, jsonp = nil)
    json = {:records => records.map(&:json)}
    if records.respond_to? :current_page
      json.merge({
        :current_page => records.current_page,
        :per_page => records.per_page,
        :total_entries => records.total_entries
      })
    end

    if jsonp
      "#{jsonp}(#{json.to_json})"
    else
      json.to_json
    end
  end

  def record_as_json(record, jsonp = nil)
    if jsonp
      "#{jsonp}(#{record.json})"
    else
      record.json
    end
  end
end
