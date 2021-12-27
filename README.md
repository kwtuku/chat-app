<p>
  <img alt="ruby version" src="https://img.shields.io/badge/Ruby-v2.6.6-701516">
  <img alt="rails version" src="https://img.shields.io/badge/Rails-v6.0.4.1-cc0000">
  <img alt="Lines of code" src="https://img.shields.io/tokei/lines/github/kwtuku/chat-app">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/kwtuku/chat-app">
  <img alt="CircleCI" src="https://circleci.com/gh/kwtuku/chat-app/tree/main.svg?style=svg">
</p>

## 概要

チャットアプリです。<br>
LINEのように個人間のチャットもグループチャットもできます。<br>
[forem](https://github.com/forem/forem)のコードを参考にしています。

## ER図

![ER図](er_diagram.drawio.svg)

## 使用技術

### 開発環境

- Windows 10 Home
- Docker
- Docker Compose

### フロントエンド

- HTML
- SCSS
- JavaScript
- 主要モジュール
  - Bootstrap
  - Popper

### バックエンド

- Ruby 2.6.6
- Ruby on Rails 6.0.4.1
- 主要Gem
  - Bullet
  - CarrierWave
  - Devise
  - Pundit
  - RSpec
  - RuboCop

### DB、インフラなど

- CircleCI
- Heroku
- PostgreSQL 13.3
- Puma
