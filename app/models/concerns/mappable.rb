require "active_support/concern"

module Mappable
  extend ActiveSupport::Concern

  included do
    def map_image_data
      # Returns a square Google Map PNG image
      # encoded as base 64.
      # Example Google Maps Static API call:
      # https://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=400x400&maptype=satellite&key=&signature=YOUR_SIGNATURE

      url = "https://maps.googleapis.com/maps/api/staticmap"
      query_options = {
        center: "#{latitude},#{longitude}",
        markers: "color:red|#{latitude},#{longitude}",
        zoom: 14,
        size: "400x400",
        maptype: "roadmap",
        key: Rails.application.credentials.dig(:google, :places_api_token)
      }
      image_data = HTTParty.get(url, query: query_options).body
      Base64.strict_encode64(image_data)
    end
  end
end
