module AlertLogic
  # AlertLogic ProtectedHost built from a JSON API response.
  class ProtectedHost
    include Resource

    def appliance_policy_id=(policy_id)
      update_policy('appliance', policy_id)
    end

    def config_policy_id=(policy_id)
      update_policy('config', policy_id)
    end

    def appliance?(appliance)
      # sometimes appliance_assigned_to wont exist if the Protected Host isn't
      # already assigned to an appliance.
      if respond_to?(:appliance_assigned_to)
        appliance = find_appliance(appliance) if appliance.is_a?(String)
        appliance.id == appliance_assigned_to
      else
        false
      end
    end

    def assign_appliance(appliance)
      if appliance?(appliance)
        AlertLogic.logger.info 'Host is already assigned to that Appliance'
      else
        appliance = find_appliance(appliance) if appliance.is_a?(String)
        policy = AlertLogic::Policy \
          .find('type' => 'appliance_assignment') \
          .select { |pol| pol.appliances.any? { |ap| ap == appliance.id } } \
          .first
        self.appliance_policy_id = policy.id
      end
    end

    def reload!
      [:@appliance_assigned_to,
       :@appliance_connected_to,
       :@appliance_policy_id,
       :@config_policy_id
      ].each do |var|
        remove_instance_variable(var) if instance_variable_defined?(var)
      end
      super
    end

    private

    def find_appliance(name)
      msg = "Searching for an appliance with name: #{name}"
      AlertLogic.logger.info msg
      Appliance.find.select { |ap| ap.name == name }.first
    end

    def update_policy(policy_type, policy_id)
      payload = { 'protectedhost' =>
        { policy_type => { 'policy' => { 'id' => policy_id } } }
      }
      AlertLogic.api_client.edit('protectedhost', id, payload)
      AlertLogic.logger.debug res.body.inspect
      reload!
      AlertLogic.logger.info "#{policy_type} policy updated!"
    end
  end
end
