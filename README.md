# Gradual Black Formatter

A Github Action that gradually applies the Python Black Formatter to your codebase.

## Usage

```yaml
- name: Apply Black Gradually
  uses: rocioar/gradual-black-formatter@v2
  with:
    number_of_files: 10
```