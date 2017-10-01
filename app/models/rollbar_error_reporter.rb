class RollbarErrorReporter < ErrorReporter

  def report_error(error, title, **optional_messages)
    Rollbar.error(error, title, optional_messages)
  end

  def report_warning(warning, title, **optional_messages)
    Rollbar.warning(warning, title, optional_messages)
  end


end