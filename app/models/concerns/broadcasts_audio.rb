module BroadcastsAudio # included in the Remark class
  extend ActiveSupport::Concern

  included do
    def broadcast_audio_to_client
      raise StandardError, "Remark #{id} has already been sent" if sent_at.present?
      raise StandardError, "Remark #{id} has no audio" if audio_binary_data.blank?
      # send the audio to the client
      broadcast_append_to "stream_for_conversation_#{id}",
        partial: "conversations/audio_remark", # note: this partial is for a single audio remark, not the entire audio remark queue
        locals: {remark: self},
        target: "audio-remark-queue"
      # mark the remark as sent
      update!(sent_at: Time.current)
    end
  end
end
