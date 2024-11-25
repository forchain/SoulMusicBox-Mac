#!/bin/bash

xcodebuild test -project SoulMusicBox.xcodeproj \
                -scheme SoulMusicBoxUITests \
                -testPlan SoulMusicBoxUITests \
                -only-testing:SoulMusicBoxUITests/SoulMusicBoxUITests/testMain
