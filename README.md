# rbstream
A proof of concept icecast2 source client in ruby using libshout

## Getting Started
### Requirements
- docker ~>24.0.7

### Setup
1. run `docker compose up`
2. go to http://localhost:8000/stream in the browser or optionally VLC player

### Usage
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
