class Location < ApplicationRecord
  belongs_to :conversation

  after_create_commit -> { 
    broadcast_prepend_to [self.conversation, "locations"],
      partial: "locations/location_row", 
      locals: { location: self }, 
      target: "locations" 
    }
end
