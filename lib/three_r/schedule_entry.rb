# frozen_string_literal: true

require "date"

module ThreeR
  ScheduleEntry = Data.define(:date, :kinds) do
    EMOJI_MAP = {
      "可燃ごみ"     => "🔥",
      "不燃ごみ"     => "🪨",
      "資源"         => "♻️",
      "ペットボトル" => "🧴"
    }.freeze

    def formatted_date = "#{date.month}/#{date.day}(#{WDAYS[date.wday]})"

    def kinds_with_emoji = kinds.map { "#{EMOJI_MAP.fetch(_1, "📦")} #{_1}" }

    def kinds_text(sep = "、") = kinds.join(sep)

    def date_key = date.to_s

    def to_markdown = "- **#{formatted_date}** #{kinds.join(", ")}"
  end
end
