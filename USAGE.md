# Usage

The files in this repository allow for automatically generating and updating common documentation files like README.md and LICENSE.txt. Repositories utilizing these templates should have a top-level directory named `doc-resources` containing the following files:

* `developer-info.md`: Zero or more sections in Markdown format providing information for developers. Usually this includes information on how to build the software, code (style) conventions, architecture, and any other information that may be relevant for people that want to build the project from source and/or contribute to the project. The information can either be embedded in this file, or this file may just provide a link to a Wiki page or GitHub Pages site that provides this information. This file should use second-level headings and below only, as it will be rendered as a subsection in `CONTRIBUTING.md`.
* `template-values.md`: Provides values for template variables, as referenced through `{{var:<name>}}` in the various [templates](https://github.com/fortify/shared-doc-resources/tree/main/templates). This includes for example the repository URL, project title and project description to be rendered in `README.md`.
* `update-repo-doc-resources.sh`: Bootstrap script that sets the SCRIPT_DIR variable and then downloads and executes https://github.com/fortify/shared-doc-resources/blob/main/scripts/update-doc-resources.sh.

Examples of these files can be found at https://github.com/fortify/shared-doc-resources/tree/main/doc-resources, or the same directory in any other repository that utilizes these templates. Once you have added these files to your repository, you can simply run `bash doc-resources/update-repo-doc-resources.sh` to generate or update the templates documentation resources. 

Although you can run the script manually, it is (also) recommended to set up a GitHub Actions workflow to automatically update the documentation resources; usually this workflow would be triggered on every push (to the main branch or any branch) and on a scheduled basis, and could also be triggered manually. This will make sure that documentation resources will be properly updated whenever you make any changes to `template-values.md` or `developer-info.md`, and also that these documentation resources stay in sync with the templates even if you are not actively committing code to the repository. A sample workflow can be found here: https://github.com/fortify/shared-doc-resources/blob/main/.github/workflows/update-doc-resources.yml.

Note that usage documentation is not included with the templates, as usage documentation will vary from project to project. You should either have a `USAGE.md` file in your repository to describe software usage, or host usage documentation elsewhere, for example in the project Wiki or on a GitHub Pages site. Please make sure to include a link to the usage documentation in the `# resources` section in `template-values.md`.



