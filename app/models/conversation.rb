class Conversation < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_many :remarks, through: :locations

  accepts_nested_attributes_for :locations, allow_destroy: true

  # validate whether the conversation has a valid program (ok to be nil)
  validate :program_class_is_a_valid_class, if: -> { program_class.present? }
  validates :started_at, presence: true, if: -> { ended_at.present? }

  before_save :clear_the_ended_at_time, if: :started_at_changed_to_non_nil?
  before_save :set_default_program_class, unless: -> { program_class.present? }

  scope :started, -> { where.not(started_at: nil) }

  after_save_commit -> {
    broadcast_replace_later_to "stream_for_conversation_#{id}",
      partial: "conversations/buttons",
      locals: {conversation: self},
      target: "buttons"
  }

  def program
    @program ||= program_class.constantize.new(self)
  end

  def started?
    started_at.present? && ended_at.nil?
  end

  def start!
    return true if started?
    ActiveRecord::Base.transaction do
      update!(started_at: Time.current)
      start_the_program
    end
  end

  def not_started?
    # never started or started then ended
    (started_at.nil? && ended_at.nil?) || (started_at.present? && ended_at.present?)
  end
  alias_method :ended?, :not_started?

  def end!
    return true if not_started?
    ActiveRecord::Base.transaction do
      update!(ended_at: Time.current)
    end
  end

  def self.end_all!
    started.each(&:end!)
  end

  def unsent_remark_count
    remarks.unsent.count
  end

  def latest_location
    locations.last
  end

  def update_latest_topic_if_necessary!
    if latest_topic.nil? || latest_location.nearby_points_of_interest.exclude?(latest_topic)
      update!(latest_topic: select_a_new_topic)
    end
  end

  delegate :select_a_new_topic, to: :program
  delegate :create_new_remark!, to: :program

  def broadcast_next_unsent_remark_audio
    # update the conversation's header with the latest unsent remark counts
    broadcast_replace_later_to "stream_for_conversation_#{id}",
      partial: "conversations/header",
      locals: {conversation: self},
      target: "header"

    remarks.reload
    remark = remarks.unsent.audio_generated.first
    return if remark.nil?
    remark.broadcast_audio_to_client
  end

  private

  def start_the_program
    ProgramDirectorJob.perform_later(id)
  end

  def clear_the_ended_at_time
    self.ended_at = nil
  end

  def started_at_changed_to_non_nil?
    started_at_changed? && started_at.present?
  end

  def program_class_is_a_valid_class
    unless Object.const_defined?(program_class)
      errors.add(:program_class, "is not a valid class")
    end
    # unless program.in?(Programs::Base.all_programs)
    #   errors.add(:program_class, "is not a valid program")
    # end
  end

  def set_default_program_class
    self.program_class = "Programs::Podcast"
  end
end
