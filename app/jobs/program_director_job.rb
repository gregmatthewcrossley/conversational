class ProgramDirectorJob < ApplicationJob
  include Turbo::Broadcastable

  queue_as :default

  MAX_UNHEARD_REMARKS = 3

  def perform(conversation_id)
    @conversation = Conversation.find(conversation_id)
    @latest_topic = @conversation.latest_topic
    @latest_location = @conversation.latest_location

    if @conversation.unheard_remark_count < MAX_UNHEARD_REMARKS
      # don't create remarks too far in advance of what the client has heard
      generate_a_new_remark
    end
    broadcast_latest_unheard_remark
  ensure
    # even if an error occurs, re-enqueue this job to run again in 2 seconds
    # as long as the conversation is still active.
    ProgramDirectorJob.set(wait: 2.seconds).perform_later(@conversation.id) unless @conversation.reload.not_started?
  end

  private

  def if_conversation_is_not_ended(&action_block)
    @conversation.reload
    action_block.call unless @conversation.ended?
  end

  def generate_a_new_remark
    # Each of these steps take a non-trival amount of time,
    # during which it's possible that the conversation has ended.

    # ensure the latest topic of conversation is appropriate
    # given the client's current location
    if_conversation_is_not_ended do
      @conversation.update_latest_topic_if_necessary!
    end

    # generate the next remark
    if_conversation_is_not_ended do
      @conversation.create_new_remark!
    end
  end

  # def broadcast_all_unheard_remarks
  #   # sends each unhear remark's audio to the client and add it to the audio queue in the DOM
  #   if_conversation_is_not_ended do
  #     @conversation.remarks.unheard.each do |remark|
  #       @conversation.broadcast_audio_for(remark)
  #     end
  #   end
  # end

  def broadcast_latest_unheard_remark
    # sends each unhear remark's audio to the client and add it to the audio queue in the DOM
    if_conversation_is_not_ended do
      @conversation.broadcast_audio_for(@conversation.remarks.last)
    end
  end
end
