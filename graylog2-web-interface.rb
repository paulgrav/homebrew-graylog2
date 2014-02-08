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
end
