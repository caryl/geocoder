require 'geocoder/lookups/base'
require "geocoder/results/baidu"

module Geocoder::Lookup
  class Baidu < Base

    def map_link_url(coordinates)
      "http://map.baidu.com?q=#{coordinates.join(',')}"
    end

    private # ---------------------------------------------------------------

    def results(query, reverse = false)
      return [] unless doc = fetch_data(query, reverse)
      case doc['status']; when "OK"
        return doc['result'].blank? ? [] : [doc['result']]
      when "INVALID_PARAMETERS"
        warn "Baidu Geocoding API error: invalid request."
      when "INVILID_KEY"
        warn "Baidu Geocoding API error: invalid api key."
      end
      return []
    end

    def query_url(query, reverse = false)
      params = {
        (reverse ? :location : :address) => query,
        :language => Geocoder::Configuration.language,
        :output => 'json',
        :key => Geocoder::Configuration.api_key
      }
      "#{protocol}://api.map.baidu.com/geocoder?" + hash_to_query(params)
    end
  end
end