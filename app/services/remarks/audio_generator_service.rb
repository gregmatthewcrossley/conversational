class AudioGeneratorService::Remarks < BaseService::Remarks
  PERSONALITIES = %w[alloy echo fable onyx nova shimmer] # see: https://platform.openai.com/docs/guides/text-to-speech/voice-options

  def initialize(remark_text)
    raise ArgumentError, "remark_text must be a String" unless remark_text.is_a?(String) && remark_text.present?
    @remark_text = remark_text
    super() # will initialize the @client variable
  end

  def call
    # Use the context of the conversation to generate an audio remark
    # via the Google Cloud Text-to-Speech API.
    # Returns an audio file as a blob (mp3).
    # see: https://github.com/alexrudall/ruby-openai?tab=readme-ov-file#speech

    response = @client.audio.speech(
      parameters: {
        model: "tts-1",
        input: @remark_text,
        voice: PERSONALITIES[0]
      }
    )
    if File.binwrite('demo.mp3', response)
      puts "Audio file written successfully to demo.mp3"
    else
      raise "Error: Could not write the audio file."
    end
  end
end
