OpenAI.configure do |config|
  # Set the API token for all newly created client instances
  config.access_token = Rails.application.credentials.dig(:open_ai, :api_token)
end