
# react-native-baidu-trace

Baidu Trace SDK modules for React Native(Android &amp; iOS),百度地图鹰眼轨迹 React Native 模块

## Getting started

`$ npm install react-native-baidu-trace --save`

### Mostly automatic installation

`$ react-native link react-native-baidu-trace`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-baidu-trace` and add `RNBaiduTrace.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBaiduTrace.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNBaiduTracePackage;` to the imports at the top of the file
  - Add `new RNBaiduTracePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-baidu-trace'
  	project(':react-native-baidu-trace').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-baidu-trace/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-baidu-trace')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNBaiduTrace.sln` in `node_modules/react-native-baidu-trace/windows/RNBaiduTrace.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Baidu.Trace.RNBaiduTrace;` to the usings at the top of the file
  - Add `new RNBaiduTracePackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNBaiduTrace from 'react-native-baidu-trace';

// TODO: What to do with the module?
RNBaiduTrace;
```
  