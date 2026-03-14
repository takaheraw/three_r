# frozen_string_literal: true

module ThreeR
  module Config
    ENV_KEYS = %i[area_id gmail_user gmail_password notify_to].freeze

    ENV_KEYS.each do |key|
      define_method(key) { ENV.fetch(key.to_s.upcase) }
    end

    module_function(*ENV_KEYS)
  end
end
