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

  # override shout_version, set NULL to return const char* libshout version string
  def self.shout_version
    _shout_version(nil, nil, nil)
  end
end
