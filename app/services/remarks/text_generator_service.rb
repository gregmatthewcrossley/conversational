class Remarks::TextGeneratorService < Remarks::BaseService
  def initialize(place_description)
    raise ArgumentError, "place_description must be a String, and should be something like 'Greenwhich Village a neighbourhood in New York City'" unless place_description.is_a?(String) && place_description.present?
    @place_description = place_description
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
            content: "You are a friendly, knowledgeable and curious tourgide who is accompanying me while I travel the world. At the moment, we are near #{@place_description}."
          },
          {
            role: "user",
            content: "Tourguide, please start the tour!"
          }
        ],
        temperature: 1.0,
    })
    return response
      .dig("choices", 0, "message", "content") # extract the response from the API
      .delete("\t\r\n") # remove newlines, etc.
  end
end
