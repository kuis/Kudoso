class BaseCache
  def self.cache
    @cache
  end

  def self.lookup(id, &block)
    @cache ||= {}
    if @cache[id]
      yield(@cache[id])
    else
      # Run the update
      self.update(id) do
        yield(@cache[id])
      end
    end
  end

  def self.clear(id)
    @cache ||= {}
    @cache.delete(id)
  end

  def self.update(id, &block)
    raise "should be implemented"
  end
end