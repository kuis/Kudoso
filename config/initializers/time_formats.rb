Time::DATE_FORMATS[:pretty_date] = lambda { |time| day_format = ActiveSupport::Inflector.ordinalize(time.day); time.strftime("%B #{day_format}, %Y") }