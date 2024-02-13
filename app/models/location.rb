class Location < ApplicationRecord

  include FindsPois

  belongs_to :conversation
  has_many :remarks, dependent: :destroy

  # after_create_commit -> { 
  #   broadcast_prepend_to [self.conversation, "locations"], # TODO: is this the correct stream name?
  #     partial: "locations/location_row", 
  #     locals: { location: self }, 
  #     target: "locations" 
  # }
end
