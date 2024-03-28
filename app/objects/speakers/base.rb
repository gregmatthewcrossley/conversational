class Speakers::Base
  def self.write_a_remark_about(current_point_of_interest, recent_remarks:, role_description:)
    raise ArgumentError, "current_point_of_interest must be a String" unless current_point_of_interest.is_a?(String)
    raise ArgumentError, "recent_remarks must be a collection of Remarks" unless recent_remarks.respond_to?(:all?) && recent_remarks.all? { |r| r.is_a?(Remark) }
    raise ArgumentError, "role_description must be a String" unless role_description.is_a?(String)

    @prompts = [] # see: https://platform.openai.com/docs/guides/text-generation/chat-completions-api
    design_prompts_based_on(current_point_of_interest, recent_remarks, role_description)

    TextGeneratorService.call(@prompts)
  end

  def self.speak(text)
    raise ArgumentError, "text must be a String" unless text.is_a?(String) && text.present?
    AudioGeneratorService.call(text, voice)
  end

  private

  def self.design_prompts_based_on(current_point_of_interest, recent_remarks, role_description)
    @prompts << {
      role: "system",
      content: personality +
        [
          "For the duration of this conversation, pretend that " + role_description.tap { |s| s[0] = s[0].downcase }, # ie: "For the duration of this conversation, pretend that your are the host of a podcast."
          "The current topic of conversation is #{current_point_of_interest}.",
          "Keep your responses shorter than 30 words.",
          "Do not preface your responses with your name. Just return your response.",
          "Only give a single response as yourself. Do not continue the conversation as another speaker."
        ].join(" ")
    }

    if recent_remarks.any?
      # give the context of the past few remarks to help the speaker continue the conversation
      @prompts += recent_remarks.last(3).map do |remark|
        {
          role: ((remark.speaker == self) ? "assistant" : "user"), # assistant is this speaker of this remark, user is another speaker (for context)
          content: remark.content
        }
      end
    else # if there are no recent remarks, prompt the user to start the conversation
      @prompts << {
        role: "system",
        content: "Please begin the conversation by briefly introducing the topic of conversation and asking your guest a question about it."
      }
    end
  end
end
