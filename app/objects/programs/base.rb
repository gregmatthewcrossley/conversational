class Programs::Base
  def initialize(conversation)
    raise ArgumentError, "conversation must be a Conversation" unless conversation.is_a?(Conversation)
    @conversation = conversation
  end

  def name
    self.class.name.demodulize
  end

  def role_description_for(speaker)
    raise ArgumentError, "speaker must be a Class" unless speaker.is_a?(Class)
    self.class::SPEAKERS_AND_ROLES[speaker]
  end

  def speakers
    self.class::SPEAKERS_AND_ROLES.keys
  end

  def speaker_names
    speakers.map { |s| s.name.demodulize }
  end

  def select_a_new_topic
    raise StandardError, "Conversation #{@conversation.id} does not yet have any locations" unless @conversation.latest_location.present?
    @conversation.latest_location.nearby_points_of_interest.first # just pick the nearest point of interest for now
  end

  def build_next_remark
    recent_remarks = @conversation.remarks.last(5)

    # determine the next speaker (should be any speaker other than the last speaker)
    previous_speaker = recent_remarks.last&.speaker || speakers.first
    next_speaker = speakers.reject { |s| s == previous_speaker }.sample

    # Given the current point of interest and recent remarks, ask the next speaker to say something
    # while acting out the role assigned to them by this Program
    next_remark_body = next_speaker.say_something_about(
      @conversation.latest_topic,
      recent_remarks: recent_remarks,
      role_description: role_description_for(next_speaker)
    )

    # build the next remark
    Remark.build(
      speaker: next_speaker,
      content: next_remark_body,
      location: @conversation.latest_location
    )
  end
end
