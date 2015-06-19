class Family < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :family_activities, dependent: :destroy
  has_one :screen_time_schedule
  belongs_to :primary_contact, class_name: 'User'
  has_many :family_device_categories, dependent: :destroy

  accepts_nested_attributes_for :members, :reject_if => :all_blank, :allow_destroy => true

  def kids
    members.where('parent IS NOT true')
  end

  def self.memorialize_todos(for_date = Date.yesterday)
    for_date = for_date.end_of_day
    @families = self.includes(:members => {:todo_schedules => [:my_todos, :schedule_rrules]})
    @families.find_each do |family|
      family.kids.each do |kid|
        kid.todo_schedules.each do |schedule|
          if schedule.active && schedule.start_date <= for_date && ( schedule.end_date.blank? || schedule.end_date >= for_date )
            if schedule.schedule.occurs_on?(for_date)
              my_todo = MyTodo.find_or_create_by(member_id: kid.id, todo_schedule_id: schedule.id, due_date: for_date)
            end
          end
        end
      end
      family.update_attribute(:memorialized_date, for_date) if family.memorialized_date.blank? || family.memorialized_date < for_date
    end
  end

  def assign_group(todo_group, assign_members = Array.new)
    todo_group.todo_templates.each do |todo_template|
      self.assign_template(todo_template, assign_members)
    end
  end

  def assign_template(todo_template, assign_members = Array.new)
    return false if todo_template.nil?
    #add to family if not already in their todo list
    todo = self.todos.find {|todos| todos.todo_template_id == todo_template.id}
    unless todo.present?
      todo = self.todos.build({name: todo_template.name, description: todo_template.description, schedule: todo_template.schedule, todo_template_id: todo_template.id, kudos: todo_template.kudos})
      todo.active = true; #can't mass assign this
      todo.save
      # add the todo to each family member
    end

    assign_members.each do |i|
      unless i.blank?
        member = Member.find_by_id(i)
        # only assign it if the member is in the same family and does not already have this todo
        if member.family_id == self.id && !(member.todo_schedules.find {|ts| ts.todo_id == todo.id})
          todo_schedule = member.todo_schedules.build(start_date: Date.today.beginning_of_day, todo_id: todo.id )
          todo_schedule.active = true
          todo_schedule.save
          todo_schedule.schedule_rrules.create(rrule: todo.schedule)
        else
          logger.warn "Attempted to assigning todo_template #{todo_template.id} to member #{member.id} who is not part of family #{self.id} or already has it"
        end
      end
    end

    todo
  end

  def assign_activity(activity_template)
    return nil if activity_template.nil?

    family_activities.create({name: activity_template.name,
                              description: activity_template.description,
                              activity_template_id: activity_template.id,
                              restricted: activity_template.restricted,
                              cost: activity_template.cost,
                              reward: activity_template.reward,
                              time_block: activity_template.time_block
                             })

  end

  # returns integer of managed devices for license purposes
  def managed_device_count
    devices.select{|d| (d.managed_devices_count == 0 && d.managed)}.count
  end

  # returns an array of recommended activities based on devices in the family
  def recommended_activities
    rec = Set.new

    devices.each do |device|
      device.device_type.activity_templates.each { |activity_template| rec << activity_template }
    end

    rec.to_a
  end

  def create_mobicip_account_xml
    require 'rexml/document'
    self.mobicip_password ||= SecureRandom.hex(18)
    doc = REXML::Document.new
    doc.add_element("request")
    doc.elements["request"].add_element("account")
    doc.elements["request"].elements["account"].add_element "user"
    doc.elements["request"].elements["account"].elements["user"].add_element "email"
    doc.elements["request"].elements["account"].elements["user"].elements["email"].add_text "family_#{self.id}@kudoso.com"
    doc.elements["request"].elements["account"].elements["user"].add_element "password"
    doc.elements["request"].elements["account"].elements["user"].elements["password"].add_text self.mobicip_password
    doc.elements["request"].elements["account"].elements["user"].add_element "passwordConfirmation"
    doc.elements["request"].elements["account"].elements["user"].elements["passwordConfirmation"].add_text self.mobicip_password
    doc.elements["request"].elements["account"].add_element "acceptTerms"
    doc.elements["request"].elements["account"].elements["acceptTerms"].add_text "true"
    doc.elements["request"].elements["account"].add_element "location"
    doc.elements["request"].elements["account"].elements["location"].add_text "America"
    doc.elements["request"].elements["account"].add_element "receiveNewsletters"
    doc.elements["request"].elements["account"].elements["receiveNewsletters"].add_text "false"
    doc.elements["request"].add_element("client")
    doc.elements["request"].elements["client"].add_element "id"
    doc.elements["request"].elements["client"].elements["id"].add_text "MobicipDev05"
    doc.elements["request"].elements["client"].add_element "version"
    doc.elements["request"].elements["client"].elements["version"].add_text "1.0"
    doc
    xml = '<?xml version="1.0" encoding="UTF-8"?>' + doc.to_s
  end

end
