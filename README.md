Upstream Notifier

------

[![Code Climate](https://codeclimate.com/github/marguerite/upstream-notifier/badges/gpa.svg)](https://codeclimate.com/github/marguerite/upstream-notifier)

upstream notifier is a monitoring server for packagers, usually running on a Rapsberry Pi.

It will sends you email / shout on IRC about new upstream releases.

## Features

* supports github, sourceforge.net, code.google.com, launchpad.net
  and many more
* easy extendable with a plugin system
* supports email and IRC

# Configuration with YAML

<pre>
---
fcitx:
  version: 4.2.8.1
  plugin: github
  url: fcitx/fcitx
  notifier: irc
  maintainer: marguerite
</pre>

`plug` can be other services like "github", "sourceforge", "googlecode".

# Options

# Plugin

To add new plugin, you can just place a `<your_service>.rb` in `/lib/upstream_notifier/plug`.

Make sure it defines a class named "Your_service" (first letter capitalized), which provides an initialize function with parameters `url,version,*args` and a `get` function that returns the new release number.

You can reuse any plugin that presents, example see our fcitx plugin which reused the github plugin.

# Available Plugins

* github
* sourceforge
* cgit: used for those projects hosting on git.savannah.(non)gnu.org or other scm services powered by cgit like git.kernel.org
* googlecode: needed rewriting with headless chromium
* launchpad
* cpan
* pypi
* rubygems
* npm
* nodejs
* golangorg
