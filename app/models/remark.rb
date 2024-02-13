class Remark < ApplicationRecord
  belongs_to :location
  has_one :conversation, through: :location

  scope :heard, -> { where.not(heard_at: nil) }
  scope :unheard, -> { where(heard_at: nil) }

  validates :content, presence: true

  def speaker
    @speaker ||= speaker_class.constantize
  end

  def speaker=(speaker)
    self.speaker_class = speaker.name
    @speaker = speaker
  end

  def generate_audio(format: :mp3, encoding: :base_64_encoded)
    raise ArgumentError, "format must be :mp3" unless format.in?([:mp3])
    raise ArgumentError, "encoding must be :base_64_encoded" unless encoding.in?([:base_64_encoded])
    speaker.generate_audio(content, format: format, encoding: encoding)
  end
end
