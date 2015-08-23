# Upstream Notifier

upstream notifier is a packager helper that sends you email
/ping on IRC about new upstream releases.

# Features

* supports github, sourceforge.net, code.google.com, launchpad.net
  and many more
* easy extendable with ruby (mods)
* supports email and IRC (TODO)

# Configuration

<pre>
{
	"fcitx":{
		"name":"fcitx",
		"version":"4.2.8.1",
		"catag":"github",
		"url":"https://github.com/fcitx/fcitx"
		}

}
</pre>

`catag` can be other sources like "googlecode", "sourceforge" (currently only github is supported).

***Early Development stage, do not use***
