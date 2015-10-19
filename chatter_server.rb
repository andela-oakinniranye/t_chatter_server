get '/receive' do
  last = params[:last_message_id].to_i
  last_message_id = Chatter.get_messages.size
  return Chatter.receive_message(last) if last < last_message_id
  {last_message_id: last_message_id, time: Time.now }.to_json
end

post '/send' do
  message = params[:message]
  user = params[:user]
  Chatter.post_message(message, user)
end

post '/new_user' do
  user = params[:user]
  user_id = params[:user_id].to_s
  Chatter.subscribe_new_user(user_id, user)
end

get '/quit' do
  user_id = params[:user_id]
  Chatter.exit_user(user_id)
end

get '/all_users' do
  Chatter.all_users
end

class Chatter
  @@users = Hash.new(nil)
  @@messages = []

  def self.subscribe_new_user(user_id, user)
    unless @@users.keys.include? user_id
      @@users[user_id] = {name: user, joined: Time.now}
      message = "#{user} joined the chatroom"
      @@messages << {message: message, user: :server }
      {message: message , time: Time.now, total_users: @@users.size }.to_json
    end
  end

  def self.post_message(message, user)
    @@messages << {message: message, user: user}
    {last_message_id: @@messages.size, response: "Message sent", time: Time.now, total_users: @@users.size}.to_json
  end

  def self.form_message(message_hash)
    message = message_hash[:message]
    user = message_hash[:user]
    unless user == :server
      "#{user}: #{message}"
    else
      message
    end
  end

  def self.receive_message(last_message_id)
    total_messages =  @@messages.size
    messages = @@messages[last_message_id..-1] || []
    message_concat = ""
    messages.each{ |msg|
      message_concat << form_message(msg)
      message_concat << "\n"
    }
    return {message: message_concat, last_message_id: total_messages, time: Time.now, total_users: @@users.size }.to_json if last_message_id <= total_messages
    {message: "No new message", time: Time.now, total_users: @@users.size }.to_json
  end

  def self.get_messages
    @@messages
  end

  def self.all_users
    {users: @@users.map{|x, y| y } }.to_json
  end

  def self.exit_user(user_id)
    if @@users.keys.include? user_id
      user = @@users[user_id][:name]
      message = "#{user} exited the chatroom"
      @@messages << {message: message, user: :server }
      @@users.delete(user_id)
    end
  end

end
