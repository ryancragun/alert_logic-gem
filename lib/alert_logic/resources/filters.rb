module AlertLogic
  # Resource Filters
  module Resource
    @filters = nil
    # Resource filters accessor
    def self.filters(filters = nil)
      defaults = {
        :ok                   =>  { 'status.status'     => 'ok'       },
        :online               =>  { 'status.status'     => 'ok'       },
        :offline              =>  { 'status.status'     => 'offline'  },
        :error                =>  { 'status.status'     => 'error'    },
        :windows              =>  { 'metadata.os_type'  => 'windows'  },
        :linux                =>  { 'metadata.os_type'  => 'unix'     },
        :unix                 =>  { 'metadata.os_type'  => 'unix'     },
        :appliance_assignment =>  { 'type'  => 'appliance_assignment' },
        :all      =>  {}
      }
      filters && @filters = filters
      @filters ||= defaults
    end
  end
end
