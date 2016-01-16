# Upstream Notifier

upstream notifier (`noti`)is a packager helper that sends you email
/shout on IRC about new upstream releases.

# Features

* supports github, sourceforge.net, code.google.com, launchpad.net
  and many more
* easy extendable with ruby (mods)
* supports email and IRC (TODO)

# System Requirement

ruby and nokigiri gem.

# Usage

`noti <config>.json`

# Configuration

<pre>
{
	"fcitx":{
		"name":"fcitx",
		"version":"4.2.8.1",
		"mod":"github",
		"url":"https://github.com/fcitx/fcitx"
		}

}
</pre>

`mod` can be other sources like "github", "sourceforge", "googlecode".

# Mod

To add new mod, you can just place a `<yours>.rb` in /mod.

Make sure it defines a class names "Yours" (first letter capitalized), which provides an initialize(url,version) function and a check function that returns the new release number.

You can reuse any mod that presents, example see mod/fcitx.mod which reused github mod.

# Available Mods

* github
* sourceforge: still needs polishing for some specfial exceptions
* cgit: used for those projects hosting on git.savannah.(non)gnu.org or other scm services powered by cgit like git.kernel.org
* googlecode
* launchpad

***Early Development stage, do not use***
