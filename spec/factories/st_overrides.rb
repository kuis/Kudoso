FactoryGirl.define do
  factory :st_override do
    member_id { FactoryGirl.create(:member).id }
    time 7200
    date { Time.now }
    comment "MyString"
    after(:create) { |st| st.created_by = FactoryGirl.create(:member, family_id: st.member.family_id, parent: true) }
  end

end
