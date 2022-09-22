# Python_Project_Template



## Guidelines
Guidelines for configuring your development Python toolchain, Python projects, etc.  

1. Install pyenv and poetry  
* For mac users, installing pyenv on top of system's python3 will likely break your python setup. Uninstall all versions of python3 in your system (e.g., brew uninstall python@3.x, replace 3.x with appropriate version) before installing pyenv. You may also need to uninstall some dependencies on python3 like awscli and aws-okta-processor. You can reinstall these once you have pyenv installed.
* For all users, installing pyenv will likely break all your existing virtualenvs installed with system python. Remake those virtualenvs by using a pyenv version of python if the repo is not using poetry.
  * Pyenv: https://github.com/pyenv/pyenv#installation
  * Poetry: https://python-poetry.org/docs/#installation
* Once you've installed Poetry, make sure you have the latest stable version (and not a preview or beta version) by running:
```angular2html
poetry --version
```

2. Configure poetry  
* Configure `poetry` to use artifactory credentials if needed.
```angular2html
poetry config http-basic.artifactory <READ-ONLY-USERNAME> <READ-ONLY-PASSWORD>
```
* If for any reasons, `poetry config ...` command above fails, you may alternatively set the username and password for Artifactory using environment variables:
```angular2html
export POETRY_HTTP_BASIC_ARTIFACTORY_USERNAME=<READ-ONLY-USERNAME>
export POETRY_HTTP_BASIC_ARTIFACTORY_PASSWORD=<READ-ONLY-PASSWORD>
```

3. Should I create virtualenvs?  
* NO. Poetry takes care of creating virtualenvs and installing dependencies using the configuration in [pyproject.toml](https://python-poetry.org/docs/pyproject/).  
* Install the appropriate python version and dependencies with:
```angular2html
pyenv install <python-version>
poetry install
```
* Any command you run in a virtualenv needs to be prefixed with `poetry run`.
```angular2html
# Example
poetry run nosetests
poetry run main.py --some-arg
```
* Alternatively, you can avoid typing `poetry run` on every command by opening up a shell with a virtualenv.
```angular2html
poetry shell
nosetests
main.py --some-arg
exit
```
* NOTE: Use `exit` over deactivate as `deactivate` doesn't terminate the poetry shell properly.

4. Manage requirements
* Always add requirements using `poetry add`:
```angular2html
poetry add <my-dependency>
poetry add <my-dev-dependency> --dev
```

5. Publish packages with [twine](https://twine.readthedocs.io/en/latest/)



## Example Python Project
A template for creating a Python project and package that includes:

* Dependency management, packaging, and environment management using [Poetry](https://python-poetry.org/)
* Starter README.md
* Continuous integration (linting, testing, coverage, ...)
* Continuous deployment (automatic publishing to Artifactory, working around several issues)

You need to configure Poetry to access artifactory if needed. Refer to the step above.

1. Descriptions
* **Dockerfile** - builds development environment
* **Jenkinsfile** - lints, tests, and publishes to Artifactory PyPI
* **pyproject.toml** - config file to store build system requirements including dependencies ([Poetry Doc](https://python-poetry.org/docs/pyproject/))
* **setup.cfg** - flake8 linter configuration
* **src/** - src package code
* **example.csv** - an example of packaging a non python file. Inclusion is specified in the pyproject.toml `include` field

2. Enabling GitHub Branch Protection Rules  
* It may be beneficial to require PR approvals or status checks (e.g., lint & test) to pass before PRs can be merged to the default branch. For your repo, navigate to `Settings` -> `Branches` -> `Add rule` and select the desired requirements.

* Recommended Branch Protection Rules
- [x] **Require pull request reviews before merging**
- [x] **Require status checks to pass before merging**
  - [x] Build image
  - [x] Lint
  - [x] Prepare workspace
  - [ ] Publish
  - [x] Unit test
  - [ ] continuous-integration/jenkins/branchRequired
  - [x] continuous-integration/jenkins/pr-merge

3. Sample README.md for your-project  
* Using
```angular2html
poetry add your-project
```
* API Specification for your-project  
It is highly recomended to outline the interface for utilizing your package.
* Developing
```angular2html
poetry install
```
* Scripts  
A number of common checks and tools have been wired up with poetry scripts. Here are some examples:  
  * Linting
  ```angular2html
  poetry run lint  # will run the linter checks configured for this project
  ```
  * Testing 
  ```angular2html
  poetry run test  # run unit tests uning the testing framworks configured for this project
  ```
  * Format checking
  ```angular2html
  poetry run format  # run a format checker configured for this project.
  ```
  * Type checking
  ```angular2html
  poetry run type_check  # run type check configured for this project.
  ```
  * All checks
  ```angular2html
  poetry run qa  # run all checks
  ```
* Publishing  
Publish by bumping the `version` in [pyproject.toml](pyproject.toml) and
committing to master (*e.g.*, via a PR merge).
  