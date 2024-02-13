require "active_support/concern"

module Hearable
  extend ActiveSupport::Concern

  included do

    def generate_audio(words, format: :mp3, encoding: :base_64_encoded)
      raise ArgumentError, "words must be a String" unless words.is_a?(String) && words.present?
      raise ArgumentError, "format must be :mp3 " unless format.in?([:mp3])
      raise ArgumentError, "encoding must be :base_64_encoded" unless encoding.in?([:base_64_encoded])

      # do the thing

    end

  end

end