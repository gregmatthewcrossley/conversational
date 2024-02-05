class Location < ApplicationRecord
  belongs_to :conversation

  after_create_commit -> { 
    broadcast_prepend_to [self.conversation, "locations"],
      partial: "locations/location_row", 
      locals: { location: self }, 
      target: "locations" 
  }
  after_create_commit -> {
    # Generate topics for the location
    topics = Topics::GooglePlacesService.call(self.latitude, self.longitude)
    # Generate remarks for one of the topics
    remark_text = Remarks::TextGeneratorService.call(topics.sample)
    # Generate an audio file for the remark
    remark_audio = Remarks::AudioGeneratorService.call(remark_text)
    # Encode the audio file as a base64 string
    remark_audio_base_64_encoded = Base64.encode64(remark_audio)
    # Update the DOM with the new audio remark (will autoplay)
    broadcast_prepend_to [self.conversation, "locations"],
      partial: "locations/audio_row", 
      locals: { location: self, audio_base_64: remark_audio_base_64_encoded}, 
      target: "locations" 
  }
end
