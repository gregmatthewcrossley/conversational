OpenAI.configure do |config|
  # Pre-authenticate into the OpenAI API at startup
  config.access_token = Rails.application.credentials.dig(:open_ai, :api_token)
end