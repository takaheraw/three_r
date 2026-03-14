# frozen_string_literal: true

require "json"
require "fileutils"

module ThreeR
  module ScheduleStore
    OUT_DIR = File.expand_path("../../out", __dir__)

    module_function

    def save(year, month, entries)
      FileUtils.mkdir_p(OUT_DIR)

      serialized = entries.to_h { |e| [e.date_key, e.kinds] }
      File.write(path_for(year, month, "json"), JSON.pretty_generate(serialized))
      File.write(path_for(year, month, "md"), to_markdown(year, month, entries))
    end

    def load(year, month)
      path = path_for(year, month, "json")
      return nil unless File.exist?(path)

      JSON.parse(File.read(path)).map { |date_str, kinds|
        ScheduleEntry.new(date: Date.parse(date_str), kinds:)
      }
    end

    def exists?(year, month) = File.exist?(path_for(year, month, "json"))

    def path_for(year, month, ext) = File.join(OUT_DIR, format("%04d_%02d.%s", year, month, ext))

    def to_markdown(year, month, entries)
      ["# #{year}年#{month}月 ゴミ収集カレンダー", "",
       *entries.sort_by(&:date).map(&:to_markdown)].join("\n") << "\n"
    end
  end
end
