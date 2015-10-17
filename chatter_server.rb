get '/receive' do
  last = params[:last_message_id].to_i
  Chatter.receive_message(last)
end

post '/send' do
  message = params[:message]
  user = params[:user]
  Chatter.post_message(message, user)
end

class Chatter
  @@messages = []

  def self.post_message(message, user)
    @@messages << {message: message, user: user}
    {last_message_id: @@messages.size, response: "Message sent", time: Time.now}.to_json
  end

  def self.form_message(message_hash)
    message = message_hash[:message]
    user = message_hash[:user]
    "#{user} >> #{message}"
  end

  def self.receive_message(last_message_id)
    total_messages =  @@messages.size
    messages = @@messages[last_message_id..-1] || []
    message_concat = ""
    messages.each{ |msg|
      message_concat << form_message(msg)
      message_concat << "\n"
    }
    return {message: message_concat, last_message_id: total_messages, time: Time.now }.to_json if last_message_id <= total_messages
    {message: "No new message", time: Time.now }.to_json
  end

  def self.get_messages
    @@messages
  end
end
