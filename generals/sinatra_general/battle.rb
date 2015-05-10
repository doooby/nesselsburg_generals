
class SinatraGeneral::Battle

  def initialize(id)
    @instance_id = id
  end

  def self.instace(id)
    instances[id] || raise("Instance #{id} of #{to_s} doesn't exist")
  end

  def event(name, data)
    case name
      when 'start'
        self.class.instances[@instance_id] = self
      when 'win', 'lost', 'draw', 'end'
        self.class.instances[@instance_id] = nil
    end
    send "on_#{name}", data if respond_to? "on_#{name}"
  rescue => e
    {event_fail: {message: e.message, backtrace: e.backtrace}}
  end

  private

  def self.instances
    @instances ||= {}
  end

end