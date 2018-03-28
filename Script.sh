#!/bin/sh

#  Script.sh
#  WxHook
#
#  Created by AQY on 2018/3/24.
#  

APP_DIR=~/Desktop/Hook/wx/Payload/WeChat.app

rm -rf ${APP_DIR}/WxHook.dylib
cp ${BUILT_PRODUCTS_DIR}/WxHook.dylib ${APP_DIR}/WxHook.dylib

rm -rf ${APP_DIR}/RevealServer.framework
cp -r `pwd`/RevealServer.framework ${APP_DIR}/RevealServer.framework
