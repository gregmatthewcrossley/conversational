class ProgramDirectorJob < ApplicationJob
  include Turbo::Broadcastable

  queue_as :default

  UNSENT_REMARK_QUEUE_MAX_SIZE = 3

  def perform(conversation_id)
    @conversation = Conversation.find(conversation_id)

    # start generating a new remark, unless there are too many unsent remarks already
    if @conversation.unsent_remark_count < UNSENT_REMARK_QUEUE_MAX_SIZE
      generate_a_new_remark
    end
    # send the next unsent remark's audio to the client
    broadcast_next_unsent_remark_audio
  ensure
    # even if an error occurs, re-enqueue this job to run again in 2 seconds
    # as long as the conversation is still active.
    ProgramDirectorJob.set(wait: 2.seconds).perform_later(@conversation.id) unless @conversation.reload.not_started?
  end

  private

  def if_conversation_is_not_ended(&action_block)
    # this method is used to ensure that no expensive
    # operations are needlessly performed on a conversation that has ended.
    @conversation.reload
    action_block.call unless @conversation.ended?
  end

  def generate_a_new_remark
    # ensure the latest topic of conversation is appropriate
    # given the client's current location
    if_conversation_is_not_ended do
      @conversation.update_latest_topic_if_necessary!
    end

    # generate the next remark (text only - audio will be generated later via a callback to RemarkTextToAudioJob)
    if_conversation_is_not_ended do
      @conversation.create_new_remark!
    end
  end

  def broadcast_next_unsent_remark_audio
    # sends the next unsent remark to the client and add it to the audio queue in the DOM
    if_conversation_is_not_ended do
      @conversation.broadcast_next_unsent_remark_audio
    end
  end
end
