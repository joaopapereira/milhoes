class FeedError < StandardError
  attr_accessor :failed_action
  attr_accessor :msg
  def initialize new_message
    @failed_action = Feed
    @msg = new_message
  end
end

class FeedAlreadyExistsError < FeedError
  def initialize
    super("A Feed na base da dados é a mais recente!")
  end
end

class FeedHasNoPrizeError < FeedError
  def initialize
    super("Feed nao completa, falta o premio!")
  end
end

class NoFeedFoundError < FeedError
  def initialize
    super("Nao encontrou feed!")
  end
end