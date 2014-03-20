module AlertLogic
  # common utility methods that are required in multiple classes
  module Utils
    private

    # simple string pluralizer to translate singular Alert Logic resources
    def pluralize(resource)
      resource =~ /^\w+y$/ ? resource.sub(/y$/, 'ies') : "#{resource}s"
    end
  end
end
