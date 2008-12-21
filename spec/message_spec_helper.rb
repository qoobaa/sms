module MessageSpecHelper
  def valid_message_attributes
    gateway = stub_model(Gateway)
    user = stub_model(User)
    { :recipients => "         + 4 5 6   0  1   3  3  2 1 1         ,         ,  Alice     ,Bob,+12313 232112,,",
      :content => "Test message",
      :gateway => gateway,
      :user => user }
  end

  def valid_message_draft_attributes
    { :to => "Blah blah blah..." }
  end

  # returns new message with given attributes bypassing attr_accessible
  def new_message(attributes = { })
    message = Message.new(attributes)
    message.user = attributes[:user]
    message.gateway = attributes[:gateway]
    message
  end

  def new_valid_message(attributes = { })
    new_message(valid_message_attributes.merge(attributes))
  end

  def new_message_draft(attributes = { })
    message = Message.new(attributes)
    message.user = attributes[:user]
    message.gateway = attributes[:gateway]
    message
  end

  def new_valid_message_draft(attributes = { })
    new_message(valid_message_draft_attributes.merge(attributes))
  end

  # builds and returns new message with valid attributes
  def build_valid_message(attributes = { })
    message = new_message(valid_message_attributes.merge(attributes))
    message.save!
    message
  end
end
