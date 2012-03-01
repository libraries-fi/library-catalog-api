class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :set_access_control_headers

  def set_access_control_headers
    if request.env.has_key?('HTTP_ORIGIN')
      request_origin = request.env['HTTP_ORIGIN']
      if request_origin.match(/^http:\/\/(localhost:|192.168.0.)/)
        headers['Access-Control-Allow-Origin'] = request_origin
        headers['Access-Control-Request-Method'] = '*'
      end
    end
  end

  private

  def records_as_json_with_itemids(records, callback = nil)
    json = (records.map {|record| "\"#{record.item_barcode}\": #{record.json}"}).join(",")
    json = wrap_page("\"records\":{#{json}}", records)
    wrap_json(json, callback)
  end

  def records_as_json(records, callback = nil)
    json = "\"records\":[#{records.map(&:json).join(",")}]"
    json = wrap_page(json, records)
    wrap_json(json, callback)
  end

  def wrap_json(json, callback = nil)
    if callback
      "#{callback}({#{json}})"
    else
      "{" + json + "}"
    end
  end

  def wrap_page(json, records = nil)
    if records and records.respond_to? :current_page
      json + ",\"current_page\":#{records.current_page},\"per_page\":#{records.per_page},\"total_entries\":#{records.total_entries}"
    else
      json
    end
  end

  def record_as_json(record, callback = nil)
    rec = ActiveSupport::JSON.decode(record.try(:json))
    holdings = get_holdings(record)

    if not holdings.nil?
      rec['holdings'] = holdings
    end

    if callback
      "#{callback}(#{rec.to_json})"
    else
      rec.to_json
    end
  end

  def get_holdings(record)
    config = Rails.configuration
    if (config.respond_to? :holdings_baseurl and
        config.respond_to? :holdings_implementation)

      base_url, holdings_classname = config.holdings_baseurl, config.holdings_implementation
      begin
        holdings_fetcher = Kernel.const_get(holdings_classname).new(base_url)
        helmet_id = record.helmet_id.gsub(/^\([^)]+\)/, '')
        holdings = holdings_fetcher.holdings(helmet_id)
      rescue Exception => e
        holdings = [{:error => "Misconfigured holdings class. Contact the API administrator."}]
      end
      holdings
    else
      nil
    end
  end

end
