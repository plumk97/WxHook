#!/bin/sh

#  Script.sh
#  WxHook
#
#  Created by AQY on 2018/3/24.
#  

rm -rf ~/Documents/inject/wx/Payload/WeChat.app/WxHook.dylib
cp `pwd`/LatestBuild/Debug-iphoneos/WxHook.dylib ~/Documents/inject/wx/Payload/WeChat.app/WxHook.dylib

rm -rf ~/Documents/inject/wx/Payload/WeChat.app/RevealServer.framework
cp -r `pwd`/RevealServer.framework ~/Documents/inject/wx/Payload/WeChat.app/RevealServer.framework
