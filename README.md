#Chatter Server
This is the small script for the TChatter application.
It's provided as a base for anyone who wants to implement the t_chatter application.

One thing you would almost immediately notice is:

```ruby
  class Chatter

  end
```

This enables you to customize the logic that would be used in your own application and the returned JSON

I've tried to keep it compact a bit therefore feel free to play around anyhow you like.

To start the server, just run

```bash
  rackup
```

OR

```bash
  rackup -p [WHATEVER_PORT_YOU_WANT_TO_USE]
```

With this you would be up to receive and send messages on your own t_chatter server.

After this, run

```bash
  setup_t_chatter
```

and provide your URL in the form of `http://192.168.1.1` for the url you want to use.

```
  Please note: Even though you may be tempted to use localhost in your setup_t_chatter, this is not the best approach as others would not be able to connect with you.
  You may get your public IP address and share with the people you want to chat with or
  Use my preferred option: ngrok.
```
  After installing ngrok, run:

```bash
  ngrok http [PORT]
```

ngrok will setup your localhost for remote connection and provide you 2 urls.
You may use the either of the 2. However, it's best to use the unsecured(`http` not `https`) URL for now, as the connection will fail if you don't have a valid security certificate.
You can overide this method though by extending the

```ruby
  class TChatter::Chat
    def connect
      @connection = Faraday::Connection.new @url, ssl: false
    end
  end
```

OR

```ruby
  class TChatter::Chat
    def connect
      @connection = Faraday::Connection.new @url, ssl: {verify: false}
    end
  end
```

Here's to a happy chat!!!!!
