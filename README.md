<h1 align="center">🔐 App Token Generator</h1>
<p align="center">
    <em>A tool to generate Github Access Token on the fly</em>
</p>

<p align="center">
    <img src="https://img.shields.io/github/license/TechProber/app-token-generator?color=critical" alt="License"/>
    <a href="https://hits.seeyoufarm.com">
      <img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FTechProber%2Fapp-token-generator&count_bg=%235322B2&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/>
    </a>
    <a href="https://img.shields.io/tokei/lines/github/TechProber/app-token-generator?color=orange">
      <img src="https://img.shields.io/tokei/lines/github/TechProber/app-token-generator?color=orange" alt="lines">
    </a>
    <a href="https://hub.docker.com/repository/docker/hikariai/">
        <img src="https://img.shields.io/badge/docker-v20.10.7-blue" alt="Version">
    </a>
    <a href="https://github.com/TechProber/app-token-generator">
        <img src="https://img.shields.io/github/last-commit/TechProber/app-token-generator" alt="lastcommit"/>
    </a>
</p>

## Introduction

#### Background

Using default settings with GitHub Apps may put you at risk of leaking data between GitHub App installations. GitHub allows developers to create what is referred to as a GitHub app. A GitHub app can be installed on a GitHub organization or a personal GitHub account. Once installed, the GitHub app can request a new token for each installation of the app. The GitHub App has a private key that is used to generate a GitHub App token. This token can be used for a subset of the GitHub APIs.

#### Application

`App Token Generator` is a serverless function offers the end-user a way to dynamically generate a Github Access Token tailored to be used in any back-end system. It can also be intergrated in the standard CICD Pipeline as a seperate step or stage.

## Local Setup

#### Pre-requisite

- Put `private-key.pem` associtated to your Github Application under the project root path

#### Run

```bash
APP_ID=<YOUR GITHUB_APP_ID> ./handler.rb
```

## Containerization

Build the image

```bash
docker build -t app-token-generator:latest .
```

Run the application as a container

```bash
docker run --rm -it \
           --name app-token-generator \
           -e GITHUB_APP_KEY=/opt/certs/private-key.pem \
           -v $(PWD)/private-key.pem:/opt/certs/private-key.pem \
           -e APP_ID=<YOUR GITHUB_APP_ID> \
           quay.io/techprober/app-token-generator:latest
```

## References

- [GitHub Apps - How to avoid leaking your customer’s source code with GitHub apps](https://roadie.io/blog/avoid-leaking-github-org-data/)
