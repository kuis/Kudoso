# Setup system background information
######################################

admin = User.create({email: 'kaz@kudoso.com', first_name: 'Mike', last_name: 'Kazmier', password: 'password', password_confirmation: 'password', admin: true, confirmed_at: Time.now})

# Populate helpdesk fields

address_types = AddressType.create([
                                    { name: 'Home' },
                                    { name: 'Work' },
                                    { name: 'Other' }
                                   ])

phone_types = PhoneType.create([
                                       { name: 'Home' },
                                       { name: 'Work' },
                                       { name: 'Mobile' },
                                       { name: 'Skype' },
                                       { name: 'Other' }
                                   ])
contact_types = ContactType.create([
                                       { name: 'Customer' },
                                       { name: 'Prospect' },
                                       { name: 'Vendor' },
                                       { name: 'Partner' },
                                       { name: 'Media' },
                                       { name: 'Other' }
                                   ])

note_types = NoteType.create([
                                 { name: 'Email' },
                                 { name: 'Phone Call' },
                                 { name: 'Meeting' },
                                 { name: 'Letter' },
                                 { name: 'Other' }
                             ])

ticket_types = TicketType.create([
                                     { name: 'Support' },
                                     { name: 'Sales' },
                                     { name: 'Media' },
                                     { name: 'Finance' },
                                     { name: 'Partner / Business Development' },
                                     { name: 'Other' }
                                 ])

# generate content ratings and descriptors

ratings = ContentRating.create([
                                   { org: 'MPAA', tag: 'G', short: 'G : General Audiences', description: 'All ages admitted.'},
                                   { org: 'MPAA', tag: 'PG', short: 'PG : Parental Guidance Suggested', description: 'Some material may not be suitable for children.'},
                                   { org: 'MPAA', tag: 'PG-13', short: 'PG-13 : Parents Strongly Cautioned', description: 'Some material may be inappropriate for children under 13.'},
                                   { org: 'MPAA', tag: 'R', short: 'R : Restricted', description: 'Under 17 requires accompanying parent or adult guardian. Contains some adult material.'},
                                   { org: 'MPAA', tag: 'NC-17', short: 'NC-17 : Adults Only', description: 'No One 17 and Under Admitted.'},
                                   { org: 'TV', tag: 'TV-Y', short: 'Youth', description: 'This program is designed to be appropriate for all children.'},
                                   { org: 'TV', tag: 'TV-Y7', short: 'Youth 7+', description: 'This program is designed for children age 7 and above.'},
                                   { org: 'TV', tag: 'TV-G', short: 'Everyone', description: 'Most parents would find this program suitable for all ages.'},
                                   { org: 'TV', tag: 'TV-PG', short: 'Parental Guidance', description: 'This program contains material that parents may find unsuitable for younger children.'},
                                   { org: 'TV', tag: 'TV-14', short: 'Young Adult 14+', description: 'This program contains some material that many parents would find unsuitable for children under 14 years of age.'},
                                   { org: 'TV', tag: 'TV-MA', short: 'Adults Only', description: 'This program is specifically designed to be viewed by adults and therefore may be unsuitable for children under 17.'},
                                   { org: 'ESRB', tag: 'RP', short: 'Rating Pending', description: 'Games that have not yet been assigned a final rating by the ESRB.'},
                                   { org: 'ESRB', tag: 'EC', short: 'Early Childhood', description: 'Games suitable for young children ages 3 and up.'},
                                   { org: 'ESRB', tag: 'E', short: 'Everyone', description: 'Games suitable for general audiences; they can contain infrequent use of "mild" or cartoon/fantasy violence, and mild language.'},
                                   { org: 'ESRB', tag: 'E10+', short: 'Everyone 10+', description: 'Games suitable for general audiences aged 10 years of age and older. They can contain a larger amount of violence, mild language, crude humor, or suggestive content than the standard E rating can accommodate.'},
                                   { org: 'ESRB', tag: 'T', short: 'Teen', description: 'Games suitable for those aged 13 years and older; they can contain moderate amounts of violence (including small amounts of blood), mild to moderate language or suggestive themes, and crude humor.'},
                                   { org: 'ESRB', tag: 'M', short: 'Mature', description: 'Games suitable for those aged 17 years and older; they can contain more intense and/or realistic portrayals of violence than T-rated games (including blood and gore), stronger sexual themes and content, nudity, and heavier use of strong language.'},
                                   { org: 'ESRB', tag: 'A', short: 'Adults Only', description: 'Games unsuitable for people under 18 years of age; they can contain stronger sexual themes and content, graphic nudity, or extreme levels of violence—higher than the "Mature" rating can accommodate.'}
                               ])

content_descriptors = ContentDescriptor.create([
                                   { tag: 'AC', short: 'Adult Content', description: 'Content may contain suggestive dialogue, crude humor or in extreme cases, drug references or depiction of drug and/or alcohol use that may not be suitable for children.' },
                                   { tag: 'AL', short: 'Adult Language', description: 'Content may contain profanity, ranging from either mild profanity to expletives, with or without a sexual meaning.' },
                                   { tag: 'GL', short: 'Graphic Language', description: 'Content will contain a heavy amount of profanity, with relatively to very frequent usage of expletives with or without a sexual meaning.' },
                                   { tag: 'MV', short: 'Mild Violence', description: 'Content contains a mild amount of violent content, either comedic or non-comedic in nature, that may or may not include some bloodshed.' },
                                   { tag: 'V', short: 'Violence', description: 'Content contains a moderate to significant amount of violent content (such as a physical altercation or shooting), which may include mild to moderate amounts of bloodshed.' },
                                   { tag: 'GV', short: 'Graphic Violence', description: 'Content may contain a heavy amount of violence, blood or gore, that is unsuitable for younger audiences or those who are squeamish to such content.' },
                                   { tag: 'BN', short: 'Brief Nudity', description: 'Content contains a minimal amount of moderate nudity, that may either be depicted in a sexual or non-sexual nature (such as a brief glimpse of a buttocks); nudity seen in the program or film may not necessarily be full-frontal in nature.' },
                                   { tag: 'N', short: 'Nudity', description: 'Content contains a moderate to significant amount of partial or full-frontal nudity, that may either be depicted in a sexual or non-sexual nature.' },
                                   { tag: 'SSC', short: 'Strong Sexual Content', description: 'Content may contain graphic sexual situations, particularly scenes of simulated (or in rare cases, actual) sexual intercourse that is often of a pornographic nature, with the incorporation of moderate or full-frontal nudity.' },
                                   { tag: 'RP', short: 'Rape', description: 'Content may contain graphic scenes of rape and/or other forms of sexual assault, depicted in a realistic and often violent, but fictional nature.' },
                                   {tag: 'D', short: 'Suggestive Dialog', description: 'Content may contain verbal descriptions and/or suggestions of sexual interest and intimacy.'} ,
                                   {tag: 'L', short: 'Coarse Language', description: 'Content may contain mild profanity, with or without a sexual meaning.'} ,
                                   {tag: 'S', short: 'Sexual Content', description: 'Content may contain graphic sexual situations, including depictions of sexual intercourse.'}
                                               ])

content_types = ContentType.create([
                                       {name: 'Other'},
                                       {name: 'Movie'},
                                       {name: 'TV Series'},
                                       {name: 'TV Episode'},
                                       {name: 'TV Channel'},
                                       {name: 'Music'},
                                       {name: 'App'},
                                       {name: 'Internet Site'},
                                       {name: 'Book'},
                                       {name: 'Magazine'}
                                   ])

# generate device types

activity_types = ActivityType.create([
                                         { name: 'Other', metadata_fields: { } },
                                         { name: 'Play a Game', metadata_fields: { } },
                                         { name: 'Surf the Internet', metadata_fields: { } },
                                         { name: 'Read', metadata_fields: { } },
                                         { name: 'Stream Media', metadata_fields: { } },
                                         { name: 'Physical', metadata_fields: { } }
                                     ])

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


activity_template = ActivityTemplate.create({ name: 'Play a game', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps2, ps3, ps4, xbox360, xbox1, wii, n3ds, pc, mac].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Surf the internet (entertainment)', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps2, ps3, ps4, xbox360, xbox1, wii, n3ds, pc, mac, smartv, roku, appletv, firetv].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Surf the internet (education)', description: '', restricted: false, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps2, ps3, ps4, xbox360, xbox1, wii, n3ds, pc, mac, smartv, roku, appletv, firetv].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Read a book', description: '', restricted: false, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, pc, mac].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Read a magazine', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, pc, mac].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Kahn Academy', description: '', restricted: false, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, pc, mac].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Play outside', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Play with a friend', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Exercise', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Play a board game', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Watch Netflix', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps3, ps4, xbox360, xbox1, wii, pc, mac, appletv, firetv, roku, smartv, bluray].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Watch Amazon Prime', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[ipod, iphone, ipad, android_tablet, android_phone, fire_phone, kindle, ps3, ps4, xbox360, xbox1, wii, pc, mac, appletv, firetv, roku, smartv, bluray].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Watch BluRay', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[smartv, hdtv, bluray ].each { |device_type| activity_template.device_types << device_type }

activity_template = ActivityTemplate.create({ name: 'Watch television', description: '', restricted: true, cost: 0, reward: 0, time_block: 10 })
[hdtv, smartv, bluray, appletv, firetv, roku].each { |device_type| activity_template.device_types << device_type }



# Populate our ToDo templates and groups:
daily = IceCube::Rule.daily
weekdays = IceCube::Rule.weekly.day(:monday, :tuesday, :wednesday, :thursday, :friday)
saturdays = IceCube::Rule.weekly.day(:saturday)
todo_templates = TodoTemplate.create([
                                         { name: 'Brush teeth', description: 'To prevent cavities bush your teeth for at least 60 seconds.', required: true, schedule: "#{daily.to_yaml}", active: true, kudos: 20 },
                                         { name: 'Brush hair', description: 'Look your best and get rid of that bed hed!', required: true, schedule: "#{daily.to_yaml}", active: true, kudos: 20 },
                                         { name: 'Make bed', description: 'Your room is a reflection of you. Your neat! So your bed should be made neatly too.', required: true, schedule: "#{daily.to_yaml}", active: true, kudos: 20 },
                                         { name: 'Read a book', description: 'Reading is fun, red for at least 30 minute!', required: true, schedule: "#{weekdays.to_yaml}", active: true, kudos: 20 },
                                         { name: 'Pick up room', description: 'Its easier to pickup every week than to let the mess build!', required: true, schedule: "#{saturdays.to_yaml}", active: true, kudos: 20 },
                                         { name: 'Finish homework', description: 'Work hard, play hard! Its important to finish your work before playing.', required: true, schedule: "#{weekdays.to_yaml}", active: true, kudos: 20 },
                                         { name: 'Mow lawn', description: 'Maintaining our home requires everyone to help.', required: true, schedule: "#{saturdays.to_yaml}", active: true, kudos: 20 }
                                     ])

group_one = TodoGroup.create({ name: 'Group One', rec_min_age: 2, rec_max_age: 12, active: true })

group_one.todo_templates << todo_templates[0]
group_one.todo_templates << todo_templates[1]
group_one.todo_templates << todo_templates[2]



group_two = TodoGroup.create({ name: 'Group Two', rec_min_age: 6, rec_max_age: 12, active: true })

group_two.todo_templates << todo_templates[3]
group_two.todo_templates << todo_templates[4]

group_three = TodoGroup.create({ name: 'Group Three', rec_min_age: 9, rec_max_age: 12, active: true })

group_three.todo_templates << todo_templates[5]
group_three.todo_templates << todo_templates[5]



# Setup our first users and family
################################
#
# 1. Create family
# 2. Add Todos by assigning groups to the family
# 3. Add Devices to family
# 4. Add Activities to family
# 5. Setup family member screentime restrictions
#



# 1. Create family
  parent = User.create({email: 'parent@kudoso.com', first_name: 'Parent', last_name: 'Test', password: 'password', password_confirmation: 'password', confirmed_at: Time.now})

  johnny = Member.create({username: 'johnny', password: '1234', family_id: parent.member.family_id, contact_attributes: { first_name: 'Johnny', last_name: 'Test', contact_type_id: ContactType.find_by_name('Customer').id } })

  suzy = Member.create({username: 'suzy', password: '4321', family_id: parent.member.family_id, contact_attributes: {first_name: 'Suzy', last_name: 'Test', contact_type_id: ContactType.find_by_name('Customer').id}})

# 2. Add Todos by assigning groups to the family
  parent.member.family.assign_group(group_one, [johnny.id, suzy.id ])

  # reset todo_schedules to the past
  TodoSchedule.find_each do |ts|
    ts.start_date = 45.days.ago.to_date
    ts.save!(validate: false)
  end

  # create historical my_todos for each child
  (45.days.ago.to_date .. 1.days.ago.to_date).each { |d| Family.memorialize_todos(d) }

  # randomly mark some todos as complete
  [johnny, suzy].each do |kid|
    (kid.my_todos.count / 3).floor.times do
      kid.my_todos.where('complete IS NOT TRUE').sample.update_attribute(:complete, true)
    end
  end

# 3. Add Devices to family
  kudoso_smartplug_1 = parent.member.family.devices.create({name: 'Living Room SmartPlug', device_type_id: DeviceType.find_by_name('Kudoso SmartPlug').id, managed: true})
  kudoso_smartplug_2 = parent.member.family.devices.create({name: 'Play Room SmartPlug', device_type_id: DeviceType.find_by_name('Kudoso SmartPlug').id, managed: true})
  devices = parent.member.family.devices.create([
                                      {name: 'Family iPad', device_type_id: DeviceType.find_by_name('iPad').id, managed: true},
                                      {name: 'Living Room HDTV', device_type_id: DeviceType.find_by_name('HDTV').id, managed: false},
                                      {name: 'Living Room BluRay', device_type_id: DeviceType.find_by_name('BluRay Player').id, managed: true, management_id: kudoso_smartplug_1.id},
                                      {name: 'Playstation 3', device_type_id: DeviceType.find_by_name('Playstation 3').id, managed: true, management_id: kudoso_smartplug_2.id},
                                      {name: "Suzy's iPhone", device_type_id: DeviceType.find_by_name('iPhone').id, managed: true, primary_member_id: suzy.id}
                                  ])

# 4. Add activities to family
  parent.member.family.recommended_activities.each { |activity_template| parent.family.assign_activity(activity_template) }

# 5. Setup family member screentime restrictions

