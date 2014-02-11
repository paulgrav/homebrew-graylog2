import-tools
============

This repository is a [homebrew](http://google.com) tap designed to ease the pain
of installing and configuring Graylog2 for local installation.

These forumlae include graylog2, the graylog2 web interface and logstash.
Logstash is used to read archived log4j logs from disk and transport them to
Graylog2 for analysis.

To install graylog2 and the web interface:

1. brew tap rhussmann/graylog2
2. brew install import-tools
3. Run the script below

```
#!/bin/bash

ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
ln -sfv /usr/local/opt/graylog2-server/*.plist ~/Library/LaunchAgents
ln -sfv /usr/local/opt/graylog2-web-interface/*.plist ~/Library/LaunchAgents

launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.graylog2-server.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.graylog2-web-interface.plist

GRAYLOG2_URL="http://admin:root@127.0.0.1:12900"
GRAYLOG2_INPUT_GELF_UDP='
{
      "global": "true",
      "title": "Gelf UDP",
      "configuration": {
        "port": 12201,
        "bind_address": "0.0.0.0"
      },
      "creator_user_id": "admin",
      "type": "org.graylog2.inputs.gelf.udp.GELFUDPInput"
}'

INPUTS=$(curl -X GET -H "Content-Type: application/json" ${GRAYLOG2_URL}/system/inputs 2>/dev/null)

if [ $(echo $INPUTS | grep -c "GELF UDP") != "1" ]; then
        curl -X POST -H "Content-Type: application/json" -d "${GRAYLOG2_INPUT_GELF_UDP}" ${GRAYLOG2_URL}/system/inputs > /dev/null
fi
```

Now, you can use a few built-in scripts to download and analyze logs right on your machine. This guide assumes you're AWS credentials are set as environment variables. For instance, you can use the getAppLogs.sh command to pull class logs from S3 to your machine. First, you must ensure you have a directory carved out.

```
mkdir ~/Downloads/scriptLogs
```

Next, pull down the logs of your choosing:

```
getAppLogs.sh ImportListingStatus 20140211
```

The above command will download all the logs for the ImportListingStatus class for February 11th, 2014. The logs will be save to ~/Downloads/scriptLogs/ImportListingStatus/20140211/.

Finally, you can ingest these logs into Graylog2. Just run:

```
import_logs.sh ~/Downloads/ImportListingStatus/20140211/
```

This script will kick off a logstash job to decompress and import all logs ending in *.log.gz into Graylog2. Watch this process. Due to a bug in logstash, you'll have to kill the process from the command line once you've seen the folling message print __twice__:

```
Running event import script...
```

Now, you can simply hit [http://localhost:9090](http://localhost:9090) and login with username __admin__ and password __root__.
