#import <Foundation/Foundation.h>

//#if __has_include("RCTBridgeModule.h")
//#import "RCTBridgeModule.h"
//#else
//#import <React/RCTBridgeModule.h>
//#endif
#import <React/RCTConvert.h>
#import <React/RCTEventEmitter.h>

#import <BaiduTraceSDK/BaiduTraceSDK.h>

#define GLOBAL_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

typedef NS_ENUM(NSUInteger, ServiceOperationType) {
    YY_SERVICE_OPERATION_TYPE_START_SERVICE,
    YY_SERVICE_OPERATION_TYPE_STOP_SERVICE,
    YY_SERVICE_OPERATION_TYPE_START_GATHER,
    YY_SERVICE_OPERATION_TYPE_STOP_GATHER,
};

@interface RNBaiduTrace : RCTEventEmitter <RCTBridgeModule, BTKTraceDelegate>

+(RNBaiduTrace *)defaultManager;

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

/**
 发送事件到JS
*/
- (void)sendEvent:(NSString *)eventName Info:(NSDictionary *)info;

@end
