# frozen_string_literal: true

require "ffi"

# ruby ffi wrapper over libshout C library
module Shout
  extend FFI::Library
  ffi_lib "shout"
  ffi_convention :stdcall

  # Global functions
  attach_function :shout_init, [], :void
  attach_function :shout_shutdown, [], :void
  attach_function :_shout_version, :shout_version, %i[pointer pointer pointer], :string

  # Managing connections
  attach_function :shout_new, [], :pointer
  attach_function :shout_free, [:pointer], :void
  attach_function :shout_open, [:pointer], :int
  attach_function :shout_close, [:pointer], :int

  # Sending data
  attach_function :shout_send, %i[pointer pointer int], :int
  attach_function :shout_send_raw, %i[pointer pointer pointer], :int
  attach_function :shout_sync, [:pointer], :void
  attach_function :shout_delay, [:pointer], :int

  # Connection parameters
  attach_function :shout_set_host, %i[pointer string], :int
  attach_function :shout_get_host, %i[pointer], :string
  attach_function :shout_set_port, %i[pointer int], :int
  attach_function :shout_get_port, [:pointer], :int
  attach_function :shout_set_user, %i[pointer string], :int
  attach_function :shout_get_user, [:pointer], :string
  attach_function :shout_set_password, %i[pointer string], :int
  attach_function :shout_get_password, [:pointer], :string
  attach_function :shout_set_protocol, %i[pointer int], :int
  attach_function :shout_get_protocol, [:pointer], :int
  attach_function :shout_set_format, %i[pointer int], :int
  attach_function :shout_get_format, [:pointer], :int
  attach_function :shout_set_mount, %i[pointer string], :int
  attach_function :shout_get_mount, [:pointer], :string
  attach_function :shout_set_dumpfile, %i[pointer string], :int
  attach_function :shout_get_dumpfile, [:pointer], :string
  attach_function :shout_set_agent, %i[pointer string], :int
  attach_function :shout_get_agent, [:pointer], :string

  # Directory parameters
  attach_function :shout_set_public, %i[pointer int], :int
  attach_function :shout_get_public, [:pointer], :int
  attach_function :shout_set_name, %i[pointer string], :int
  attach_function :shout_get_name, [:pointer], :string
  attach_function :shout_set_url, %i[pointer string], :int
  attach_function :shout_get_url, [:pointer], :string
  attach_function :shout_set_genre, %i[pointer string], :int
  attach_function :shout_get_genre, [:pointer], :string
  attach_function :shout_set_description, %i[pointer string], :int
  attach_function :shout_get_description, [:pointer], :string
  attach_function :shout_set_audio_info, %i[pointer string string], :int
  attach_function :shout_get_audio_info, %i[pointer string], :string

  # Metadata
  attach_function :shout_metadata_new, [], :pointer
  attach_function :shout_metadata_free, [:pointer], :void
  attach_function :shout_metadata_add, %i[pointer string string], :int
  attach_function :shout_set_metadata, %i[pointer pointer], :int

  SHOUTERR_SUCCESS = 0
  SHOUT_PROTOCOL_HTTP = 0
  SHOUT_FORMAT_MP3 = 1

  # override shout_version, set NULL to return const char* libshout version string
  def self.shout_version
    _shout_version(nil, nil, nil)
  end

  # ShoutClient provides a simple API to play .mp3 files to icecast2
  class ShoutClient
    MAX_BUFFER_SIZE = 4096

    def initialize(user, password, host, port, mount) # rubocop:disable Metrics/MethodLength
      Shout.shout_init

      puts "loaded Shout v#{Shout.shout_version}"

      @t_shout = Shout.shout_new

      Shout.shout_set_host(@t_shout, host)
      Shout.shout_set_protocol(@t_shout, Shout::SHOUT_PROTOCOL_HTTP)
      Shout.shout_set_port(@t_shout, port)
      Shout.shout_set_user(@t_shout, user)
      Shout.shout_set_password(@t_shout, password)
      Shout.shout_set_mount(@t_shout, mount)
      Shout.shout_set_format(@t_shout, Shout::SHOUT_FORMAT_MP3)

      open_result = Shout.shout_open(@t_shout)

      return unless open_result != Shout::SHOUTERR_SUCCESS

      raise StandardError,
            "Failed to connect to server: http://#{user}:#{password}@#{host}:#{port}, code: #{open_result}"
    end

    def play(file_path) # rubocop:disable Metrics/MethodLength
      puts "playing #{file_path}"

      file = File.open(file_path)

      # stream file to icecast2
      until file.eof?
        file_data = file.read(MAX_BUFFER_SIZE)
        @buffer = FFI::MemoryPointer.from_string(file_data)
        Shout.shout_sync(@t_shout)
        send_result = Shout.shout_send(@t_shout, @buffer, MAX_BUFFER_SIZE)
        raise StandardError, "Failed to play file #{file_path}, code: #{send_result}" if send_result != SHOUTERR_SUCCESS

        Shout.shout_delay(@t_shout)
      end
    ensure
      file.close
    end

    def begin(&block)
      instance_eval(&block)
    ensure
      puts "shutting down..."
      @buffer.free
      Shout.shout_free(@t_shout)
      Shout.shout_close(@t_shout)
      Shout.shout_shutdown
    end
  end
end
