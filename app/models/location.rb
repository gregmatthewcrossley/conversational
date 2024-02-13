class Location < ApplicationRecord
  include Mappable
  include FindsPois

  belongs_to :conversation
  has_many :remarks, dependent: :destroy

  after_create_commit -> {
    broadcast_append_to "conversation_stream_#{conversation.id}", content: "New content!"
  }

  # after_create_commit -> {
  #   broadcast_prepend_to "conversation_stream_#{conversation.id}",
  #     partial: "conversations/map",
  #     locals: {conversation: conversation},
  #     target: "map"
  #   broadcast_prepend_to "conversation_stream_#{conversation.id}",
  #     partial: "conversations/nearby_poi_list",
  #     locals: {conversation: conversation},
  #     target: "nearby-poi-list"
  # }
end
