require "formula"

class ImportTools < Formula
  homepage "https://github.com/rhussmann/import-tools"
  url "https://github.com/rhussmann/import-tools/archive/v0.1.tar.gz"
  sha1 "dbc1e6c5e59b6b03a531e5702a9be84bd73bdb43"

  depends_on "rhussmann/graylog2/graylog2-web-interface"
  depends_on "logstash"

  def install
    mv "logstash.conf", "local-logstash.conf"
    inreplace "local-logstash.conf" do |s|
      s.gsub! 'patterns_dir => "./patterns"', "patterns_dir => \"#{prefix}/patterns\""
      s.gsub! "./event_emitter.sh", "#{bin}/event_emitter.sh"
    end

    inreplace "import_logs.sh" do |s|
      s.gsub! " logstash.conf", " #{etc}/local-logstash.conf"
      s.gsub! "logstash agent -f ./logstash.conf", "logstash agent -f #{etc}/local-logstash.conf"
      s.gsub! "./event_emitter.sh", "#{bin}/event_emitter.sh"
    end

    prefix.install Dir['patterns']

    etc.install "local-logstash.conf"
    bin.install "event_emitter.sh"
    bin.install "import_logs.sh"
    bin.install "getAppLogs.sh"
    bin.install "getJettyLogs.sh"
    bin.install "getApacheLogs.sh"
  end
end
