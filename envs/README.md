# Flatland Environments

When environments are created, they are saved in three separate formats:
* an image, `.png`
* a clingo facts file, `.lp`
* a metadata file, `.pkl`

The image exists simply as a visual aid, to understand the qualities of the environment. The clingo facts file exists for development of an ASP encoding. The metadata file contains all of the necessary information for formulating a final plan and visualization in Flatland.

These formats are saved in separate folders, but identical environments share the same base name - for instance, `env_10.png` is a visual representation of the facts in `env_10.lp`, unless the files are manually and incorrectly renamed.
