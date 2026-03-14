# frozen_string_literal: true

require "mail"

module ThreeR
  module Notifier
    module_function

    def configure!
      Mail.defaults do
        delivery_method :smtp,
          address:              "smtp.gmail.com",
          port:                 587,
          user_name:            Config.gmail_user,
          password:             Config.gmail_password,
          authentication:       :plain,
          enable_starttls_auto: true
      end
    end

    def send_notification(entry)
      sender    = Config.gmail_user
      recipient = Config.notify_to
      subj      = "🗑️ #{entry.formatted_date} #{entry.kinds_text}"
      msg_body  = build_body(entry)

      Mail.deliver do
        content_type "text/plain; charset=UTF-8"
        from    sender
        to      recipient
        subject subj
        body    msg_body
      end
    end

    def build_body(entry)
      <<~BODY
        📅 #{entry.formatted_date}

        #{entry.kinds_with_emoji.map { "  #{_1}" }.join("\n")}

        ──────────────
        ゴミ収集通知 by three_r
      BODY
    end
  end
end
