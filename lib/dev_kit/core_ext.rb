# frozen_string_literal: true

class Date
  include DevKit::Time::CommonExtension
end

class DateTime
  include DevKit::Time::CommonExtension
end

module Rails
  class Application
    def settings(source = :config)
      case source
      when :config
        Settings
      when :secret
        Rails.application.credentials
      else
        Settings
      end
    end
  end
end
