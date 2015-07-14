module NotDeleteable
  def destroy
    unless self.respond_to? :disabled
      raise MissingMigrationException
    end

    self.update_attribute :disabled, true
  end


  def delete
    self.destroy
  end


  def self.included(base)
    base.class_eval do
      default_scope { where('disabled IS NOT TRUE' ) }
    end
  end
end


class MissingMigrationException < Exception
  def message
    "#{self.class} is lacking the disabled boolean field"
  end
end