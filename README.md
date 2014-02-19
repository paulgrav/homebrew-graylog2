rhussmann/homebrew-graylog2 tap for Homebrew
============================================

This repository is a [homebrew](http://brew.sh) tap for tracking more recent
versions of the [Graylog2](http://graylog2.org) distributed logging system.

These forumlae included in this tap are graylog2-server and
graylog2-web-interface.

graylog2-server is a dependency of graylog2-web-interface, so installing
graylog2-web-interface from this tap is sufficient to install both formulae.

To install formulae from this repo, you'll need to tap it as a keg:

```
brew tap rhussmann/graylog2
```

You can install graylog2-server by itself,

```
brew install rhussmann/graylog2/graylog2-server
```

or you can install graylog2-web-interface to install them both
```
brew install graylog2-web-interface
```

I would recommend installing the launchd scripts for both graylog2-server
and graylog2-web-interface

```
ln -sfv /usr/local/opt/graylog2-server/*.plist ~/Library/LaunchAgents
ln -sfv /usr/local/opt/graylog2-web-interface/*.plist ~/Library/LaunchAgents
```

You can then start the server and web interface using launchd

```
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.graylog2-server.plist
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.graylog2-web-interface.plist
```

and stop them as well

```
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.graylog2-server.plist
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.graylog2-web-interface.plist
```
