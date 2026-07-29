# Service Catalog

## Requirements

### Github CLI

Installing:

MacOS:

```sh
brew install gh
```

Login to GitHubCLI with necessary scopes:

```sh
 gh auth login --hostname github.com --git-protocol https --scopes user:email,read:user --web
```

## Future improvements

1. Store `.tfstate` on S3
1. Make project compatible with Atlantis
1. Check if a GitHub App would be able to perform all actions on this terraform
