
import { NativeModules, Platform, DeviceEventEmitter, NativeEventEmitter } from 'react-native';

const { RNBaiduTrace } = NativeModules;

  /**
   * @class 百度鹰眼服务的事件监听器
   */
export const BaiduTraceEventEmitter = Platform.OS === 'ios' ? new NativeEventEmitter(RNBaiduTrace) : DeviceEventEmitter;
export default {
  /**
   * @method initService 初始化服务
   * @param {
   * config: Platform === 'iOS'
   * ? {AK, mcode, serviceId, entityName, keepAlive}
   * : {serviceId, entityName, isNeedObjectStorage}}
   */
  initService: config => RNBaiduTrace.initService(config),
  
  /**
   * @method setGatherAndPackInterval 设置收集周期和打包上传周期，单位：s
   * @param {
   * config: {gatherInterval, packInterval}
   */
  setGatherAndPackInterval: (gatherInterval, packInterval) => RNBaiduTrace.setGatherAndPackInterval(gatherInterval, packInterval),

  /**
   * @method startTrace 开启定位服务
   */
  startTrace: () => RNBaiduTrace.startTrace(),

  /**
   * @method stopTrace 停止定位服务
   */
  stopTrace: () => RNBaiduTrace.stopTrace(),

  /**
   * @method startGather 开始收集定位信息
   */
  startGather: () => RNBaiduTrace.startGather(),

  /**
   * @method stopGather 停止收集定位信息
   */
  stopGather: () => RNBaiduTrace.stopGather(),
};
