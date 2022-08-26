const GH = "Microsoft Edge"
const PERSONAL = "Safari"

module.exports = {
  defaultBrowser: "Browserosaurus", // "Safari"
  handlers: [
    {
      match: [
        "*.grubhub.com*", "grubhub.com*",
        "*.thelevelup.com/*", "*.staging-levelup.com/*",
        "*.heroku.com/*",
        "*.datadoghq.com/*",
        "*.newrelic.com/*",
        "*github.com/TheLevelUp/*", "*github.com/GrubHubProd/*",
        "grubhub.okta.com",
        "levelup.atlassian.net/*"
      ],
      browser: GH
    },
    {
      match: [
        "*github.com/mmercurio/*",
        "*.icloud.com*",
        "*.cloudspotter.org*"
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
