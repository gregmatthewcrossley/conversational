class AudioGeneratorService < BaseService
  AVAILABLE_VOICES = %w(
    alloy
    echo 
    fable 
    onyx 
    nova
    shimmer
  ) # see: https://platform.openai.com/docs/guides/text-to-speech/voice-options

  def initialize(remark_content, voice: AVAILABLE_VOICES[2], format: :mp3, encoding: :base_64_encoded)
    raise ArgumentError, "remark_content must be a String" unless remark_content.is_a?(String) && remark_content.present?
    raise ArgumentError, "voice (voice) must be one of #{AVAILABLE_VOICES.join(', ')}" unless voice.in?(AVAILABLE_VOICES)
    raise ArgumentError, "format must be :mp3" unless format.in?([:mp3])
    raise ArgumentError, "encoding must be :base_64_encoded" unless encoding.in?([:base_64_encoded])    
    @client = OpenAI::Client.new
    @remark_content = remark_content
    @voice = voice    
  end

  def call
    # Use the context of the conversation to generate an audio remark
    # via the Google Cloud Text-to-Speech API.
    # Returns an audio file as a blob (mp3).s
    # see: https://github.com/alexrudall/ruby-openai?tab=readme-ov-file#speech

    response = @client.audio.speech(
      parameters: {
        model: "tts-1",
        input: @remark_content,
        voice: @voice
      }
    )

    return convert_to_base_64(response)
  end 

  private

  def convert_to_base_64(blob)
    Base64.encode64(blob)
  end
end
