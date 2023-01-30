
<!-- START-INCLUDE:repo-usage.md -->

# Shared Documentation Resources - Usage Instructions

The files in this repository allow for automatically generating and updating common documentation files like README.md and LICENSE.txt. To start using the templates from this repository, you can run one of the following commands from your top-level repository clone directory:

* Install required files and a sample GitHub workflow for automatically updating documents:
     * `bash <(curl -sL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup-github.sh)`
* Install required files only:
     * `bash <(curl -sL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup.sh)`

After running these scripts, a `doc-resources` directory should have been created with the following files:

* `repo-devinfo.md`: Zero or more sections in Markdown format providing information for developers. Usually this includes information on how to build the software, code (style) conventions, architecture, and any other information that may be relevant for people that want to build the project from source and/or contribute to the project. The information can either be embedded in this file, or this file may just provide a link to a Wiki page or GitHub Pages site that provides this information. This file should use second-level headings and below only, as it will be rendered as a subsection in `CONTRIBUTING.md`.
* `repo-intro.md`: One or more sections in Markdown format providing an introductory description of the repository, which will be rendered in the introductory section in `README.md` under the main (1<sup>st</sup>-level) heading.
* `repo-resources.md`: Markdown-formatted list of useful project resources that will be rendered in the *Resources* secion in `README.md`. This should usually start with a link to the usage instructions, which can be either USAGE.md or a link to usage documentation on a Wiki or GitHub Pages site, followed by one or more links where project releases can be found (GitHub Releases page, Docker repositories, ...), followed by any other useful project resources. Optional but recommended, the list can be immediately followed by an `{{include:nocomments.li.standard-resources.md}}` instruction (on a separate line) to render links to standard resources like `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` and `LICENSE.txt` (note that this doesn't include `USAGE.md`, as some repositories may have the primary usage documentation hosted elsewhere).
* `repo-usage.md`: Contents are rendered as `USAGE.md`; this document can either provide full usage instructions, or simply provide a link to usage documentation on Wiki or GitHub Pages site.
* `template-values.md`: Provides values for template variables, as referenced through `{{var:<name>}}` in the various [templates](https://github.com/fortify/shared-doc-resources/tree/main/templates). This includes for example the repository title and URL to be rendered in `README.md`.
* `update-repo-docs.sh`: Bootstrap script that downloads and executes https://github.com/fortify/shared-doc-resources/blob/main/scripts/update-doc-resources.sh.

Each of the Markdown files listed above may include `{{var:<name>}}` instructions to render variables from `template-values.md`, and `{{include:<include-file>}}` to include the contents from other files in either the the repo-specific `doc-resources` directory or the shared include files available at https://github.com/fortify/shared-doc-resources/tree/main/includes. `{{include:<include-file>}}` instructions must be on their own line with no other text.

Once you have added these files to your repository, you can simply run `doc-resources/update-repo-docs.sh` to generate or update the templates documentation resources. 

Although you can run the script manually, it is (also) recommended to set up a GitHub Actions workflow to automatically update the documentation resources; usually this workflow would be triggered on every push (to the main branch or any branch) and on a scheduled basis, and could also be triggered manually. This will make sure that documentation resources will be properly updated whenever you make any changes to `template-values.md` or `developer-info.md`, and also that these documentation resources stay in sync with the templates even if you are not actively committing code to the repository. A sample workflow can be found here: https://github.com/fortify/shared-doc-resources/blob/main/.github/workflows/update-doc-resources.yml.

Note that for projects that include some of the generated files in release artifacts, like LICENSE.txt or USAGE.md, you must ensure that the `update-repo-docs.sh` script is being run before your build script processes these generated files, in order to make sure that the files are up to date. For example, you can run the script before invoking your build script in your release pipeline.

<!-- END-INCLUDE:repo-usage.md -->


---

*This document was auto-generated from USAGE.template.md; do not edit by hand*
