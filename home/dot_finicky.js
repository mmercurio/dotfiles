const PERSONAL = "Safari"
const GH = {
  name: "Google Chrome",
  profile: "Profile 1", // on MBP and Air
}

module.exports = {
  defaultBrowser: "Browserosaurus", // "Safari"
  handlers: [
    {
      match: [
        "meet.google.com/*"
      ],
      browser: "Google Chrome"
    },
    {
      match: [
        "*.grubhub.com/*", "grubhub.com/*", "*.ghbeta.com/*",
        "grubhub.okta.com/*",
        "*.thelevelup.com/*", "*.staging-levelup.com/*", "*.sandbox-levelup.com/*",
        "*.heroku.com/*",
        "*.datadoghq.com/*",
        "*.newrelic.com/*",
        "grubhub.pagerduty.com/*",
        "grubhub.1password.com",
        "github.com/TheLevelUp/*", "github.com/GrubhubProd/*",
        "*.github.com/TheLevelUp/*", "*.github.com/GrubhubProd/*",
        "grubhub.slack.com/*",
        "*.amazonaws.com/*",
        "http://127.0.0.1:8000/*",
      ],
      browser: GH,
    },
    {
      match: [
        "github.com/mmercurio/*", "*.github.com/mmercurio/*",
		"*.apple.com/*",
        "*.icloud.com/*",
        "*.cloudspotter.org/*"
      ],
      browser: PERSONAL
    },
    {
      match: [
        "*.youtube.com/*", "youtube.com/*",
        "*.youtu.be/*", "youtu.be/*"
      ],
      browser: "Brave Browser",
    },
    {
      // You can get the path of the process that triggered Finicky
      match: ({ sourceProcessPath }) =>
        sourceProcessPath &&
        (sourceProcessPath.startsWith("/Applications/Zulip.app") ||
        sourceProcessPath.startsWith("/Applications/Slack.app")),
      browser: GH
    },
  ]
}
