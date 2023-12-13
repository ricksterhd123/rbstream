# rbstream
A proof of concept icecast2 source client in ruby using libshout

## Features
- libshout ruby ffi binding
- ShoutClient library
- rbstream CLI

## Getting Started
### Requirements
- docker ~>24.0.7

### Setup
1. run `docker compose up`
2. go to http://localhost:8000/stream in the browser or optionally VLC player

### Shout::ShoutClient usage
Plays a simple .mp3 file over and over again

```rb
client = Shout::ShoutClient.new("source", "hackme!", "icecast2.example.com", 8000, "/stream")
client.begin do
  loop do
    play("examples/laugh.mp3")
    sleep 0.25
  end
end
```

### rbstream usage

```
Usage: rbstream
        An icecast2 source client
Parameters:
        --username USERNAME          Username to icecast2 server source
        --password PASSWORD          Password to icecast2 server source
        --hostname HOSTNAME          URI of icecast2 server, defaults to localhost
        --port PORT                  Port of icecast2 server, defaults to 8000
        --mount MOUNT                mount point of icecast2 server, e.g. /stream
        --playlist FILE              the playlist file to read from
```

#### Setup playlist
```json
{
  "tracks": [
    {
      "uri": "file://laugh.mp3",
      "format": "mp3",
      "metadata": {}
    },
    {
      "uri": "file://cry.mp3",
      "format": "mp3",
      "metadata": {}
    }
  ]
}

```
