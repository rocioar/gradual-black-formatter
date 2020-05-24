# Gradual Black Formatter

A Github Action that gradually applies the [Python Black Formatter](https://github.com/psf/black) to your codebase.

It will apply black starting from the least recently changed files.

## Usage

### Setup black

Create a configuration file for your black setup in `pyproject.toml`:

```
[tool.black]
line-length = 120
target_version = ['py38']
```

### Add the action

```yaml
- name: Apply Black Gradually
  uses: rocioar/gradual-black-formatter@v1
  with:
    number_of_files: 10
    ignore_files_regex: test,migrations
```

Parameters:

- **number_of_files**: Using this parameter you can specify on how many files you would like black to be applied.
- **ignore_files_regex**: Using this parameter you can specify filenames that you would like to ignore.

### Example workflow

```yaml
name: Apply Black Gradually

on:
  pull_request:
    types: [closed]

jobs:
  apply-black:
    if: github.head_ref == 'black'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          ref: master
      - name: Apply Black Gradually
        id: black
        uses: rocioar/gradual-black-formatter@v1
        with:
          number_of_files: 3
          ignore_files_regex: test,migrations
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v2
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: Apply black to ${{ steps.black.outputs.number_of_modified_files }} files
          committer: GitHub <noreply@github.com>
          author: ${{ github.actor }} <${{ github.actor }}@users.noreply.github.com>
          title: Apply black to ${{ steps.black.outputs.number_of_modified_files }} files
          body: "Auto-generated PR that applies black to: ${{ steps.black.outputs.modified_file_names }}."
          branch: black
```

To start the workflow above create a Pull Request that adds this action to your project using a specific branch (in this case we are using a branch named `black`). The action will start running once the PR is merged, and will do the following:

1. Run black on the number of files you specified.
2. Create a PR from the `black` branch.
2. Once the PR merged, the Github Action will run again.

Important Note: Once there are no more files to format with black, make sure you disable this action.
