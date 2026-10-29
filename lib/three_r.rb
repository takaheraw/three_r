# frozen_string_literal: true

require "date"

module ThreeR
  WDAYS = %w[日 月 火 水 木 金 土].freeze

  # GitHub Actions の schedule は数時間遅れて日付をまたぐことがあるため、
  # 正午より前の起動は当日、以降は翌日の収集を通知対象にする
  CUTOFF_HOUR = 12

  def self.target_date(now = Time.now) = now.hour < CUTOFF_HOUR ? now.to_date : now.to_date + 1
end

require_relative "three_r/config"
require_relative "three_r/schedule_entry"
require_relative "three_r/calendar_parser"
require_relative "three_r/schedule_store"
require_relative "three_r/notifier"
