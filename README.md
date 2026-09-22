# Shared Documentation Resources

This repository is an internal resource bundle for OpenText Fortify repositories. It contains shared documentation templates, includes, static files, and setup scripts used by other repositories to generate their own standard documentation.

This repository is meant to be resources-only. Its own top-level documentation is maintained by hand; it does not use the shared generation workflow that it provides to downstream repositories.

## Repository Contents

* [templates](templates) contains the shared document templates, such as README, usage, contributing, code of conduct, and license templates.
* [includes](includes) contains reusable Markdown fragments that templates or repository-specific docs can include.
* [scripts](scripts) contains the document generation script used by downstream repositories.
* [setup](setup) contains bootstrap files copied into downstream repositories.
* [static](static) contains static shared assets.

## Usage

Run one of the setup scripts from the root of a downstream repository.

For GitHub-hosted repositories, install the local `doc-resources` files and the GitHub Actions workflow that keeps generated docs current:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup-github.sh)
```

For repositories that should not receive the GitHub Actions workflow, install only the local `doc-resources` files:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup.sh)
```

The setup scripts create a `doc-resources` directory in the downstream repository. The GitHub setup also creates `.github/workflows/update-repo-docs.yml` and pins it to the current `fortify/shared-github` workflow commit.

## Downstream `doc-resources`

The generated `doc-resources` directory is owned by the downstream repository and should be edited there. These files drive the generated top-level docs in that repository:

* `template-values.md` defines values used by `{{var:<name>}}` references in templates, includes, and local resources.
* `repo-intro.md` provides introductory README content.
* `repo-resources.md` lists useful repository resources for the README.
* `repo-usage.md` provides the content rendered into `USAGE.md`.
* `repo-devinfo.md` provides contributor/developer information rendered into `CONTRIBUTING.md`.
* `update-repo-docs.sh` runs the document generator.

Before first running `doc-resources/update-repo-docs.sh` in a downstream repository, move any existing README, usage, contributing, or related content into the appropriate `doc-resources` files. The generator overwrites its target top-level docs.

## Includes And Variables

Templates and Markdown resources can use include directives on a line by themselves:

```markdown
{{include:usage/h1.standard-parser-usage.md}}
```

Included files are resolved from the downstream repository's `doc-resources` directory first, then from this repository's shared `includes` directory. Includes may include other files recursively.

Templates and Markdown resources can also use variable references:

```markdown
{{var:repo-title}}
```

Variables are defined as headings in `doc-resources/template-values.md`. Repository-specific variables override built-in variables such as `current-year` and `copyright-years`.

## Pinning Model

The reusable GitHub Actions workflow in `fortify/shared-github` pins the shared documentation resources it consumes through `pins/shared-doc-resources.sha`. The local `doc-resources/update-repo-docs.sh` wrapper resolves and uses that same pin instead of fetching this repository's `main` branch directly.

The GitHub setup script pins downstream repositories to the current `fortify/shared-github` workflow SHA. The local wrapper intentionally does not pin `SHARED_GITHUB_REF` in the installed script, because the shared workflow pin updater only maintains workflow files. Local runs use the pin from `fortify/shared-github` `main` unless `SHARED_GITHUB_REF` or `SHARED_DOC_RESOURCES_REF` is set explicitly.

## Maintaining This Repository

Keep this repository focused on reusable documentation resources. Do not add a root `.github` workflow directory or a root `doc-resources` directory for this repository itself; those are downstream-consumer artifacts.

When changing templates or includes that duplicate content maintained elsewhere, update the corresponding source at the same time. In particular, code-of-conduct and organization-level profile content may also live in the Fortify organization community-health repository: https://github.com/fortify/.github.
