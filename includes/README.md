# Document Resources Includes

This directory and its sub-directories contains various files that may be included in templates using the `{{include:<file>}}` instruction. Such `include` instructions can be used in templates, and any files included from those templates (recursively). For example, includes can be used in the repository-specific `doc-resources/repo-devinfo.md` file to include standard sections provided in the this directory or any of its sub-directories.

Files in this directory tree should use the following naming convention: `[nocomments.]<type>.<name>.md`, where:

* `nocomments.` is an optional prefix to have this file included without adding the `START-INCLUDE`/`END-INCLUDE` HTML comments, which may be useful for adding plain text contents, or if such comments would break Markdown structure, for example when including partial lists.
* `<type>` provides an indication of the Markdown structure provided by the include:
     * `h1`, `h2`, `h3`, ...: Contents start with a header with the indicated level
     * `p`: Contents are (set of) paragraph(s) and potentially other Markdown structures with no starting header; content like this is usually included in existing sections
     * `li`: Contents provide a (potentially partial) list
* `<name>` provides a descriptive name for the contents.

Given that includes are processed recursively, the include files in this directory can potentially include other files, which may be useful to provide the same section contents but with different header levels. For example, we could potentially have the following include files:
* `devinfo/p.gradle-wrapper.md`: Defines information about Gradle Wrapper, without section heading
* `devinfo/h3.gradle-wrapper.md`: Contains `### Gradle Wrapper`, followed by `{{include:devinfo/p.gradle-wrapper.md}}`
* `devinfo/h4.gradle-wrapper.md`: Contains `#### Gradle Wrapper`, followed by `{{include:devinfo/p.gradle-wrapper.md}}`

As includes are (usually) loaded from a remote location, this approach will affect performance of the `update-doc-resources.sh` script, so this pattern should only be applied if there is a need to insert text with different (or no) header levels.
