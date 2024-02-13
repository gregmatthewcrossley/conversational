module FindsPois
  extend ActiveSupport::Concern

  included do
    def nearby_points_of_interest
      @nearby_points_of_interest ||= GooglePlacesService.call(latitude, longitude)
    end
  end
end
