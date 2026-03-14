# frozen_string_literal: true

module ThreeR
  WDAYS = %w[日 月 火 水 木 金 土].freeze
end

require_relative "three_r/config"
require_relative "three_r/schedule_entry"
require_relative "three_r/calendar_parser"
require_relative "three_r/schedule_store"
require_relative "three_r/notifier"
