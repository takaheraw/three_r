# frozen_string_literal: true

require "net/http"
require "nokogiri"

module ThreeR
  module CalendarParser
    BASE_URL = "https://manage.delight-system.com/threeR/web/calendar"

    module_function

    def fetch(area_id:, year:, month:)
      uri          = URI(BASE_URL)
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(
        "menu"       => "calendar",
        "jichitaiId" => "setagayaku",
        "areaId"     => area_id,
        "areaName"   => "x",
        "year"       => format("%04d", year),
        "month"      => format("%02d", month),
        "lang"       => "ja"
      )

      parse(http.request(req).body, year, month)
    end

    def parse(html, year, month)
      Nokogiri::HTML(html).css("table.calendar td.td").filter_map { |td|
        day = td.at_css("p.day span")&.text&.strip&.to_i
        next unless day&.positive?

        kinds = td.css("span.trash_kind_name").filter_map { |s|
          s.text.strip.then { _1 unless _1.include?("ありません") }
        }
        next if kinds.empty?

        ScheduleEntry.new(
          date: Date.new(year, month, day),
          kinds:
        )
      }
    end
  end
end
