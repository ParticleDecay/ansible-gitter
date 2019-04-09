# ansible-gitter
Clone GitHub repositories and perform automatic configuration tasks

## Dependencies
- ansible - v2.7+
- python - v3.5+

## Setup
Clone this repository or download the [master zip](https://github.com/ParticleDecay/ansible-gitter/archive/master.zip):
```
git clone https://github.com/ParticleDecay/ansible-gitter
```

Set up personal variables in `vars/all.yml` (see examples in `vars/all.yml.sample`)

```
# vars/all.yml
projects_dir: /home/me/Projects
github_username: ParticleDecay
github_email: me@github.com
```
It's recommended to set the `projects_dir` variable (where all your cloned repos will go). If you have a GitHub (or GitHub Enterprise) account you use more often, you should also set the `github_username` and `github_email` variables.

NOTE: These variables can be overridden when cloning.

#### GPG
This repository supports GPG keys. The only requirement is that the GPG key be discoverable via the `gpg2` command and the `github_email` email address. To verify that this is possible, run the following command with your GitHub email address (substitute your email for `EMAIL_ADDRESS`):
```
gpg2 --fingerprint EMAIL_ADDRESS
```
If you see a GPG key, then the cloned repository will be automatically configured to use that specific GPG key for verification.

## Usage
The cloning is done with the `clone.sh` script:
```
usage: clone.sh [-hc] [-u github_username] [-e github_email] [-p projects_dir] <repository_url>

Run the playbook for cloning the given <repository_url>.

positional arguments:
  repository_url	the clone URL for a GitHub repository

optional arguments:
  -h			show this help message and exit
  -c			configure any existing code editors (VS Code, Sublime)
  -u github_username	your GitHub username (useful for detecting forks)
  -e github_email	your GitHub email (useful for multi-account setups and GPG keys)
  -p projects_dir	full path to directory where projects are stored
```

The `-c` option will enable autodetected configuration of any code editors (currently VS Code and Sublime Text). This involves adding the newly cloned repository as a project in the respective editor. NOTE: For VS Code, this is done via the [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager) extension (installed automatically).

The `-u` option allows you to override the `github_username` variable (even if it is set in `vars/all.yml`).

The `-e` option allows you to override the `github_email` variable (even if it is set in `vars/all.yml`).

The `-p` option allows you to override the `projects_dir` variable (even if it is set in `vars/all.yml`).

## Examples
Clone an HTTPS GitHub repository:
```
./clone.sh https://github.com/ParticleDecay/ansible-gitter
```

Clone an SSH GitHub repository and add the repository to code editors:
```
./clone.sh -c git@github.com:ParticleDecay/ansible-gitter.git
```

Clone an SSH GitHub Enterprise repository with a different account (note that this will be automatically added as an upstream remote, with a `workuser` origin):
```
./clone.sh -u workuser -e me@work.org git@github.enterprise.com:company/mystuff.git
```
