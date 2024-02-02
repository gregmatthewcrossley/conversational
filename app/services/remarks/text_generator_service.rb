class Remarks::TextGeneratorService < Remarks::BaseService
  def initialize(place_description, last_said = nil)
    raise ArgumentError, "place_description must be a String, and should be something like 'Greenwhich Village, New York City'" unless place_description.is_a?(String) && place_description.present?
    @place_description = place_description
    if last_said.present?
      raise ArgumentError, "last_said must be a String, and should be the last thing this app said" unless last_said.is_a?(String)
      @last_said = last_said
    end
    super() # will initialize the @client variable
  end

  def call
    # Use the context of the conversation to generate and a text remark
    # via the OpenAI GPT-3 API.
    # Returns a string.
    # See: https://github.com/alexrudall/ruby-openai?tab=readme-ov-file#chat

    response = @client.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: [
          { 
            role: "system", 
            content: "You are a friendly, knowledgeable and curious talk radio personality."
          },
          {
            role: "user",
            content: "This is where I am right now: #{@place_description}. Please tell me about it in a sentence or two."
          }
        ],
        temperature: 1.0,
    })
    return response
      .dig("choices", 0, "message", "content") # extract the response from the API
      .delete("\t\r\n") # remove newlines, etc.
  end
end
