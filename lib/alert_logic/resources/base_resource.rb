module AlertLogic
  # Common methods that we'll mix into our resource classes
  module Resource
    include Utils

    def self.included(klass)
      klass.extend Resource
    end

    def find_by_id(id)
      resource_type = name.split('::').last
      klass         = AlertLogic.const_get(resource_type.to_sym)
      resource      = AlertLogic \
                        .api_client \
                        .retrieve(resource_type.downcase, id) \
                        .body \
                        .first
      klass.new(resource)
    end

    def find(*params)
      resource_type = name.split('::').last
      options       = params.empty? ? {} : eval_filters(params)
      klass         = AlertLogic.const_get(resource_type.to_sym)
      resources     = AlertLogic \
                        .api_client \
                        .list(resource_type.downcase, options) \
                        .body
      resources.map! { |resource_hash| klass.new(resource_hash) }
    end

    def initialize(resource_hash)
      @resource_type = self.class.to_s.downcase.split('::').last
      objectify(resource_hash)
    end

    def name=(name)
      payload = { @resource_type => { 'name' => name } }
      AlertLogic.api_client.edit(@resource_type, id, payload)
      reload!
    end

    def tags=(tags)
      msg = 'Tags must be a space separated string'
      fail ClientError, msg unless tags.is_a?(String)
      tags = tags.split.map! { |tag| { 'name' => tag } }
      payload = { @resource_type => { 'tags' => tags } }
      AlertLogic.api_client.edit(@resource_type, id, payload)
      reload!
    end

    def reload!
      objectify(
        AlertLogic \
          .api_client \
          .list(@resource_type, 'id' => id) \
          .body \
          .first
      )
    end

    private

    def eval_filters(params)
      filters = Resource.filters
      unknown_filters = []
      params = params.map do |param|
        if param.is_a?(Symbol)
          if filters.key?(param)
            filters[param]
          else
            unknown_filters << param
            {}
          end
        elsif param.is_a?(Hash)
          param
        else
          {}
        end
      end.reduce(&:merge)
      msg = "Unknown filter(s) passed: #{unknown_filters.inspect}."
      msg << " Valid filters: #{filters.keys.inspect}"
      AlertLogic.logger.warn(msg) unless unknown_filters.empty?
      params
    end

    # Recursively traverse the hash and create an instance variable and
    # accessor method for each key/value pair.
    def objectify(hash)
      hash.each do |name, value|
        if value.is_a?(Hash)
          value = uniquify_keys(name, value)
          objectify(value)
        else
          def_method(name, value)
        end
      end
    end

    # Some hash pairs have similar namespaces.  We want to rename those to
    # avoid a naming collision.
    def uniquify_keys(name, hash)
      conflicts = /^config$|^appliance$|^created$|
                  ^modified$|^config_policy$|^appliance_policy$/
      return hash unless name =~ conflicts
      hash.map { |k, v| { "#{name}_#{k}" => v } }.reduce(&:merge)
    end

    # create and set an instance variable and define an accessor method if it's
    # not already there.
    def def_method(name, value)
      instance_variable_set("@#{name}", value)
      # Don't overwrite existing methods unless it's id.  id isnt fully
      # deprecatedin 1.8.7
      (return true) if respond_to?(name.to_sym) && name != 'id'
      self.class.send(
        :define_method,
        name,
        proc { instance_variable_get("@#{name}") }
      )
    end
  end
end
