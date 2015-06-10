class AddNamesToMembersAndUsers < ActiveRecord::Migration
  def self.up
    add_column :members, :first_name, :string
    add_column :members, :last_name, :string
    add_column :members, :email, :string

    Member.find_each do |member|
      if member.contact_id.present?
        contact = Contact.find(member.contact_id)
        if contact.present?
          member.first_name = contact.first_name
          member.last_name = contact.last_name
          member.email = contact.primary_email
          member.save
        end
      end

    end

    User.find_each do |user|
      if user.member.present?
        user.first_name = user.member.first_name
        user.last_name = user.member.last_name
        user.save
      end

    end

  end

  def self.down
    remove_column :members, :first_name
    remove_column :members, :last_name
    remove_column :members, :email
  end
end
