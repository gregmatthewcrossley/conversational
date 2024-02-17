module BroadcastsAudio
  extend ActiveSupport::Concern

  included do
    def broadcast_audio_for(remark)
      audio = remark.generate_audio
      broadcast_append_to "stream_for_conversation_#{id}",
        partial: "conversations/audio_remark", # note: this partial is for a single audio remark, not the entire unheard audio remark queue
        locals: {audio_base_64: audio, remark: remark},
        target: "audio-remark-queue"
    end
  end
end
