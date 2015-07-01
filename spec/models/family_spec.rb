require 'rails_helper'

RSpec.describe Family, :type => :model do
  it 'has a valid factory' do
    family = FactoryGirl.create(:family)
    expect(family.valid?).to be_truthy
  end

  context 'with a valid family' do
    before(:each) do
      @family = FactoryGirl.create(:family)
      @kids = FactoryGirl.create_list(:member, 3, parent: false, family_id: @family.id )
      expect(@kids.count).to eq 3
    end

    it 'should return a list of the kids in the family' do
      expect(@family.kids.count).to eq(@kids.count)
    end

    it 'should assign a todo template to specific family members' do
      #   def assign_template(todo_template, assign_members = Array.new)
      template = FactoryGirl.create(:todo_template)
      before_todos = @family.todos.count
      kids_array = @kids.sample(2)
      unassigned_child = (@kids - kids_array).sample
      assigned_child = Member.find(kids_array[0].id)
      before_todo_scehdules_assigned = assigned_child.todo_schedules.count
      before_todo_scehdules_unassigned = unassigned_child.todo_schedules.count
      todo = @family.assign_template(template,kids_array )
      expect(@family.todos.count).to eq(before_todos + 1)
      expect(@family.todos.last).to eq(todo)
      expect(assigned_child.todo_schedules.count).to eq(before_todo_scehdules_assigned + 1)
      expect(unassigned_child.todo_schedules.count).to eq(before_todo_scehdules_unassigned)
    end

    it 'should assign a group of todo_templates to specific family members' do
      todo_group =  FactoryGirl.create(:todo_group)
      #   def assign_group(todo_group, assign_members = Array.new)

      num_templates_in_group = todo_group.todo_templates.count
      before_todos = @family.todos.count
      kids_array = @kids.sample(2)
      unassigned_child = (@kids - kids_array).sample
      assigned_child = Member.find(kids_array[0].id)
      before_todo_scehdules_assigned = assigned_child.todo_schedules.count
      before_todo_scehdules_unassigned = unassigned_child.todo_schedules.count
      @family.assign_group(todo_group,kids_array )
      expect(@family.todos.count).to eq(before_todos + num_templates_in_group)
      expect(assigned_child.todo_schedules.count).to eq(before_todo_scehdules_assigned + num_templates_in_group)
      expect(unassigned_child.todo_schedules.count).to eq(before_todo_scehdules_unassigned)

    end

    it 'should memorialize todos from previous days' do

      kid = @kids[0]
      template = FactoryGirl.create(:todo_template)
      @family.assign_template(template, [kid.id])

      before_my_todos_count = kid.my_todos.count

      #make schedule start in past
      kid.todo_schedules.find_each do |ts|
        ts.start_date = 45.days.ago.to_date
        ts.save!(validate: false)
      end

      (45.days.ago.to_date .. 1.days.ago.to_date).each { |d| Family.memorialize_todos(d) }

      expect(kid.my_todos.count).to eq(before_my_todos_count + 45)
    end
  end

  context 'with devices' do
    before(:each) do
      @family = FactoryGirl.create(:family)
      @kids = FactoryGirl.create_list(:member, 3, parent: false, family_id: @family.id )
      @family.devices.each {|dev| dev.destroy }

      # setup device types
      ipod = DeviceType.create({ name: 'iPod Touch', description: 'Apple iPod Touch', os: 'iOS', version: '' })
      iphone = DeviceType.create({ name: 'iPhone', description: 'Apple iPhone', os: 'iOS', version: '' })
      ipad = DeviceType.create({ name: 'iPad', description: 'Apple iPad', os: 'iOS', version: '' })
      android_tablet = DeviceType.create({ name: 'Android Phone', description: '', os: 'Android', version: '' })
      android_phone = DeviceType.create({ name: 'Android Tablet', description: '', os: 'Android', version: '' })
      fire_phone = DeviceType.create({ name: 'Amazon Fire Phone', description: '', os: '', version: '' })
      kindle = DeviceType.create({ name: 'Amazon Fire Tablet', description: 'Kindle Fire/HD/HDx', os: 'FireOS', version: '' })
      ps2 = DeviceType.create({ name: 'Playstation 2', description: '', os: '', version: '' })
      ps3 = DeviceType.create({ name: 'Playstation 3', description: '', os: '', version: '' })
      ps4 = DeviceType.create({ name: 'Playstation 4', description: '', os: '', version: '' })
      xbox360 = DeviceType.create({ name: 'xBox 360', description: '', os: '', version: '' })
      xbox1 = DeviceType.create({ name: 'xBox One', description: '', os: '', version: '' })
      wii = DeviceType.create({ name: 'Nintendo Wii', description: '', os: '', version: '' })
      n3ds = DeviceType.create({ name: 'Nintendo 3DS', description: '', os: '', version: '' })
      kudososp = DeviceType.create({ name: 'Kudoso SmartPlug', description: '', os: 'Kudoso', version: '' })
      kudoso = DeviceType.create({ name: 'Kudoso Gateway', description: '', os: 'Kudoso', version: '' })
      bluray = DeviceType.create({ name: 'BluRay Player', description: '', os: '', version: '' })
      hdtv = DeviceType.create({ name: 'HDTV', description: 'Not Connected', os: '', version: '' })
      smartv = DeviceType.create({ name: 'Smart-TV HDTV', description: 'Smart-TV Connected TV', os: '', version: '' })
      appletv = DeviceType.create({ name: 'AppleTV', description: '', os: '', version: '' })
      roku = DeviceType.create({ name: 'Roku', description: '', os: '', version: '' })
      firetv = DeviceType.create({ name: 'Amazon FireTV', description: '', os: '', version: '' })
      pc = DeviceType.create({ name: 'Windows Personal Computer', description: '', os: '', version: '' })
      mac = DeviceType.create({ name: 'Apple Macintosh Personal Computer', description: '', os: '', version: '' })

      entertainment = ActivityType.create({ name: 'Entertainment', metadata_fields: { } } )
      education = ActivityType.create({ name: 'Education', metadata_fields: { } } )
      health = ActivityType.create({ name: 'Health', metadata_fields: { } } )


      #create devices
      @kudoso_smartplug_1 = @family.devices.create({name: 'Living Room SmartPlug', device_type_id: DeviceType.find_by_name('Kudoso SmartPlug').id, managed: true})
      @kudoso_smartplug_2 = @family.devices.create({name: 'Play Room SmartPlug', device_type_id: DeviceType.find_by_name('Kudoso SmartPlug').id, managed: true})
      @devices = @family.devices.create([
                                           {name: 'Family iPad', device_type_id: DeviceType.find_by_name('iPad').id, managed: true},
                                           {name: 'Living Room HDTV', device_type_id: DeviceType.find_by_name('HDTV').id, managed: false},
                                           {name: 'Living Room BluRay', device_type_id: DeviceType.find_by_name('BluRay Player').id, managed: true},
                                           {name: 'Playstation 3', device_type_id: DeviceType.find_by_name('Playstation 3').id, managed: true},
                                           {name: "Suzy's iPhone", device_type_id: DeviceType.find_by_name('iPhone').id, managed: true}
                                       ])

      #create activities
      activity_template = ActivityTemplate.create({ name: 'Play a game', description: '', restricted: true, cost: 0, reward: 0, time_block: 10, activity_type: entertainment })
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps2, ps3, ps4, xbox360, xbox1, wii, n3ds, pc, mac].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Surf the internet (entertainment)', description: '', restricted: true, cost: 0, reward: 0, time_block: 10, activity_type: entertainment })
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps2, ps3, ps4, xbox360, xbox1, wii, n3ds, pc, mac, smartv, roku, appletv, firetv].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Surf the internet (education)', description: '', restricted: false, cost: 0, reward: 0, time_block: 10 , activity_type: education})
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps2, ps3, ps4, xbox360, xbox1, wii, n3ds, pc, mac, smartv, roku, appletv, firetv].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Read a book', description: '', restricted: false, cost: 0, reward: 0, time_block: 10, activity_type: education })
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, pc, mac].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Read a magazine', description: '', restricted: true, cost: 0, reward: 0, time_block: 10, activity_type: entertainment })
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, pc, mac].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Kahn Academy', description: '', restricted: false, cost: 0, reward: 0, time_block: 10 , activity_type: education})
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, pc, mac].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Watch Netflix', description: '', restricted: true, cost: 0, reward: 0, time_block: 10, activity_type: entertainment })
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps3, ps4, xbox360, xbox1, wii, pc, mac, appletv, firetv, roku, smartv, bluray].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Watch Amazon Prime', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 , activity_type: entertainment})
      [ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps3, ps4, xbox360, xbox1, wii, pc, mac, appletv, firetv, roku, smartv, bluray].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Watch BluRay', description: '', restricted: true, cost: 0, reward: 0, time_block: 10, activity_type: entertainment })
      [smartv, hdtv, bluray ].each { |device_type| activity_template.device_types << device_type }

      activity_template = ActivityTemplate.create({ name: 'Watch television', description: '', restricted: true, cost: 0, reward: 0, time_block: 10, activity_type: entertainment })
      [hdtv, smartv, bluray, appletv, firetv, roku].each { |device_type| activity_template.device_types << device_type }

    end

    it 'should return the correct number of licenced devices for a family' do
      @kudoso_smartplug_1.managed_devices << @devices[2]
      @kudoso_smartplug_2.managed_devices << @devices[3]

      expect(@kudoso_smartplug_1.reload.managed_devices_count).to eq(1)
      expect(@kudoso_smartplug_2.reload.managed_devices_count).to eq(1)
      expect(@devices.sample.reload.managed_devices_count).to eq(0)
      # we have 4 managed devices: the iPad, bluray, ps3 and iPhone
      expect(@family.managed_device_count).to eq(4)
    end


    it 'should return recommended activities based on devices' do
      expect(@family.recommended_activities.count).to eq(10)
      @family.devices.where('device_type_id = ?', DeviceType.find_by_name('HDTV').id).each { |dev| dev.destroy }
      @family.devices.where('device_type_id = ?', DeviceType.find_by_name('BluRay Player').id).each { |dev| dev.destroy }
      @family.reload
      expect(@family.recommended_activities.count).to eq(8)
    end

    skip 'should be able assign an activity' do
      #TODO: refactor based on no family activities
      act = @family.recommended_activities.sample
      before_act_count = @family.family_activities.count
      @family.assign_activity(act)
      expect(@family.family_activities.count).to eq(before_act_count + 1)
      expect(@family.family_activities.last.activity_template_id).to eq(act.id)
    end

  end
end
