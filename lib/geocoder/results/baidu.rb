require 'geocoder/results/base'

module Geocoder::Result
  class Baidu < Base

    def coordinates
      ['lat', 'lng'].map{ |i| @data['location'][i] }
    end

    def address
      formatted_address
    end

    def state
      province
    end
    
    def state_code
      "" 
    end

    def postal_code
      ""
    end
    
    def country_code
      ""
    end
    
    def province_code
      ""
    end

    def country
      'China' 
    end
    
    def province
      if province = address_components_of_type(:province).first
        province.last
      end
    end

    def city
      if city = address_components_of_type(:city).first
        city.last
      end
    end

    def district
      if district = address_components_of_type(:district).first
        district.last
      end
    end

    def street
      if street = address_components_of_type(:street).first
        street.last
      end
    end

    def street_number
      if street_num = address_components_of_type(:street_number).first
        street_num.last
      end
    end

    def formatted_address
      @data['formatted_address']
    end

    def address_components
      @data['addressComponent']
    end

    ##
    # Get address components of a given type. Valid types are defined in
    # Baidu's Geocoding API documentation and include (among others):
    #
    #   :street_number
    #   :street
    #   :district
    #   :city
    #   :province
    #
    def address_components_of_type(type)
      address_components.select{ |k, v| k == type.to_s }
    end

    def self.response_attributes
      %w[business cityCode]
    end

    response_attributes.each do |a|
      define_method a do
        @data[a]
      end
    end

  end
end