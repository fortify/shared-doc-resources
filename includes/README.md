# Document Resources Includes

This directory and its sub-directories contains various files that may be included in templates using the `{{include:<file>}}` instruction. Such `include` instructions can be used in templates, and any files included from those templates (recursively). For example, includes can be used in the repository-specific `doc-resources/developer-info.md` file to include standard sections provided in this directory.

Files in this directory should use the following naming convention: `<header-level>.<name>.md`, where `<header-level>` corresponds to the header level provided in the include file, and `<name>` describes the contents of the include file. For example, if an include file starts with a 3<sup>rd</sup>-level section heading (identified by `###`), the file should be named `h3.<name>.md`. If an include file doesn't have a section heading (allowing text to be inserted in an existing section), it should be named `p.<name>.md` (`p` for paragraph).

Given that includes are processed recursively, the include files in this directory can potentially include other files, which may be useful to provide the same section contents but with different header levels. For example, we could potentially have the following include files:
* `p.gradle-wrapper.md`: Defines information about Gradle Wrapper, without section heading
* `h3.gradle-wrapper.md`: Contains `### Gradle Wrapper`, followed by `{{include:p.gradle-wrapper.md}}`
* `h4.gradle-wrapper.md`: Contains `#### Gradle Wrapper`, followed by `{{include:p.gradle-wrapper.md}}`

As includes are (usually) loaded from a remote location, this approach will affect performance of the `update-doc-resources.sh` script, so this pattern should only be applied if there is a need to insert text with different (or no) header levels.
