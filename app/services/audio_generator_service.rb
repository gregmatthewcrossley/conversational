class AudioGeneratorService < BaseService
  AVAILABLE_VOICES = %w[
    alloy
    echo
    fable
    onyx
    nova
    shimmer
  ] # see: https://platform.openai.com/docs/guides/text-to-speech/voice-options

  def initialize(text, voice)
    raise ArgumentError, "text must be a String" unless text.is_a?(String) && text.present?
    raise ArgumentError, "voice must be one of #{AVAILABLE_VOICES.join(", ")}" unless AVAILABLE_VOICES.include?(voice)
    @text = text
    @voice = voice
    @client = OpenAI::Client.new
  end

  def call
    # Generate an audio remark
    # via the OpenAI Text-to-Speech API.
    # Returns an audio file as a blob (mp3 format).
    # see: https://github.com/alexrudall/ruby-openai?tab=readme-ov-file#speech

    @client.audio.speech(
      parameters: {
        model: "tts-1",
        input: @text,
        voice: @voice
      }
    )
  end
end
