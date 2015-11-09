class KudosoAuth

  def self.sign(msg, timestamp = nil)
    timestamp ||= Time.now.to_i.to_s
    "#{timestamp}|#{Digest::MD5.hexdigest(msg + '|' +  timestamp + 'cfa4c796c0f9d7ce3db5d163023476a0')}"
  end

  def self.valid_signature?(msg)
    msg.chomp!
    signature = msg.split('|')[-1]
    timestamp = msg.split('|')[-2]

    test_signature = self.sign(msg.split('|')[0..-3].join('|'), timestamp)

    test_signature == "#{timestamp}|#{signature}"
  end

  def self.send_to_router(msg)
    #todo put a timeout on this

    # join
    mac = $1 if `ifconfig` =~ /en1.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
    router = TCPSocket.new 'router.kudoso.com', 54283

    join_msg = "join|#{mac}"

    router.puts "#{join_msg}|#{self.sign(mac)}"
    response = router.gets
    id, cmd, args = response.split("|")

    if cmd &&  cmd.strip == 'ok'
      router.puts "#{msg}|#{self.sign(msg.split('|')[1..-1].join('|'))}"
      response = router.gets
      id, cmd, args = response.split("|")
      if cmd &&  cmd.strip == 'ok'
        return true
      else
        return false
      end
    else
      return false
    end


  end


end