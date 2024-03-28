class Remark < ApplicationRecord
  include BroadcastsAudio

  belongs_to :location
  has_one :conversation, through: :location

  scope :sent, -> { where.not(sent_at: nil) }
  scope :unsent, -> { where(sent_at: nil) }
  scope :audio_generated, -> { where.not(audio_binary_data: nil) }
  scope :audio_not_generated, -> { where(audio_binary_data: nil) }

  validates :content, presence: true

  after_create_commit -> {
    # generate audio for the new remark
    RemarkTextToAudioJob.perform_later(id)
  }

  after_save_commit -> {
    # update the conversation's header with the latest unsent remark counts
    broadcast_replace_later_to "stream_for_conversation_#{conversation.id}",
      partial: "conversations/header",
      locals: {conversation: conversation},
      target: "header"
  }

  def speaker
    @speaker ||= speaker_class.constantize
  end

  def speaker=(speaker)
    self.speaker_class = speaker.name
    @speaker = speaker
  end

  # create an alias called :audio for the attribute :audio_binary_data
  alias_attribute :audio, :audio_binary_data

  def audio_base_64
    Base64.encode64(audio_binary_data)
  end
end
