require "formula"

class Graylog2WebInterface < Formula
  version "0.20.0-rc.1-1"
  homepage "http://www.graylog2.org/"
  url "https://github.com/Graylog2/graylog2-web-interface/releases/download/0.20.0-rc.1-1/graylog2-web-interface-0.20.0-rc.1-1.tgz"
  sha1 "e127fef509eceb32b8eb00a90a5b8f4bc93a276d"

  depends_on "rhussmann/graylog2/graylog2-server"

  def install
    inreplace "conf/graylog2-web-interface.conf" do |s|
      s.gsub! "graylog2-server.uris=\"\"", "graylog2-server.uris=\"http://127.0.0.1:12900\""
      s.gsub! "application.secret=\"\"", "application.secret=\"\" 4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2"
    end

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]

    (var+'log/graylog2-web-interface').mkpath
  end

  def caveats; <<-EOS.undent
      This installer assumes default vales for graylog2 server URI
      and password. If you've configured graylog2-server to use a
      a URI or application secret different than the default, you'll
      need to modify your configuration.

      The config file is located at:
        #{libexec}/conf/graylog2-web-interface.conf
    EOS
  end

  plist_options :manual => "graylog2-web-interface"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/graylog2-web-interface</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/graylog2-web-interface/error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/graylog2-web-interface/output.log</string>
    </dict>
    </plist>
    EOS
  end
end
