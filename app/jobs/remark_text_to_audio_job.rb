class RemarkTextToAudioJob < ApplicationJob
  queue_as :default

  def perform(remark_id)
    @remark = Remark.find(remark_id)
    raise ArgumentError, "remark must have content that is a String" unless @remark.content.is_a?(String) && @remark.content.present?

    audio_binary_data = @remark.speaker.speak(@remark.content)

    @remark.update!(audio_binary_data: audio_binary_data)
  end
end
