
# @koppel/react-native-baidu-trace

Baidu Trace SDK modules for React Native(Android &amp; iOS),百度地图鹰眼轨迹 React Native 模块

 百度鹰眼轨迹SDK文档：[iOS](http://lbsyun.baidu.com/index.php?title=ios-yingyan)		[Android](http://lbsyun.baidu.com/index.php?title=android-yingyan)

## Getting started

`$ npm install @koppel/react-native-baidu-trace --save`

### Mostly automatic installation

#### React Native > 0.60(暂时只测试了0.62.2)
`cd ios && pod install`

#### React Native < 0.60
`$ react-native link @koppel/react-native-baidu-trace`

**iOS 使用react-native link 目前有些问题。解决办法：libRNBaiduTrace.a和BaiduTraceSDK.Framework文件重新手动导入。**

**另外：如遇到项目报错`image not found`，请尝试将项目TARGETS的`General`下`Frameworks,Libraries,and Embedded Content`的BaiduTraceSDK.Framework的`Embed`选项改为`Embed & Sign`**，我尝试了按照网上的教程在`Build Phases`下`Link Binary With Libraries`将BaiduTraceSDK.Framework的`Status`由默认的`Required`改为`Optional`，项目可以正常运行，但初始化是一直失败的。

### Android 其他设置

#### 设置AccessKey
在Mainfest.xml正确设置AccessKey（AK），如果设置错误将会导致鹰眼服务无法正常使用。需在Application标签中加入以下代码，并填入开发者自己的 Android 类型 AK。AK申请方法参见[申请密钥](http://lbsyun.baidu.com/index.php?title=android-yingyan/guide/key)。
```xml
<meta-data             
android:name="com.baidu.lbsapi.API_KEY"             
android:value="AK" />       //key:开发者申请的Key
```
#### 声明使用权限
```xml
<!-- 以下是鹰眼SDK基础权限 -->
<!-- 这个权限用于进行网络定位--> 
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission> 
<!-- 这个权限用于访问GPS定位--> 
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission> 
<!-- 用于访问wifi网络信息，wifi信息会用于进行网络定位-->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission> 
<!-- 获取运营商信息，用于支持提供运营商信息相关的接口--> 
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission> 
<!-- 这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
<!-- 写入扩展存储，向扩展卡写入数据，用于写入对象存储BOS数据--> 
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
<!-- 访问网络，网络定位需要上网-->
<uses-permission android:name="android.permission.INTERNET"></uses-permission> 
<!-- Android O之后开启前台服务需要申请该权限 -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<!-- Android Q之后，后台定位需要申请该权限 -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<!-- Android O之后开启前台服务需要申请该权限 -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<!-- Android Q之后，后台定位需要申请该权限 -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<!-- 以下不是鹰眼SDK需要的基础权限，可选 -->
<!-- 用于加快GPS首次定位，可选权限，非必须-->
<uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"></uses-permission>
<!-- 用于Android M及以上系统，申请加入忽略电池优化白名单，可选权限，非必须-->
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS"></uses-permission>
```

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@koppel/react-native-baidu-trace/RNBaiduTrace` and add `RNBaiduTrace.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBaiduTrace.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNBaiduTracePackage;` to the imports at the top of the file
  - Add `new RNBaiduTracePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
    	include ':@koppel_react-native-baidu-trace'
    	project(':@koppel_react-native-baidu-trace').projectDir = new File(rootProject.projectDir, 	'../node_modules/@koppel/react-native-baidu-trace/android')
   ```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  ```
      compile project(':@koppel_react-native-baidu-trace')
  ```

## Usage

```javascript
import BaiduTrace, { BaiduTraceEventEmitter } from '@koppel/react-native-baidu-trace';
```

### Init Service

```javascript
BaiduTrace.initService({
	AK: '在百度注册的iOS AK',													// iOS		
	serviceId: '在百度注册轨迹服务时的serviceId',			  // iOS & Android
	entityName: '设备标识符',													// iOS & Android
	entityDesc: '设备描述',														// iOS & Android
	isNeedObjectStorage: false,											// Android
	keepAlive: true,																// iOS
});
```

### Set Gather Interval And Pack Interval

```javascript
// 详细要求参阅百度鹰眼SDK文档
BaiduTrace.setGatherAndPackInterval(gatherInterval, packInterval);
```

### Start Service & Stop Service
```javascript
BaiduTrace.startService();
BaiduTrace.stopService()
```

### Start Gather & Stop Gather
```javascript
// startGather前请确保startSevise成功
BaiduTrace.startGather();
BaiduTrace.stopGather()
```

### Update Entity
```javascript
BaiduTrace.updateEntity({
	[columnKey1]: [columnValue1],
	[columnKey2]: [columnValue2],
	...
});
```

### 添加事件监听
支持下列事件:
| 监听器标志 | 含义|
| - | - |
| BAIDU_TRACE_ON_START_TRACE  	| 开启追踪服务			|
| BAIDU_TRACE_ON_STOP_TRACE   	| 停止追踪服务		  |
| BAIDU_TRACE_ON_START_GATHER 	| 开始收集定位信息	 |
| BAIDU_TRACE_ON_STOP_GATHER  	| 停止收集定位信息	 |
| BAIDU_TRACE_ON_UPDATE_ENTITY 	| 更新Entity	     |
| BAIDU_TRACE_ON_BIND_SERVICE(only available on Android) 	| 绑定追踪服务			|

```javascript
BaiduTraceEventEmitter.addListener(
	'BAIDU_TRACE_ON_START_GATHER',
	(result) => {
		console.log('BAIDU_TRACE_ON_START_GATHER', result);
	}
);
```


// TODO: 暂时只集成服务的启停以及收集信息的启停功能，其他功能后续有时间添加

  