#!/bin/bash

function checkVersion() {
  if [ $1 != $2 ]; then
    printf "\033[31;1m$3 のversionが最新ではありません（現行: $1 , 最新: $2 ）\033[0m\n"
    printf "\033[33;1m$4\033[0m\n"
    brew upgrade swiftlint
  else
    printf "\033[32;1m$3 は最新です（Ver: $1）\033[0m\n"
  fi
}

function sectionEcho() {
  printf "\n"
  printf "\033[32;1m--------------------- $1 ---------------------\033[0m\n"
}

function isExist() {
  type $1 >/dev/null 2>&1
}

# Homebrew のインストール
if ! isExist brew; then
  sectionEcho "install homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# rbenv のインストール
if ! isExist rbenv; then
  sectionEcho "install rbenv"
  brew install rbenv ruby-build
fi

# ローカルにruby環境を構築
rbenv_fix="3.2.2"
rbenv_local=$(rbenv local)
rbenv_version_result=$(rbenv versions)
echo $rbenv_version_result
if ! [[ $rbenv_version_result =~ $rbenv_fix ]]; then
  sectionEcho "install rbenv version "$rbenv_fix
  rbenv install $rbenv_fix
fi
rbenv local $rbenv_fix

# bundlerのインストール
if ! isExist bundler; then
  sectionEcho "install bundler"
  rbenv exec gem install bundler
  rbenv rehash
fi

# jazzyのインストール
if ! isExist jazzy; then
  sectionEcho "install jazzy"
  rbenv exec bundle install
fi

# swiftlint のインストール
if ! isExist swiftlint; then
  sectionEcho "install swiftlint"
  brew install swiftlint
fi

# swiftlint の version を確認する
sectionEcho "check swiftlint version"
current_ver=`swiftlint version`
latest_ver=`brew info swiftlint 2>/dev/null | head -n 1 | cut -d " " -f3`
checkVersion ${current_ver} ${latest_ver} "swiftlint"

# Mac に完了通知を出す
if isExist osascript; then
  osascript -e 'display notification "Done" with title "YJLoginSDK Setup"'
fi
