# Branch Ruleset module

Given a repository, this modules creates a [branch ruleset](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets#branch-and-tag-rulesets). This ruleset by default targets the repository default branch, and can be customized with the `target_branches` variable.

The ruleset defaults to required pull request approval with the EBANX default configuration. This module supports setting various required status checks in order to block pull branch merges

## Known Issues

Some issues where found while creating this module, this is a list to help future modules users.

### Status checks `integration_id` inconsistency

As per the [official documentation](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset#integration_id-1):

```markdown
(Optional) (Number) The optional integration ID that this status check must originate from. It's a GitHub App ID, which can be obtained by following instructions from the [Get an App API docs](https://docs.github.com/en/rest/apps/apps?apiVersion=2022-11-28#get-an-app).
```

What both the Terraform doc and the GitHub doc fails to mention is precisely how to get the `integration_id` for different apps.

#### Self developed GitHub apps

For GitHub apps developed by your organization, you can find the `integration_id` by going to your [Org Apps page](https://github.com/organizations/ebanx/settings/apps), clickin the app and copying the `App ID` value.

#### Externally developed GitHub apps

For GitHub apps externally developed, you will need to check the GitHub public API for the app id.

For example, the `Terraform Cloud` [GitHub app](https://github.com/apps/terraform-cloud).

Update the URL replacing ${APP_NAME} by the name of the app you wanna discover the id, replacing spaces with dashes `-`:

```text
https://api.github.com/users/${APP_NAME}[bot]
```

For our example

```text
https://api.github.com/users/terraform-cloud[bot]
```

Access the address on your web browser, you will receive a JSON like the following:

```json
{
  "login": "terraform-cloud[bot]",
  "id": 54418737,
  "node_id": "MDM6Qm90NTQ0MTg3Mzc=",
  "avatar_url": "https://avatars.githubusercontent.com/in/39328?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/terraform-cloud%5Bbot%5D",
  "html_url": "https://github.com/apps/terraform-cloud",
  "followers_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/followers",
  "following_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/following{/other_user}",
  "gists_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/subscriptions",
  "organizations_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/orgs",
  "repos_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/repos",
  "events_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/events{/privacy}",
  "received_events_url": "https://api.github.com/users/terraform-cloud%5Bbot%5D/received_events",
  "type": "Bot",
  "user_view_type": "public",
  "site_admin": false,
  "name": null,
  "company": null,
  "blog": "",
  "location": null,
  "email": null,
  "hireable": null,
  "bio": null,
  "twitter_username": null,
  "public_repos": 0,
  "public_gists": 0,
  "followers": 0,
  "following": 0,
  "created_at": "2019-08-22T20:33:06Z",
  "updated_at": "2019-08-22T20:33:06Z"
}
```

The app id **IS NOT** the `id` field in the json, but rather the number found inside the `avatar_url`

```json
...
"avatar_url": "https://avatars.githubusercontent.com/in/39328?v=4",
...
```

In this case `39328`.

### Bypass actors `actor_type` set to `Team`

When `actor_type` is set to `Team` on the `bypass_actors` config, the `actor_id` must be the internal ID of the GitHub team.

This internal ID can be found by going to

```text
https://github.com/orgs/ebanx/teams/<team-name>
```

Right clicking the avatar image to copy its address.

The copied address will be something along the lines of

```text
https://avatars3.githubusercontent.com/t/1234567?s=280&v=4
```
