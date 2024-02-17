class Location < ApplicationRecord
  include Mappable
  include FindsPois

  belongs_to :conversation
  has_many :remarks, dependent: :destroy

  after_create_commit -> {
    broadcast_replace_later_to "stream_for_conversation_#{conversation.id}",
      partial: "conversations/map",
      locals: {conversation: conversation},
      target: "map"
    broadcast_replace_later_to "stream_for_conversation_#{conversation.id}",
      partial: "conversations/nearby_poi_list",
      locals: {conversation: conversation},
      target: "nearby-poi-list"
    broadcast_prepend_later_to "stream_for_conversation_#{conversation.id}",
      partial: "locations/location_row",
      locals: {location: self},
      target: "locations"
  }
end
