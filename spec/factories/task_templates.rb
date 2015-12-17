require 'faker'

FactoryGirl.define do
  factory :task_template do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    kudos 0
    rec_min_age { rand(2..8) }
    rec_max_age { rec_min_age + rand(2..8) }
    def_min_age { rec_min_age }
    def_max_age { rec_max_age - 1  }

    after(:build) { |tt| tt.rule = IceCube::Rule.daily.to_yaml; tt.save; }
  end

end
