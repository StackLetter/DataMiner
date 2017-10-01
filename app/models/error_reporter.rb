class ErrorReporter

  def self.report(report_level, error_object, title, **optional_messages)
    case report_level
      when :error
        $error_reporter.report_error error_object, title, **optional_messages
      else
        $error_reporter.report_warning error_object, title, **optional_messages
    end
  end

  def report_error(error, title, **optional_messages)

  end


  def report_warning(warning, title, **optional_messages)

  end

end