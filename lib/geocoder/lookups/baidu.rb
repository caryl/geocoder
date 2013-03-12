require 'geocoder/lookups/base'
require "geocoder/results/baidu"

module Geocoder::Lookup
  class Baidu < Base

    def name
      "Baidu"
    end

    def map_link_url(coordinates)
      "http://map.baidu.com?q=#{coordinates.join(',')}"
    end

    def required_api_key_parts
      ["key"]
    end

    def query_url(query)
      "#{protocol}://api.map.baidu.com/geocoder?" + url_query_string(query)
    end

    private # ---------------------------------------------------------------

    def results(query)
      return [] unless doc = fetch_data(query)
      case doc['status']; when "OK"
        return doc['result'].blank? ? [] : [doc['result']]
      when "INVALID_PARAMETERS"
        warn "Baidu Geocoding API error: invalid request."
      when "INVILID_KEY"
        warn "Baidu Geocoding API error: invalid api key."
      end
      return []
    end

    def query_url_params(query)
      {
        (query.reverse_geocode? ? :location : :address) => query.sanitized_text,
        :language => configuration.language,
        :output => 'json',
        :key => configuration.api_key
      }.merge(super)
    end
  end
end