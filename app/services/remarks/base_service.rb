class Remarks::BaseService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def initialize
    @client = OpenAI::Client.new
  end
end
