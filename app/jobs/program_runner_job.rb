class ProgramRunnerJob < ApplicationJob
  include Turbo::Broadcastable

  queue_as :default

  def perform(conversation_id, most_recent_point_of_interest: nil)
    begin
      @conversation = Conversation.find(conversation_id)
      @program = @conversation.program
      @recent_remarks = @conversation.remarks.last(5)
      @latest_location = @conversation.locations.last
      @current_point_of_interest = "Danforth Music Halll in Toronto" #set_current_point_of_interest(most_recent_point_of_interest)

      # Ask the Program to generate the next remark, based on the current location and recent remarks
      new_remark = @program
        .build_next_remark( # build the remark
            @current_point_of_interest, 
            @recent_remarks,
          )
        .tap { |r| r.location = @latest_location } # associate the remark with the current location
      new_remark.save! # save the remark to the database

      new_remark_audio = new_remark
        .generate_audio(
          format: :mp3, 
          encoding: :base_64_encoded
        )

      # send the new remark's audio to the client and prepend it to the DOM
      @conversation.broadcast_audio(new_remark_audio) unless @conversation.reload.not_started?
    ensure
      # re-enqueue this job if the conversation is still active
      ProgramRunnerJob.set(wait: 2.seconds).perform_later(conversation_id) unless @conversation.reload.not_started?
    end
  end

  private

  def set_current_point_of_interest(most_recent_point_of_interest)
    # set the topic of conversation for the next remark
    if most_recent_point_of_interest.nil? || @latest_location.nearby_points_of_interest.exclude?(most_recent_point_of_interest)
      # if there is no recent topic of conversation, or the client is no longer near the current topic of conversation,
      # then set the current topic of conversation to the nearest interesting thing
      @current_point_of_interest = @latest_location.nearby_points_of_interest.first # should be the nearest thing
    elsif @latest_location.nearby_points_of_interest.include?(most_recent_point_of_interest)
      # if the client is still near the most recent topic of conversation, then continue
      # discussing the current topic of conversation
      @current_point_of_interest = most_recent_point_of_interest
    else
      @current_point_of_interest = nil
      # raise StandardError, "There are no interesting things nearby."
    end
  end

end
