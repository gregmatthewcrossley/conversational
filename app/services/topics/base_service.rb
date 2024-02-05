class Topics::BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def initialize
    # @client = GooglePlaces::Client.new
  end
end
