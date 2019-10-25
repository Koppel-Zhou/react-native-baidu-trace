#import <Foundation/Foundation.h>

//#if __has_include("RCTBridgeModule.h")
//#import "RCTBridgeModule.h"
//#else
//#import <React/RCTBridgeModule.h>
//#endif
#import <React/RCTConvert.h>
#import <React/RCTEventEmitter.h>

#import <BaiduTraceSDK/BaiduTraceSDK.h>

typedef NS_ENUM(NSUInteger, ServiceOperationType) {
    YY_SERVICE_OPERATION_TYPE_START_SERVICE,
    YY_SERVICE_OPERATION_TYPE_STOP_SERVICE,
    YY_SERVICE_OPERATION_TYPE_START_GATHER,
    YY_SERVICE_OPERATION_TYPE_STOP_GATHER,
};

@interface RNBaiduTrace : RCTEventEmitter <RCTBridgeModule, BTKTraceDelegate, CLLocationManagerDelegate>

+(RNBaiduTrace *)defaultManager;

/**
标志是否已经初始化轨迹服务
*/

@property (nonatomic, assign) BOOL isServiceInited;
/**
 标志是否已经开启轨迹服务
 */
@property (nonatomic, assign) BOOL isServiceStarted;

/**
 标志是否已经开始采集
 */
@property (nonatomic, assign) BOOL isGatherStarted;


/**
初始化轨迹服务
*/
-(void)initService;

/**
 开启轨迹服务
 */
-(void)startTrace;

/**
 停止轨迹服务
 */
-(void)stopTrace;

/**
 开始采集
 */
-(void)startGather;

/**
 停止采集
 */
-(void)stopGather;

@end
