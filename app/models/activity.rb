require "#{::Rails.root}/lib/kudoso_auth"



class Activity < ActiveRecord::Base

  class TodosIncomplete < StandardError; end
  class AlreadyStarted < StandardError; end
  class ScreenTimeExceeded < StandardError; end
  class DeviceScreenTimeExceeded < StandardError; end
  class ScreenTimeRestricted < StandardError; end
  class DeviceInUse < StandardError; end

  belongs_to :member                            # Family member who PERFORMED the activity, may be nil
  belongs_to :created_by, class_name: 'Member', foreign_key: 'created_by_id'  # Family member who CREATED the activity, required, allows tracking of anonymous access
  has_many :activity_devices, dependent: :destroy
  has_many :devices, through: :activity_devices
  has_one :family, through: :created_by
  belongs_to :activity_template
  has_many :details, class_name: 'ActivityDetail'

  validates_presence_of :created_by, :activity_template

  def as_json(options = nil)
    options ||= { include: [
                    devices: { include: [
                        { device_type: {
                            except: [:icon_file_name, :icon_content_type, :icon_file_size, :icon_updated_at],
                            methods: [ :icon_url ]
                          }
                        }
                    ] }
                  ]
                }
    super(options)
  end

  def anonymous?
    member.blank?
  end

  def start!
    member.can_do_activity?(self.activity_template, self.devices)
    check_screen_time

    if self.start_time.blank?
      transaction do
        self.start_time = Time.now.localtime
        self.allowed_time = self.member.available_screen_time(self.start_time.to_date, self.devices.to_a )
        self.save
        update_devices = []
        self.devices.each do |device|
          device.update_attribute(:current_activity_id, self.id)
          if device.managed && device.mac_address
              update_devices << device.to_router_update
          end
        end
        if update_devices.length > 0
          member.family.routers.each do |router|
            msg = "send|#{router.mac_address}|update|#{update_devices.to_json}"
            logger.debug "Sending to router #{router.id}(#{router.mac_address}) : #{msg}"
            KudosoAuth.send_to_router(msg)
          end
        end
        unless self.activity_template.id == 1 # screen time is always ID 1 and cost is deducted with buying a screen time override
          cost = member.family.get_cost(self.activity_template)

        end
      end
      return self
    else
      #raise error
      raise Activity::AlreadyStarted
    end

  end

  def stop!
    if self.end_time.blank?
      transaction do
        self.update_attribute(:end_time, Time.now.localtime)
        update_devices = []
        self.devices.each do |device|
          device.update_attribute(:current_activity_id, nil)
          if device.managed && device.mac_address
            update_devices << device.to_router_update
          end
        end

        if update_devices.length > 0
          member.family.routers.each do |router|
            msg = "send|#{router.mac_address}|update|#{update_devices.to_json}"
            logger.debug "Sending to router #{router.id}(#{router.mac_address}) : #{msg}"
            KudosoAuth.send_to_router(msg)
          end
        end
        # TODO: calc cost/reward and assign
      end
    else
      #raise error
      raise 'Activity was ended previously, cannot end again!'
    end
    self
  end

  def duration
    endtime = self.end_time || Time.now.localtime
    (endtime - self.start_time).ceil
  end


  private

  def check_screen_time
    if member.available_screen_time <= 0
      raise Activity::ScreenTimeExceeded
    end
    self.devices.each do |device|
      device_time = member.screen_time(Time.now.localtime, device)
      device_used_time = member.used_screen_time(Time.now.localtime, device)
      if device_time == 0 || device_used_time >= device_time
        raise Activity::DeviceScreenTimeExceeded
      end
    end

    if errors.count > 0
      return false
    else
      return true
    end
  end

end
