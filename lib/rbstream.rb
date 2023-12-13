# frozen_string_literal: true

require "json"

# Ruby Stream
module Rbstream
  Track = Struct.new(:uri, :format, :metadata)

  # Simple playlist class
  class Playlist
    def initialize
      @playlist = []
      @index = 0
    end

    def list
      @playlist
    end

    def length
      @playlist.length
    end

    def current
      @playlist[@index]
    end

    def next
      @index = (@index + 1) % @playlist.length
      current
    end

    def prev
      @index = (@index - 1) % @playlist.length
      current
    end

    def shuffle
      @playlist.shuffle!
    end

    def push_track(track)
      @playlist.push(track)
    end

    def pop_track
      @playlist.shift
    end

    def remove_track_at(index)
      @playlist.delete_at(index)
    end

    def self.from_json(json)
      playlist_obj = JSON.parse(json)
      playlist = Playlist.new

      # Struct.new(:uri, :format, :metadata)
      tracks = playlist_obj["tracks"] || []
      tracks.map { |track| playlist.push_track(Track.new(track["uri"], track["format"], track["metadata"])) }

      playlist
    end

    def self.from_file(file_path)
      file = File.open(file_path)
      from_json(file.read)
    ensure
      file&.close
    end
  end
end
