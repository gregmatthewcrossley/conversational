class Programs::Podcast < Programs::Base
  SPEAKERS_AND_ROLES = { # AKA Dramatis Personae

    Speakers::Fable => [ # The host of the podcast
      "You are the host of a podcast.",
      "You are responsible for introducing the topic of this podcast episode and interviewing Onyx, an expert on the topic of the podcast."
    ].join(" "),
    Speakers::Onyx => [
      "You are the guest of a podcast.",
      "The host's name is Fable, who will be interviewing you about your expertise in the topic of this podcast episode."
    ].join(" ")
  }
end
