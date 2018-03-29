### MicroMessengerAppDelegate

微信`AppDelegate`

### MMServiceCenter

服务中心，猜测是管理`MMService`的和它的子类

**获取一个Service**

```
- (id)getService:(Class)arg1
```
| Param | Type |
| :-:| :-:|
| arg1| Class |

传入需要获取Service的Class

列如 `[WCRedEnvelopesLogicMgr class]`

### CContactMgr

联系人管理

**获取自己的信息**

```
- (id)getSelfContact;
```

返回`CContact`类型


### CMessageMgr

消息管理类

**接受一条信息**

```
- (void)onNewSyncAddMessage:(id)arg1;
```

| Param | Type |
| :-:| :-:|
| arg1| CMessageWrap |


**成功发送一条信息**

```
- (void)OnSendMessageSuccess:(id)arg1;
```

| Param | Type |
| :-:| :-:|
| arg1| CMessageWrap |

**添加一条本地消息，比如红包领取消息**

```
- (void)AddLocalMsg:(id)arg1 MsgWrap:(id)arg2;
```

| Param | Type |
| :-: | :-: |
| arg1 | NSString |
| arg2 | CMessageWrap |


### CMessageWrap

消息实体

**消息内容**

```
@property(retain, nonatomic) NSString *m_nsContent;
```

**消息类型**

```
@property(nonatomic) unsigned int m_uiMessageType;
```

| Type | Description |
| :-: | :-: |
| 1 | 文本 |
| 49 | 红包 |
| 10000 | 红包领取提示信息 |

**实际显示内容**

```
- (id)GetDisplayContent;
```

### LocationRetriever

位置管理

**地图位置改变**

```
- (void)onMapLocationChanged:(id)arg1 withTag:(long long)arg2;
```

| Param | Type |
| :-: | :-: |
| arg1 | CLLocation |
| arg2 | |

**定位改变**

```
- (void)onGPSLocationChanged:(id)arg1 withTag:(long long)arg2;
```

| Param | Type |
| :-: | :-: |
| arg1 | CLLocation |
| arg2 | |

### WCRedEnvelopesLogicMgr

红包逻辑

**查询红包详情，包含领取人信息以及金额**

```
- (void)QueryRedEnvelopesDetailRequest:(id)arg1;
```

| Param | Type |
| :-: | :-: |
| arg1 | NSMutableDictionary |

| Key | Value-Type | Description |
| :-: | :-: | :-:|
| channelId | NSString | `nativeUrl` 网址参数里获取 |
| msgType | NSString | `nativeUrl` 网址参数里获取 |
| nativeUrl | NSString | `CMessageWrap `的`m_nsContent`里的`wxpay://`网址 |
| sendId | NSString | `nativeUrl` 网址参数里获取 |

**领取红包之前请求**

```
- (void)ReceiverQueryRedEnvelopesRequest:(id)arg1;
```

| Param | Type |
| :-: | :-: |
| arg1 | NSMutableDictionary |

| Key | Value-Type | Description |
| :-: | :-: | :-:|
| agreeDuty | NSString | 未知 默认为0 |
| inWay | NSString | 未知 默认为1 |
| msgType | NSString | `nativeUrl` 网址参数里获取 |
| sendId | NSString | `nativeUrl` 网址参数里获取 |
| nativeUrl | NSString | `CMessageWrap `的`m_nsContent`里的`wxpay://`网址 |

**红包请求返回，以上两个请求都是从这里返回**

```
- (void)OnWCToHongbaoCommonResponse:(id)arg1 Request:(id)arg2;
```

| Param | Type |
| :-: | :-: |
| arg1 | HongBaoRes |
| arg2 | |

返回Json数据，解析`arg1.retText.buffer`属性即可得到一个`NSDictionary`

| Key | Value-Type | Description |
| :-: | :-: | :-:|
| timingIdentifier | NSString | 领取红包使用 |
| sendId | NSString | 对应请求Id |
| sendUserName | NSString | 发送者Username |
| hbStatus | NSString | 红包状态，自己判断状态为2领取红包 |
| statusMess | NSString | 状态描述 |
| hbType | NSString |  |
| isSender | NSString |  |
| receiveStatus | NSString |  |
| retcode | NSString | 返回码，0为成功 |
| retmsg | NSString | 返回码描述 |
| watermark | NSString | |
| wishing | NSString | 红包恭喜语句 |


**打开一个红包**

```
- (void)OpenRedEnvelopesRequest:(id)arg1;
```

| Param | Type |
| :-: | :-: |
| arg1 | NSMutableDictionary |

| Key | Value-Type | Description |
| :-: | :-: | :-:|
| nickName | NSString | 自己的昵称 |
| headImg | NSString | 自己头像地址 |
| channelId | NSString | `nativeUrl` 网址参数里获取 |
| msgType | NSString | `nativeUrl` 网址参数里获取 |
| sendId | NSString | `nativeUrl` 网址参数里获取 |
| sessionUserName | NSString | `nativeUrl` 网址参数里获取 |
| nativeUrl | NSString | `CMessageWrap `的`m_nsContent`里的`wxpay://`网址 |

#### 红包自动领取流程

1. `onNewSyncAddMessage `
2. `ReceiverQueryRedEnvelopesRequest `
3. `OnWCToHongbaoCommonResponse`
4. `OpenRedEnvelopesRequest`
5. `AddLocalMsg:MsgWrap`

最后一步可以不要，微信领取红包会显示一个提示信息。

在这个流程中有一个小问题，提示信息会自动创建一个聊天会话在第5步可以屏蔽

### BaseMsgContentViewController

聊天界面基类

**返回当前聊天界面信息数组**

```
- (id)GetMessagesWrapArray;
```

数组成员`CMessageWrap `类型