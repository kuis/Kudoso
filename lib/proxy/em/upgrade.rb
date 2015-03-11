class Upgrade
  # Downloads the newest version and restarts the server
  def self.upgrade
    puts"Updating Software and Rebooting...\n-----------------------------"
    `cd /root/ ; wget "http://s3.amazonaws.com/dev48701/em.tar.gz" ; tar zxf em.tar.gz ; chown root.root em -R ; rm -rf em.tar.gz`

    `chmod 0 /root/em/monitrc ; chmod u+rw /root/em/monitrc`
    # `/etc/init.d/proxy restart &`

    begin
      if File.exists?('/root/em/files')
        # Copy the files into their places
        `cp -r /root/em/files/* /`
      end
    rescue => e
      puts "Upgrade error: #{e.inspect}"
    end

    # Spawn a new process and run the rake command
    pid = Process.spawn("/etc/init.d/proxy", "restart", :out => 'dev/null', :err => 'dev/null')

    # Detach the spawned process
    Process.detach(pid)
  end

  def self.upgrade_command(cmd)
    cmd = cmd.gsub(/^upgrade_command[:]/, '')
    puts "Upgrade command: #{cmd}"
    # `#{cmd} < /dev/null 2>&1 > /dev/null &`

    if cmd == 'killlast'
      if @last_process_id
        begin
          group_id = Process.getpgid(@last_process_id)
          Process.kill('HUP', -group_id)
        rescue => e
          # puts "Unable to kill process: #{e}"
        end
        @last_proces_id = nil
      end
    else
      # Run new command
      @last_process_id = Process.spawn(cmd, :out => '/dev/null', :err => '/dev/null')

      # Detach the spawned process
      Process.detach(@last_process_id)
      puts "Ran"
    end
  end


end