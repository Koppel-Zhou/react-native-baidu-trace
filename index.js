
import { NativeModules, NativeEventEmitter } from 'react-native';

const { BaiduTrace } = NativeModules;

  /**
   * @class 百度鹰眼服务的事件监听器
   */
export const BaiduTraceEventEmitter = new NativeEventEmitter(BaiduTrace);
export default {
  /**
   * @method initService 初始化服务
   * @param {
   * config: Platform === 'iOS'
   * ? {AK, serviceId, entityName, keepAlive}
   * : {serviceId, entityName, isNeedObjectStorage}}
   */
  initService: config => BaiduTrace.initService(config),
  
  /**
   * @method setGatherAndPackInterval 设置收集周期和打包上传周期，单位：s
   * @param {
   * config: {gatherInterval, packInterval}
   */
  setGatherAndPackInterval: (gatherInterval, packInterval) => BaiduTrace.setGatherAndPackInterval(gatherInterval, packInterval),

  /**
   * @method startTrace 开启定位服务
   */
  startTrace: () => BaiduTrace.startTrace(),

  /**
   * @method stopTrace 停止定位服务
   */
  stopTrace: () => BaiduTrace.stopTrace(),

  /**
   * @method updateEntity 更新Entity
   */
  updateEntity: config => BaiduTrace.updateEntity(config),

  /**
   * @method startGather 开始收集定位信息
   */
  startGather: () => BaiduTrace.startGather(),

  /**
   * @method stopGather 停止收集定位信息
   */
  stopGather: () => BaiduTrace.stopGather(),
};
