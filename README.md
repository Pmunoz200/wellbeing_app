# gemini_folder

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Configure git hooks
 ## Repository with needed instructions and files to enable git hooks for commits

## Set up for <u>development 🧑‍💻</u>

### 1. Set up the global Python virtual environment
1. `python3.10 -m venv venv`
2. `source venv/bin/activate`
3. `pip install -r requirements-dev.txt`
4. `pre-commit install`

This adds automatic code formatting for Python (with Black) and JavaScript (with Prettier) files before committing (that is, when you run `git commit ...` first it runs the pre-commit linting hook, then if it doesn't fail it commits. If it fails and fixes the files, you have to re-add and re-commit the files after checking them).
- to make Black [ignore](https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html#code-style)
  - a line -> append `# fmt: skip`
  - a code block -> write it between `# fmt: off` and `# fmt: on`
- to make Prettier [ignore](https://prettier.io/docs/en/ignore.html)
  - a line or a scope -> prepend `// prettier-ignore`