class GooglePlacesService < BaseService
  include HTTParty
  base_uri "https://places.googleapis.com"

  def initialize(lat, long)
    # validate lat and long
    raise ArgumentError, "lat must be between -90 and 90" unless lat.between?(-90.0, 90.0)
    raise ArgumentError, "long must be between -180 and 180" unless long.between?(-180.0, 180.0)
    # cast lat and long to decimals and store them as instance variables
    @lat = lat.to_d
    @long = long.to_d
    @options = {
      body: body,
      headers: headers
    }
    # initialize the @client variable
    super()
  end

  def call
    response = self.class.post("/v1/places:searchNearby", **@options).deep_symbolize_keys.dig(:places)
    response.map do |place|
      "#{place.dig(:displayName, :text)}, a #{place.dig(:primaryTypeDisplayName, :text)&.downcase} in #{location_description}" # e.g. "The Louvre, a museum in Paris, France"
    end
  end

  private

  def location_description
    @location_description ||= fetch_location_description
  end

  def fetch_location_description
    response = self.class.post("/v1/places:searchNearby", body: location_description_body, headers: headers).deep_symbolize_keys.dig(:places)
    response.first&.dig(:displayName, :text)
  end

  def location_description_body
    {
      includedTypes: ["locality"],
      rankPreference: "DISTANCE",
      maxResultCount: 1,
      locationRestriction: {
        circle: {
          center: {
            latitude: @lat,
            longitude: @long
          },
          radius: 5000.0 # meters
        }
      }
    }.to_json
  end

  def body
    # see: https://developers.google.com/maps/documentation/places/web-service/nearby-search#optional-parameters
    {
      includedTypes: included_types,
      maxResultCount: 10,
      locationRestriction: {
        circle: {
          center: {
            latitude: @lat,
            longitude: @long
          },
          radius: 1000.0 # meters
        }
      }
    }.to_json
  end

  def headers
    {
      "Content-Type" => "application/json",
      "X-Goog-Api-Key" => Rails.application.credentials.dig(:google, :places_api_token),
      "X-Goog-FieldMask" => field_mask_strings
    }
  end

  def field_mask_strings
    # see: https://developers.google.com/maps/documentation/places/web-service/nearby-search#fieldmask
    %w[
      places.displayName
      places.primaryTypeDisplayName
      places.types
      places.location
    ].join(",")
  end

  def included_types
    %w[
      farm
      art_gallery
      museum
      performing_arts_theater
      library
      school
      university
      amusement_park
      aquarium
      community_center
      cultural_center
      hiking_area
      historical_landmark
      marina
      movie_theater
      night_club
      park
      tourist_attraction
      zoo
      bar
      cafe
      restaurant
      locality
      city_hall
      courthouse
      fire_station
      post_office
      hospital
      campground
      hostel
      hotel
      church
      hindu_temple
      mosque
      synagogue
      market
      shopping_mall
      golf_course
      stadium
      swimming_pool
      airport
      ferry_terminal
      subway_station
      train_station
    ]
  end

  # def included_primary_types
  #   # see https://developers.google.com/maps/documentation/places/web-service/nearby-search#includedprimarytypes
  #   %w(
  #     administrative_area_level_3
  #     administrative_area_level_4
  #     administrative_area_level_5
  #     administrative_area_level_6
  #     administrative_area_level_7
  #     archipelago
  #     colloquial_area
  #     continent
  #     establishment
  #     floor
  #     food
  #     general_contractor
  #     geocode
  #     health
  #     intersection
  #     landmark
  #     natural_feature
  #     neighborhood
  #     place_of_worship
  #     plus_code
  #     point_of_interest
  #     political
  #     post_box
  #     postal_code_prefix
  #     postal_code_suffix
  #     postal_town
  #     premise
  #     room
  #     route
  #     street_address
  #     street_number
  #     sublocality
  #     sublocality_level_1
  #     sublocality_level_2
  #     sublocality_level_3
  #     sublocality_level_4
  #     sublocality_level_5
  #     subpremise
  #     town_square
  #   ).join(",")
  # end
end
