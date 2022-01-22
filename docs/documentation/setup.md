# Adding documentation

Docs are handled via MkDocs, install python.

1) Create a file `./requirements.docs.txt`

```text
# Documentation static site generator & deployment tool
mkdocs>=1.1.2

# Add your custom theme if not inside a theme_dir
# (https://github.com/mkdocs/mkdocs/wiki/MkDocs-Themes)
mkdocs-material>=5.4.0
```

2) Install deps

```commandline
pip install -r requirements.docs.txt
```

3) Add `./gitlab-ci.yml` settings (create if not there)

```yaml
include:
  - template: Auto-DevOps.gitlab-ci.yml

test:
  image: python:3.8-buster
  before_script:
    - pip install -r requirements.docs.txt
  stage: test
  script:
  - mkdocs build --strict --verbose --site-dir test
  artifacts:
    paths:
    - test

pages:
  image: python:3.8-buster
  before_script:
    - pip install -r requirements.docs.txt

  stage: deploy
  script:
  - mkdocs build --strict --verbose
  artifacts:
    paths:
    - public
  only:
  - master
  - develop
```

4) add `./mkdocs.yml`

```yaml
site_name: Lethean Develop Docs
site_url: https://lethean.dev
site_dir: public
copyright:
theme:
  name: material
  custom_dir: docs/overrides
  favicon: images/favicon.ico
  features:
    - toc.integrate
  palette:
    # Light mode
    - media: "(prefers-color-scheme: light)"
      scheme: lethean
      primary: indigo
      accent: indigo
      toggle:
        icon: material/toggle-switch-off-outline
        name: Switch to dark mode

    # Dark mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: blue
      accent: blue
      toggle:
        icon: material/toggle-switch
        name: Switch to light mode
extra:
  generator: false
  social:
    - icon: fontawesome/brands/twitter
      link: https://twitter.com/letheanvpn
    - icon: fontawesome/brands/github
      link: https://github.com/LetheanMovement
    - icon: fontawesome/brands/gitlab
      link: https://gitlab.com/lethean.io
extra_css:
  - stylesheets/extra.css
markdown_extensions:
  - meta
  - toc:
      permalink: true
```

5) add `docs` folder with css file `./docs/stylesheets/extra.css`

```css
[data-md-color-scheme="lethean"] {
  --md-primary-fg-color:        #0F131C;
}

```

6) make the first file `./docs/index.md`

```markdown
---
title: PAGE TITLE
description: PAGE META / EMBED DESCRIPTION
---

# Docker Commands

`docker pull lthn/build`

In Dockerfile add this as your base image to a multi-stage build

```

7) run and enjoy hot reload

```commandline
mkdocs serve
```

When you are happy commit and it will build and deploy on master/develop, when you are
happy just remove the develop tag and make sure the DNS is sorted for the `*.lethean.help` page