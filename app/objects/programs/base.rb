class Programs::Base

  def initialize(conversation)
    raise ArgumentError, "conversation must be a Conversation" unless conversation.is_a?(Conversation)
    @conversation = conversation 
  end

  def role_description_for(speaker)
    raise ArgumentError, "speaker must be a Class" unless speaker.is_a?(Class)
    self.class::SPEAKERS_AND_ROLES[speaker]
  end

  def speakers
    self.class::SPEAKERS_AND_ROLES.keys
  end

  def build_next_remark(current_point_of_interest, recent_remarks)
    raise ArgumentError, "current_point_of_interest must be a String" unless current_point_of_interest.is_a?(String)
    raise ArgumentError, "recent_remarks must be a collection of Remarks" unless recent_remarks.respond_to?(:all?) && recent_remarks.all? { |r| r.is_a?(Remark) }
    
    # determine the next speaker (should be any speaker other than the last speaker)
    previous_speaker = recent_remarks.last&.speaker || speakers.first
    next_speaker = speakers.reject { |s| s == previous_speaker }.sample

    # Given the current point of interest and recent remarks, ask the next speaker to say something
    # while acting out the role assigned to them by this Program
    next_remark_body = next_speaker.say_something_about(
      current_point_of_interest,
      recent_remarks: recent_remarks,
      role_description: role_description_for(next_speaker)
    )

    Remark.build(
      speaker: next_speaker,
      content: next_remark_body
    )
  end

end