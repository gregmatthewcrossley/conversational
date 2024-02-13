module BroadcastsAudio
  extend ActiveSupport::Concern

  included do
    def broadcast_audio(audio)
      broadcast_append_to [self, "locations"],
        partial: "conversations/audio_remark", 
        locals: { location: self, audio_base_64: audio}, 
        target: "audio-remark-queue"
    end
  end
end
