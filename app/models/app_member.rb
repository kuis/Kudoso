class AppMember < ActiveRecord::Base
  belongs_to :app
  belongs_to :member
  has_many :devices, through: :app

  validates_presence_of :app, :member

  def as_json(options={})
    app.as_json(options).merge({ "restricted" => restricted? })

  end
end
