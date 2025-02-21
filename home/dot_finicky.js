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
        "github.com/TheLevelUp/*", "github.com/GrubHubProd/*",
        "*.github.com/TheLevelUp/*", "*.github.com/GrubHubProd/*",
        "grubhub.slack.com/*",
        "*.amazonaws.com/*"
      ],
      browser: GH,
    },
    {
      match: [
        "github.com/mmercurio/*", "*.github.com/mmercurio/*",
		"*.apple.com/*"
        "*.icloud.com/*",
        "*.cloudspotter.org/*"
      ],
      browser: PERSONAL
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
