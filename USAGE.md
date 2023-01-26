# Usage

Repositories utilizing the templates and other resources in this repository should have a top-level directory named `doc-resources` containing the following files:

* `developer-info.md`: One or more sections in Markdown format providing information for developers. Usually this includes information on how to build the software, code (style) conventions, architecture, and any other information that may be relevant for people that want to build the project from source and/or contribute to the project. The information can either be embedded in this file, or this file may just provide a link to a Wiki page or GitHub Pages site that provides this information. This file should use second-level headings and below only, as it will be rendered as a subsection in `CONTRIBUTING.md`.
* `template-values.md`: Provides values for template variables, as referenced through `{{var:<name>}}` in the various [templates](templates/). This includes for example the repository/project title and description to be rendered in `README.md`.
* `update-repo-doc-resources.sh`: Bootstrap script that downloads and executes [update-doc-resources.sh](scripts/update-doc-resources.sh)