[![tests](https://github.com/tyler36/ddev-locale/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-locale/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

# ddev-locale <!-- omit in toc -->

- [What is ddev-locale?](#what-is-ddev-locale)
- [Why ddev-locale?](#why-ddev-locale)
- [Getting started](#getting-started)
- [Configuration](#configuration)
  - [Change timezone](#change-timezone)
  - [Change locale](#change-locale)
- [Components of the repository](#components-of-the-repository)
- [How to debug tests (Github Actions)](#how-to-debug-tests-github-actions)
- [Contributing](#contributing)

## What is ddev-locale?

DDEV-locale is design to setup the DDEV web container for a specific locale.
In additional, it serves as documentation for DDEV internationalization.

DDEV has 2 related locale settings:

- timezone.
- system locale.

This addon, by default, sets both of these to Japan (Japanese).
Why Japan? Japan has a single timezone and a single encoding locale. It is also where my team is based.

## Why ddev-locale?

DDEV allows encoding to be set globally (via `web-environment`).
Timezone, however, is a per-project setting.

As of writing, DDEV includes all language files which significantly inflates the web server container size.
If/when the language files are removed, this addon will be updated to install the language pack.

## Getting started

1. Install this addon.

    ```shell
    ddev addon get tyler36/ddev-locale
    ddev restart
    ```

## Configuration

To change either setting, you need to update `.ddev/config.locale.yaml`.

1. Remove `## ddev-generated` from the file. This will prevent DDEV from updating it.

### Change timezone

1. To change timezones, update the `timezone` line with the TZ identifier for your desired location.
    See [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

### Change locale

1. To update the language, update the `web_environment` line.

This contains up to 3 parts:

- Language code (<https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes>).
- Territory code (<https://en.wikipedia.org/wiki/ISO_3166-1#Codes>). Separate from language with `_`.

A 3rd code-set value (separated with `.`) is optional.

For example: `LANG=en_AU.UTF-8`

- English language.
- Australian territory.
- `UTF-8` code-set.


## Components of the repository

- `config.locale.yaml`: the settings that are merging with the project's configuration.
- An [install.yaml](install.yaml) file that describes how to install the service or other component.
- A test suite in [test.bats](tests/test.bats) that makes sure the service continues to work as expected.
- [Github actions setup](.github/workflows/tests.yml) so that the tests run automatically when you push to the repository.

## How to debug tests (Github Actions)

1. You need an SSH-key registered with GitHub. You either pick the key you have already used with `github.com` or you create a dedicated new one with `ssh-keygen -t ed25519 -a 64 -f tmate_ed25519 -C "$(date +'%d-%m-%Y')"` and add it at `https://github.com/settings/keys`.

2. Add the following snippet to `~/.ssh/config`:

```ini
Host *.tmate.io
    User git
    AddKeysToAgent yes
    UseKeychain yes
    PreferredAuthentications publickey
    IdentitiesOnly yes
    IdentityFile ~/.ssh/tmate_ed25519
```

3. Go to `https://github.com/<user>/<repo>/actions/workflows/tests.yml`.

4. Click the `Run workflow` button and you will have the option to select the branch to run the workflow from and activate `tmate` by checking the `Debug with tmate` checkbox for this run.

![tmate](images/gh-tmate.jpg)

5. After the `workflow_dispatch` event was triggered, click the `All workflows` link in the sidebar and then click the `tests` action in progress workflow.

7. Pick one of the jobs in progress in the sidebar.

8. Wait until the current task list reaches the `tmate debugging session` section and the output shows something like:

```
106 SSH: ssh PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
107 or: ssh -i <path-to-private-SSH-key> PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
108 SSH: ssh PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
109 or: ssh -i <path-to-private-SSH-key> PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io
```

9. Copy and execute the first option `ssh PRbaS7SLVxbXImhjUqydQBgDL@nyc1.tmate.io` in the terminal and continue by pressing either <kbd>q</kbd> or <kbd>Ctrl</kbd> + <kbd>c</kbd>.

10. Start the Bats test with `bats ./tests/test.bats`.

For a more detailed documentation about `tmate` see [Debug your GitHub Actions by using tmate](https://mxschmitt.github.io/action-tmate/).

## Contributing

PRs are welcome, especially if they contain tests.

**Contributed and maintained by [@tyler36](https://github.com/tyler36)**
