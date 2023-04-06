
<!-- START-INCLUDE:repo-usage.md -->

# Shared Documentation Resources - Usage Instructions


<!-- START-INCLUDE:repo-purpose.md -->

The files in this repository are meant to be used for repositories owned by OpenText Fortify. Its main purposes are as follows:

* Ensure that every repository (that utilizes shared-doc-resources) contains a standard set of documentation files, like README.md, LICENSE.txt, USAGE.md, ...
* Ensure consistent documentation contents, like having the same support statement and marketing intro in every repository.

<!-- END-INCLUDE:repo-purpose.md -->


The standard documentation files are generated from the following documentation resources:

* [Shared Templates](https://github.com/fortify/shared-doc-resources/tree/main/templates) defining the overall structure and common contents for generated documentation files.
* [Shared Includes](https://github.com/fortify/shared-doc-resources/tree/main/includes), which can be included from either the shared templates or repository-specific documentation resources.
* Repository-specific documentation resources stored in a `doc-resources` directory in the repository, which get included into the shared templates.


## Initial Setup

To start using the templates from this repository, you can run one of the following commands from your top-level repository clone directory:

* Install required files and a GitHub Actions workflow for automatically updating documents (recommended for repositories stored on GitHub):
     * `bash <(curl -sL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup-github.sh)`
* Install required files only:
     * `bash <(curl -sL https://raw.githubusercontent.com/fortify/shared-doc-resources/main/setup/setup.sh)`

After running one of these scripts, a `doc-resources` directory should have been created containing various files as described in the sections below. The GitHub-specific script will also create a `.github/workflows/update-repo-docs.sh` workflow.

## `doc-resources/update-repo-docs.sh`

This script is responsible for generating and updating standard documentation files like `README.md`, `LICENSE.txt` and `USAGE.md`. Note that this script will overwrite any existing documentation files without warning. Before running this script for the first time, it is mandatory to update all of the Markdown files in the `doc-resources` directory (see next section). This includes moving any information from existing documentation files like `README.md` or `USAGE.md` to the appropriate files in the `doc-resources` directory, to avoid this information from being lost when the script overwrites those existing files.

If you also installed the GitHub Actions workflow (see [Initial Setup](#initial-setup) section), then this workflow will automatically run the `update-repo-docs.sh` script both on pushes and on a scheduled basis. If any changes are detected in either shared or local documentation resources, this workflow will generate a Pull Request containing updated documentation files.

This automated workflow is mostly meant for automatically applying upstream changes, i.e., for updating documentation in individual repositories after resources in the `shared-doc-resources` repository have been updated. When updating documentation in a repository's `doc-resources` directory, it is recommended to run the script manually before committing the changes to have a single commit containing both the updated files in the `doc-resources` directory and the updated documentation that was generated from these updated `doc-resources` files, rather than having the GitHub Actions workflow generate a PR to apply those changes to the generated documentation files.

## `doc-resources/*.md`

Apart from the `update-repo-docs.sh` script discussed in the previous section, the setup scripts also install the Markdown files listed below. Each of these files is required for proper documentation generation, but where applicable, files may be empty. For example, if there is no information for developers, then `repo-devinfo.md` may be empty (but should not be removed).

Some includes may require additional files to be present in the `doc-resources` directory. For example, if your `repo-usage.md` contains an `{{include:usage/h1.standard-parser-usage.md}}` directive, then your repository will also need to have a file named `parser-obtain-results.md` in the `doc-resources` directory. See sections below for more information about `include` directives.

Following is the list of Markdown files that should always be present in the `doc-resources` directory:

* `template-values.md`
     * Provides values for template variables as referenced through `{{var:<name>}}` in the [shared templates](https://github.com/fortify/shared-doc-resources/tree/main/templates), [shared includes](https://github.com/fortify/shared-doc-resources/tree/main/includes) or local `doc-resources` files; see [Variable References](#variable-references) section for details.
     * Variable definitions in `template-values.md` are represented as Markdown sections, i.e.:
     
           # <variable-name>
           <variable contents>
         
         
* `repo-devinfo.md`
     * Zero or more sections in Markdown format providing information for developers.
     * Usually this includes information on how to build the software, code (style) conventions, architecture, and any other information that may be relevant for people that want to build the project from source and/or contribute to the project. 
     * The information can either be embedded in this file, or this file may just provide a link to a Wiki page or GitHub Pages site that provides this information. 
     * This file should use second-level headings and below only, as it will be rendered as a subsection in `CONTRIBUTING.md`.
     
* `repo-intro.md`
     * One or more sections in Markdown format providing an introductory description of the repository
     * Will be rendered in the introductory section in `README.md` under the main (1<sup>st</sup>-level) heading, and may optionally be repeated in the introductory section in `USAGE.md`.
     
* `repo-resources.md`
     * Markdown-formatted list of useful project resources.
     * Should usually start with a link to the usage instructions, which can be either USAGE.md or a link to usage documentation on a Wiki or GitHub Pages site, followed by one or more links where project releases can be found (GitHub Releases page, Docker repositories, ...), followed by any other useful project resources.
     * Optional but recommended, the list can be immediately followed by an `{{include:resources/nocomments.li.contrib-conduct-licence.md}}` instruction (on a separate line) to render links to standard resources like `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` and `LICENSE.txt` (note that this doesn't include `USAGE.md`, as some repositories may have the primary usage documentation hosted elsewhere).
     * Will be rendered in the *Resources* section in `README.md`.
      
* `repo-usage.md`
     * One or more sections in Markdown format providing usage instructions for end users.
     * Either provide full usage instructions, or a link to usage instructions hosted elsewhere like GitHub Pages site or Wiki.
     * Contents are rendered as `USAGE.md`.

### Include Directives

Each of the Markdown files in the `doc-resources` directory (as well as [shared templates](https://github.com/fortify/shared-doc-resources/tree/main/templates) and [shared includes](https://github.com/fortify/shared-doc-resources/tree/main/includes)) may contain `{{include:<include-file>}}` directives to include the contents from other Markdown files. 

The files to be included may be located in either the repository-specific `doc-resources` directory, or available online in the [shared includes](https://github.com/fortify/shared-doc-resources/tree/main/includes) directory. If a file specified in an `include` directive cannot be located in either of these locations, documentation generation will be aborted with an error.

The `{{include:<include-file>}}` directives must be on their own line with no other text, and are evaluated recursively, allowing included files to contain `include` directives themselves. For example:

* [USAGE.template.md](https://github.com/fortify/shared-doc-resources/blob/main/templates/USAGE.template.md) includes `repo-usage.md` (usually located in the repo-specific `doc-resources` directory).
* `repo-usage.md` may include [usage/h1.standard-parser-usage.md](https://github.com/fortify/shared-doc-resources/blob/main/includes/usage/h1.standard-parser-usage.md), providing standard SSC parser plugin usage instructions.
* [usage/h1.standard-parser-usage.md](https://github.com/fortify/shared-doc-resources/blob/main/includes/usage/h1.standard-parser-usage.md) includes `parser-obtain-results.md` (usually located in the repo-specific `doc-resources` directory), providing parser-specific instructions on how to obtain results.


### Variable References

Each of the Markdown files in the `doc-resources` directory (as well as [shared templates](https://github.com/fortify/shared-doc-resources/tree/main/templates) and [shared includes](https://github.com/fortify/shared-doc-resources/tree/main/includes)) may contain `{{var:<name>}}` instructions to render variable contents. 

There are two types of variables; built-in variables and repository-specific variables listed in `doc-resources/template-values.md`. Repository-specific variables take precedence over built-in variables. Variable references are expanded in-line and are expanded recursively, so one variable may contain a reference to another variable. References to non-existing variables will result in documentation generation being aborted with an error.

Following is an overview of common variables:

* `repo-title`
     * Human-readable repository title
     * Referenced from various templates and includes to generate document/section titles and contents
     * Must be defined in `template-values.md`

* `repo-url`
     * Repository URL, i.e. `https://github.com/fortify/<repo-name>`
     * Referenced from various templates and includes to generate repository-specific links
     * Must be defined in `template-values.md`

* `copyright-years`
     * Year range for copyright statement(s), i.e. `2021-2023`
     * Referenced from: [LICENSE.MIT.template.txt](https://github.com/fortify/shared-doc-resources/blob/main/templates/LICENSE.MIT.template.txt)
     * Default value: `2023`, i.e. `2023`
     * Should be overridden in `template-values.md` with `<first year>-2023`, i.e. `2022-2023`, which would eventually be rendered as `2022-2024` if current year is 2024

* `current-year`
     * Current year, i.e. '2023'
     * Built-in variable
     * Referenced from `copyright-years` variable

* `engine-type`
     * SSC parser plugin engine type, i.e. `DEBRICKED`
     * Only applicable for repositories containing SSC parser plugins
     * Referenced from: [usage/h1.standard-parser-usage.md](https://github.com/fortify/shared-doc-resources/blob/main/includes/usage/h1.standard-parser-usage.md), which is usually included from `doc-resources/repo-usage.md`
     
Apart from these standard variables, Markdown files in the `doc-resources` directory may reference any custom variables, as long as the appropriate variable value is defined in `template-values.md`.

<!-- END-INCLUDE:repo-usage.md -->


---

*This document was auto-generated from USAGE.template.md; do not edit by hand*
