class TextGeneratorService < BaseService
  def initialize(prompts)
    raise ArgumentError, "prompts must be an Array of prompt Hashes" unless prompts.is_a?(Array) && prompts.all? { |p| p.is_a?(Hash) }
    # ensure each hash has the keys :role and :content
    raise ArgumentError, "each prompt must have the keys :role and :content" unless prompts.all? { |p| p.keys.sort == [:content, :role] }
    # ensure the values of each hash are all Strings
    raise ArgumentError, "each prompt's :role and :content must be a String" unless prompts.all? { |p| p.values.all? { |v| v.is_a?(String) } }
    @prompts = prompts
    @client = OpenAI::Client.new
  end

  def call
    # Call OpenAI's chat API
    # see: https://github.com/alexrudall/ruby-openai?tab=readme-ov-file#chat
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo-0125", # see: https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo
        messages: @prompts
        # temperature: 1.8 # range is 0.0 to 2.0, see: https://platform.openai.com/docs/api-reference/chat/create#chat-create-temperature
      }
    )

    # extract the response from the API
    response_text = response
      .dig("choices", 0, "message", "content") # extract the response from the API
      .delete("\t\r\n") # remove newlines, etc.

    response_text.tap do |s|
      Rails.logger.info("Prompt: #{@prompts.inspect}")
      Rails.logger.info("Result: #{s}")
    end
  end
end
