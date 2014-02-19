require 'formula'

class Graylog2Server < Formula
  version '0.20.0-rc.3'
  homepage 'http://www.graylog2.org/'
  url 'https://github.com/Graylog2/graylog2-server/releases/download/0.20.0-rc.3/graylog2-server-0.20.0-rc.3.tgz'
  sha1 '0812682e0e1805ddbb05c8a3f0de07ccb3170f73'

  depends_on 'elasticsearch'
  depends_on 'mongodb'

  def cluster_name
    "elasticsearch_#{ENV['USER']}"
  end

  def install
    mv "graylog2.conf.example", "graylog2.conf"
    inreplace "graylog2.conf" do |s|
      # Better to use 127.0.0.1 instead of localhost so you
      # don't need to allow external access to MongoDB.
      # http://www.eimermusic.com/code/graylog2-on-mac-os-x/
      s.gsub! "node_id_file = /etc/graylog2-server-node-id", "node_id_file = #{etc}/graylog2-server-node-id"
      s.gsub! "password_secret =", "password_secret = " + (0...64).map { (65 + rand(26)).chr }.join
      s.gsub! "root_password_sha2 =", "root_password_sha2 = 4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2"
      s.gsub! "#elasticsearch_discovery_zen_ping_multicast_enabled = false", "elasticsearch_discovery_zen_ping_multicast_enabled = false"
      s.gsub! "#elasticsearch_cluster_name = graylog2", "elasticsearch_cluster_name = #{cluster_name}"
      s.gsub! "#elasticsearch_discovery_zen_ping_unicast_hosts = 192.168.1.203:9300", "elasticsearch_discovery_zen_ping_unicast_hosts = 127.0.0.1:9300"
    end

    inreplace "bin/graylog2ctl" do |s|
      s.gsub! "$NOHUP java -jar ${GRAYLOG2_SERVER_JAR} -f ${GRAYLOG2_CONF} -p ${GRAYLOG2_PID} >> ${LOG_FILE} &",
              "$NOHUP java -jar #{prefix}/graylog2-server.jar -f #{etc}/graylog2.conf -p /tmp/graylog2.pid &"
    end

    etc.install "graylog2.conf"
    prefix.install Dir['*']

    (var+'log/graylog2-server').mkpath
  end

  def caveats; <<-EOS.undent
      In the interest of allowing you to run graylog2-server as a
      non-root user, the default syslog_listen_port is set to 8514.

      The config file is located at:
        #{etc}/graylog2.conf
    EOS
  end

  plist_options :manual => "graylog2ctl start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>java</string>
        <string>-jar</string>
        <string>#{opt_prefix}/graylog2-server.jar</string>
        <string>-f</string>
        <string>#{etc}/graylog2.conf</string>
        <string>-p</string>
        <string>/tmp/graylog2.pid</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/graylog2-server/error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/graylog2-server/output.log</string>
    </dict>
    </plist>
    EOS
  end

  def test
    ohai "Verifying Graylog2 configuration (--configtest)"
    system "java -jar #{prefix}/graylog2-server.jar -f #{etc}/graylog2.conf --configtest"
  end
end
