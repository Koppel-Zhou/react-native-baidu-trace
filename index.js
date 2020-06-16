
import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNBaiduTrace } = NativeModules;

  /**
   * @class 百度鹰眼服务的事件监听器
   */
export const BaiduTraceEventEmitter = new NativeEventEmitter(RNBaiduTrace);
export default {
  /**
   * @method initService 初始化服务
   * @param {
   * config: Platform === 'iOS'
   * ? {AK, serviceId, entityName, keepAlive}
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
   * @method updateEntity 更新Entity
   */
  updateEntity: config => RNBaiduTrace.updateEntity(config),

  /**
   * @method startGather 开始收集定位信息
   */
  startGather: () => RNBaiduTrace.startGather(),

  /**
   * @method stopGather 停止收集定位信息
   */
  stopGather: () => RNBaiduTrace.stopGather(),
};
