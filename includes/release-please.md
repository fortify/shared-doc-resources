### Conventional commits & versioning

Versioning is handled automatically by [`release-please-action`](https://github.com/google-github-actions/release-please-action) based on [Conventional Commits](https://www.conventionalcommits.org/). Every commit to the `main`
branch should follow the Conventional Commits convention. Following are some examples; these can be combined in a single commit message (separated by empty lines), or you can have commit messages describing just a single fix or feature.

```
chore: Won't show up in changelog

ci: Change to GitHub Actions workflow; won't show up in changelog

docs: Change to documentation; won't show up in changelog

fix: Some fix (#2)

feat: New feature (#3)

feat!: Some feature that breaks backward compatibility

feat: Some feature
  BREAKING-CHANGE: No longer supports xyz
```

See the output of `git log` to view some sample commit messages.

`release-please-action` invoked from the GitHub CI workflow generates pull requests containing updated `CHANGELOG.md` and `version.txt` files based on these commit messages. Merging the pull request will result in a new release version being published; this includes publishing the image to Docker Hub, and creating a GitHub release describing the changes.
