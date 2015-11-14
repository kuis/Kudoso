class Member < ActiveRecord::Base

  class NotEnoughKudos < StandardError; end

  belongs_to :family
  has_one :user, dependent: :nullify
  has_many :todo_schedules, dependent: :destroy
  has_many :todo_templates, through: :todo_schedules
  has_many :my_todos, dependent: :destroy
  has_many :primary_devices, class_name: 'Device', foreign_key: 'primary_member_id', dependent: :nullify
  has_many :activities, dependent: :destroy, inverse_of: :member
  has_many :authorized_activities, class_name: 'Activity', foreign_key: :created_by_id, dependent: :nullify, inverse_of: :created_by
  has_many :screen_times, dependent: :destroy
  has_many :st_overrides, dependent: :destroy
  has_one :screen_time_schedule, dependent: :destroy
  belongs_to :theme
  has_many :api_keys, dependent: :destroy
  has_many :app_members, dependent: :destroy
  has_many :apps, through: :app_members
  has_many :applogs, dependent: :nullify
  has_many :ledger_entries, dependent: :destroy



  has_attached_file :avatar, :styles => { :large => "300x300#", :medium => "200x200#", :small => "100x100#", :thumb => "60x60#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_inclusion_of :gender, :in => %w( m f ), allow_blank: :true
  validates_inclusion_of :mobicip_filter, :in => %w( Monitor Strict Moderate Mature ), allow_blank: :true

  before_save do
    self.username = self.username.downcase
  end

  # ensure we have a secure password even if the user has no password
  before_save :secure_password
  before_create :secure_password
  before_create do
      self.first_name = self.first_name.slice(0,1).capitalize + self.first_name.slice(1..-1) if self.first_name
      self.last_name = self.last_name.slice(0,1).capitalize + self.last_name.slice(1..-1) if self.last_name
      self.email = self.email.downcase if self.email
  end

  after_create do
    unless self.avatar.exists?
      suggested_avatar = Avatar.where(gender: self.gender).all.sample  if self.gender.present?
      suggested_avatar ||= Avatar.all.sample
      unless suggested_avatar.nil?
        self.avatar = suggested_avatar.image
        self.theme_id = suggested_avatar.theme_id
      end
    end

    self.theme_id ||= Theme.first.try(:id)
    self.save
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :registerable, :recoverable, :validatable, :confirmable, :lockable,
  devise :database_authenticatable, :authentication_keys => [:username, :family_id]
  devise :rememberable, :trackable, :timeoutable

  validates_presence_of :username, :family

  validates :username, uniqueness: { scope: :family_id }

  after_create do
    (0..6).each do |dow|
      self.set_screen_time!(dow, family.default_screen_time, (family.default_screen_time * 1.5).floor)
    end
  end


  def as_json(options = nil)
    options ||= {methods: [ :age, :avatar_urls, :screen_time, :used_screen_time, :max_screen_time], except: [:avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at], include: [ {theme: {except: [:created_at, :updated_at] } }]}
    super(options)
  end


  # override to scope username into family_id
  def self.find_for_authentication(warden_conditions)
    where(:username => warden_conditions[:username], :family_id => warden_conditions[:family_id]).first
  end

  def age
    if self.birth_date.present?
      now = Time.now.utc.to_date
      now.year - self.birth_date.year - (self.birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
    else
      return -1
    end

  end

  def avatar_urls
    urls = Hash.new
    if self.avatar.exists?
      urls[:large] = self.avatar.url(:large)
      urls[:medium] = self.avatar.url(:medium)
      urls[:small] = self.avatar.url(:small)
      urls[:thumb] = self.avatar.url(:thumb)
    end
    return urls
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def details
    self.my_todos.where('due_date >= ?', 1.month.ago).order(:due_date).reverse_order.group_by(&:due_date)
  end

  def todos(start_date = Date.today, end_date = Date.today)
    todos = []
    (start_date .. end_date).each do |date|
      local_todos = self.my_todos.includes(:todo).where("due_date >= ? AND due_date <= ?", date.beginning_of_day, date.end_of_day).map.to_a
      logger.info "Local todos count: #{local_todos.count}"
      self.todo_schedules.includes(:schedule_rrules).where('start_date <= ? AND (end_date IS NULL OR end_date >= ?)', start_date.beginning_of_day, end_date.end_of_day).find_each do |ts|
        todo = local_todos.find{ |td| td.todo_schedule_id == ts.id }
        if todo.nil?
          schedule = IceCube::Schedule.new
          schedule.start_time = ts.start_date
          ts.schedule_rrules.each do |rule|
            schedule.add_recurrence_rule(IceCube::Rule.from_yaml(rule.rrule))
          end
          local_todos << self.my_todos.create(todo_schedule_id: ts.id, due_date: date ) if schedule.occurs_on?(date)
        end
      end
      todos.concat(local_todos)
    end
    todos
  end

  def todos_complete?(start_date = Date.today, end_date = Date.today)
    ret = true
    todos(start_date, end_date).each do |my_todo|
      ret = false if my_todo.todo.required? && !my_todo.complete?
    end
    ret
  end


  def screen_time_overrides(date = Date.today)
    st_overrides.where(date: date.beginning_of_day..date.end_of_day).sum(:time)
  end



  def used_screen_time(date = Date.today, devices = nil, activity_id=nil)
    if devices.present?
      device_limits = []
      case devices.class.to_s
        when "Array"
          devices.each do |device|
            device_limits << activities.joins(:activity_devices).where('activities_devices.device_id = ? AND activities.end_time BETWEEN ? AND ?', device.id, date.beginning_of_day, date.end_of_day).sum('extract(epoch from activities.end_time - activities.start_time)').ceil
          end
        when "Device"
          device_limits << activities.joins(:activity_devices).where('activities_devices.device_id = ? AND activities.end_time BETWEEN ? AND ?', devices.id, date.beginning_of_day, date.end_of_day).sum('extract(epoch from activities.end_time - activities.start_time)').ceil
      end
      device_limits.max
    elsif activity_id.present?
      activities.where('activity_id = ? AND end_time BETWEEN ? AND ?', activity_id, date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    else
      activities.where('end_time BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    end
  end

  def screen_time(date = Date.today, devices = nil, activity_id = nil)
    get_limit(:default_time, date, devices, activity_id) + screen_time_overrides(date)
  end

  def max_screen_time(date = Date.today, devices = nil, activity_id = nil)
    get_limit(:max_time, date, devices, activity_id)
  end

  def available_screen_time(date = Date.today, devices = nil, activity_id = nil)
    if devices.is_a?(Array)
      devices = nil if devices.length == 0
    end
    (screen_time(date, devices, activity_id) - used_screen_time(date, devices, activity_id)).to_i
  end


  def set_screen_time!(dow, default_time, max_time, device_id = nil, activity_id = nil)
    raise 'Must set a valid Day of Week (0=Sunday .. 6=Staturday)' if dow.nil? || !(0..6).include?(dow)
    my_time = screen_times.find_or_initialize_by(dow: dow)
    if device_id.nil? && activity_id.nil?
      my_time.max_time = max_time
      my_time.default_time = default_time
    else
      my_time.max_time ||= max_time
      my_time.default_time ||= default_time
      my_time.restrictions[:devices][device_id] = { default_time: default_time, max_time: max_time} if device_id
      my_time.restrictions[:activities][:activity_id] = { default_time: default_time, max_time: max_time} if activity_id
    end


    my_time.save
  end

  def new_activity(activity_template, devices = nil)
    # TODO: Check cost of activity before creating
    act = self.activities.create(activity_template_id: activity_template.id, created_by_id: self.id)
    if devices

      devices = devices.to_a  if devices.is_a?(Device::ActiveRecord_Relation)

      case devices.class.to_s
        when "Array"
          devices.each do |device|
             act.devices << device
          end

        when "Device"
          act.devices << devices
      end
    end
    act
  end

  def current_activity
    activities.where(end_time: nil).last
  end

  def can_do_activity?(activity_template, devices = nil)
    # Check if activity is restricted
    if activity_template.restricted?
      unless todos_complete?
        raise Activity::TodosIncomplete, "Required todos are not yet complete"
      end
      unless !available_screen_time
        if available_screen_time <= 0
          raise Activity::ScreenTimeExceeded, "Available screen time exceeded"
        end
      end
    end

    # Member has enough screen time, but does the schedule restrict it?
    # Check family wide restrictions

    if self.family.screen_time_schedule.try(:occurring_at?, Time.now)
      ret = false
      raise Activity::ScreenTimeRestricted, "Screen time family schedule currently restricted"
    end
    # Check member specific restrictions
    if self.screen_time_schedule.try(:occurring_at?, Time.now)
      ret = false
      raise Activity::ScreenTimeRestricted, "Screen time member schedule currently restricted"
    end

    #check if devices are available
    if ret
      case devices.class
        when Array
          devices.each do |device|
            unless device.current_activity.nil?
              raise Activity::DeviceInUse, "#{device.name} (#{device.id}) Already in use"
            end
          end
        when Device
          unless devices.current_activity.nil?
            raise Activity::DeviceInUse, "#{devices.name} (#{devices.id}) Already in use"
          end
      end
    end
    #check if member has enough kudos
    if activity_template.id != 1 && activity_template.cost > 0 && self.kudos < activity_template.cost
      raise Member::NotEnoughKudos, "Activity requires #{activity_template.cost} kudos"
    end
    ret
  end

  def get_api_key
    key = self.api_keys.last
    if key.nil? or key.expires_at < DateTime.now()
      key = self.api_keys.create
    else
      key.update_expiration!
    end
    key
  end

  def create_mobicip_profile
    return true if self.mobicip_profile.present?
    return false if self.family.mobicip_id.blank?
    mobicip = Mobicip.new
    result = mobicip.login(self.family)
    result = mobicip.createProfile(self, filter_level_id) if result
    return result && self.mobicip_profile.present?
  end

  def filter_level_id

    # # The default settings for this filter level are: 4) Monitor, 5) Strict, 6) Moderate, 7) Mature
    case self.mobicip_filter.downcase
      when "monitor"
        return 4
      when "strict"
        return 5
      when "moderate"
        return 6
      when "mature"
        return 7
      else
        return 4
    end
  end

  # if time is NIL try to buy maximium available time
  def buy_screen_time(time=nil)
    activity_template = ActivityTemplate.first #screen time is always id 1
    max_time = self.max_screen_time - self.available_screen_time
    time ||= max_time
    if time <= 0
      raise ScreenTime::ScreenTimeExceeded, "Maximum screen time for day already exceeded"
    end
    cost = family.get_cost(activity_template, time)
    if cost > kudos
      raise Member::NotEnoughKudos, "Not enough kudos, #{cost} required"
    end
    self.debit_kudos(cost, "Bought #{time} seconds of screen time.")
    self.st_overrides.create(created_by_id: self.id, time: time,date: Time.now, comment: "Member bought screen time with #{cost} kudos for (#{activity_template.id}): #{activity_template.name}")
  end

  def debit_kudos(cost, description)
    self.update_attribute(:kudos, self.kudos - cost)
    self.ledger_entries.create(debit: cost, description: description)
  end

  def credit_kudos(cost, description)
    self.update_attribute(:kudos, self.kudos + cost)
    self.ledger_entries.create(credit: cost, description: description)
  end


  protected




  def secure_password
    unless self.password.nil? || self.password_confirmation.nil?
      if self.password == self.password_confirmation
        self.password = self.password_confirmation = Digest::MD5.hexdigest(self.password + self.family.secure_key).to_s
      end
    end
  end

  def get_limit(limit, date , devices, activity_id)
    rec = screen_times.where(dow: date.wday).last
    result = nil
    if devices.nil? && activity_id.nil?
      result = rec.try(limit) || 60*60*24 # Return unlimited if not set

    else
      if rec.nil?
        result = 60*60*24
      else
        device_limit = nil
        if devices.nil?
          result = ( rec.restrictions[:activities].try(:[], activity_id).try(:[], limit) || rec.try(limit) || 60*60*24 )
        else
          if devices
            device_limits = []
            case devices.class.to_s
              when "Array"
                devices.each do |device|
                  device_limits << (rec.restrictions[:devices].try(:[], device.id).try(:[],limit)  || rec.try(limit) || 60*60*24)
                end
              when "Device"
                device_limits << (rec.restrictions[:devices].try(:[], devices.id).try(:[],limit)  || rec.try(limit) || 60*60*24)
            end
            device_limit = device_limits.min
          end
          if !activity_id.nil?
            activity_limit = rec.restrictions[:activities].try(:[], activity_id).try(:[], limit) || rec.try(limit) || 60*60*24
            result = device_limit.nil? ? activity_limit :  ( device_limit < activity_limit ? device_limit : activity_limit)
          else
            result = device_limit
          end
        end
      end

    end
    result
  end

end
