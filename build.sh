#!/usr/bin/env bash

xcodebuild -target RMRHexColorGen -configuration Release clean build
xcodebuild -target RMRRefreshColorPanelPlugin -configuration Release clean build
