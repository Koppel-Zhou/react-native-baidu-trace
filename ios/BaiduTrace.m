#import "BaiduTrace.h"

@implementation BaiduTrace

+(BaiduTrace *)defaultManager {
    static BaiduTrace *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BaiduTrace alloc] init];
    });
    return manager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
      _isServiceInited = FALSE;
      _isServiceStarted = FALSE;
      _isGatherStarted = FALSE;
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[
      @"BAIDU_TRACE_ON_START_TRACE",
      @"BAIDU_TRACE_ON_STOP_TRACE",
      @"BAIDU_TRACE_ON_START_GATHER",
      @"BAIDU_TRACE_ON_STOP_GATHER",
      @"BAIDU_TRACE_ON_UPDATE_ENTITY"
    ];
}

RCT_EXPORT_MODULE()
// 填写你在API控制台申请的iOS类型的AK
NSString * AK = @"";
//填写你在API控制台申请iOS类型AK时指定的Bundle Identifier
NSString * MCODE = @"";
// 填写你在鹰眼轨迹管理台创建的鹰眼服务对应的ID
NSUInteger serviceId = 0;

NSString* entityName = @"";
NSString* entityDesc = @"";
NSInteger gatherInterval = 5;
NSInteger packInterval = 30;
BOOL keepAlive = YES;

RCT_EXPORT_METHOD(initService:(NSDictionary *)config)
{
  AK = [RCTConvert NSString:config[@"AK"]];
  entityName = [RCTConvert NSString:config[@"entityName"]];
  entityDesc = [RCTConvert NSString:config[@"entityDesc"]];
  serviceId = [RCTConvert NSUInteger:config[@"serviceId"]];
  keepAlive = [RCTConvert BOOL:config[@"keepAlive"]];
  // 设置鹰眼SDK的基础信息
  // 每次调用startService开启轨迹服务之前，可以重新设置这些信息。
  NSLog(@"轨迹服务初始化是否成功：%@", _isServiceInited ? @"YES" : @"NO");
  if(!_isServiceInited) {
    MCODE = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    BTKServiceOption* sop = [[BTKServiceOption alloc] initWithAK:AK mcode:MCODE serviceID:serviceId keepAlive:keepAlive];
    self.isServiceInited = [[BTKAction sharedInstance] initInfo:sop];
    NSLog(@"轨迹服务初始化是否成功：%@, bundleID：%@", _isServiceInited ? @"YES" : @"NO", MCODE);
  }
}

RCT_EXPORT_METHOD(setGatherAndPackInterval:(NSInteger)gather packInterval:(NSInteger)pack)
{
  gatherInterval = gather;
  packInterval = pack;
  [[BTKAction sharedInstance] changeGatherAndPackIntervals:gatherInterval packInterval:packInterval delegate:self];
}

RCT_EXPORT_METHOD(startTrace)
{
  if (!_isServiceStarted) {
      // 设置开启轨迹服务时的服务选项，指定本次服务以entityName的名义开启
      BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:entityName];
      // 开启服务
      [[BTKAction sharedInstance] startService:op delegate:self];
  }
}

RCT_EXPORT_METHOD(updateEntity:(NSDictionary *)config)
{
  
  if (_isServiceStarted) {
    BTKUpdateEntityRequest *request = [[BTKUpdateEntityRequest alloc] initWithEntityName:entityName entityDesc: entityDesc columnKey: config serviceID: serviceId tag: 0];
    [[BTKEntityAction sharedInstance] updateEntityWith:request delegate:self];
  }
}

RCT_EXPORT_METHOD(stopTrace)
{
  // 停止服务
  [[BTKAction sharedInstance] stopService:self];
}

RCT_EXPORT_METHOD(startGather)
{
  // 开始收集
   if (!_isGatherStarted) {
     [[BTKAction sharedInstance] startGather:self];
   }
}

RCT_EXPORT_METHOD(stopGather)
{
  //  停止收集
  [[BTKAction sharedInstance] stopGather:self];
}

// 需要保活以及后台轨迹追踪时，需要在Info.plist文件中增加后台定位相关配置，同时实现此回调
- (void)onRequestAlwaysLocationAuthorization:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

-(void)onStartService:(BTKServiceErrorCode)error {
    // 维护状态标志
    if (error == BTK_START_SERVICE_SUCCESS ||
        error == BTK_START_SERVICE_SUCCESS_BUT_OFFLINE ||
        error == BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE) {
        NSLog(@"轨迹服务开启成功");
        self.isServiceStarted = TRUE;
    } else {
        NSLog(@"轨迹服务开启失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_START_SERVICE_SUCCESS:
            title = @"轨迹服务开启成功";
            message = @"成功登录到服务端";
            break;
        case BTK_START_SERVICE_SUCCESS_BUT_OFFLINE:
            title = @"轨迹服务开启成功";
            message = @"当前网络不畅，未登录到服务端。网络恢复后SDK会自动重试";
            break;
        case BTK_START_SERVICE_PARAM_ERROR:
            title = @"轨迹服务开启失败";
            message = @"参数错误,点击右上角设置按钮设置参数";
            break;
        case BTK_START_SERVICE_INTERNAL_ERROR:
            title = @"轨迹服务开启失败";
            message = @"SDK服务内部出现错误";
            break;
        case BTK_START_SERVICE_NETWORK_ERROR:
            title = @"轨迹服务开启失败";
            message = @"网络异常";
            break;
        case BTK_START_SERVICE_AUTH_ERROR:
            title = @"轨迹服务开启失败";
            message = @"鉴权失败，请检查AK和MCODE等配置信息";
            break;
        case BTK_START_SERVICE_IN_PROGRESS:
            title = @"轨迹服务开启失败";
            message = @"正在开启服务，请稍后再试";
            break;
        case BTK_SERVICE_ALREADY_STARTED_ERROR:
            title = @"轨迹服务开启失败";
            message = @"已经成功开启服务，请勿重复开启";
            break;
        case BTK_START_SERVICE_SUCCESS_BUT_NO_AUTH_TO_KEEP_ALIVE:
            title = @"轨迹服务开启成功";
            message = @"轨迹服务开启成功，要求开启保活，但没有定位权限导致无法保活";
            break;
        default:
            title = @"通知";
            message = @"轨迹服务开启结果未知";
            break;
    }
    NSDictionary *info = @{@"type":@(YY_SERVICE_OPERATION_TYPE_START_SERVICE),
                           @"title":title,
                           @"message":message,
                           };
    // 发送广播
  [self sendEventWithName:@"BAIDU_TRACE_ON_START_TRACE" body:info];
}

-(void)onStopService:(BTKServiceErrorCode)error {
    // 维护状态标志
    if (error == BTK_STOP_SERVICE_NO_ERROR) {
        NSLog(@"轨迹服务停止成功");
        self.isServiceStarted = FALSE;
    } else {
        NSLog(@"轨迹服务停止失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_STOP_SERVICE_NO_ERROR:
            title = @"轨迹服务停止成功";
            message = @"SDK已停止工作";
            break;
        case BTK_STOP_SERVICE_NOT_YET_STARTED_ERROR:
            title = @"轨迹服务停止失败";
            message = @"还没有开启服务，无法停止服务";
            break;
        case BTK_STOP_SERVICE_IN_PROGRESS:
            title = @"轨迹服务停止失败";
            message = @"正在停止服务，请稍后再试";
            break;
        default:
            title = @"通知";
            message = @"轨迹服务停止结果未知";
            break;
    }
    NSDictionary *info = @{@"type":@(YY_SERVICE_OPERATION_TYPE_STOP_SERVICE),
                           @"title":title,
                           @"message":message,
                           };
    // 发送广播
    [self sendEventWithName:@"BAIDU_TRACE_ON_STOP_TRACE" body:info];
}

-(void)onStartGather:(BTKGatherErrorCode)error {
    // 维护状态标志
    if (error == BTK_START_GATHER_SUCCESS) {
        NSLog(@"轨迹服务开始采集成功");
        self.isGatherStarted = TRUE;
    } else {
        NSLog(@"轨迹服务开始采集失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_START_GATHER_SUCCESS:
            title = @"开始采集成功";
            message = @"开始采集成功";
            break;
        case BTK_GATHER_ALREADY_STARTED_ERROR:
            title = @"开始采集失败";
            message = @"已经在采集轨迹，请勿重复开始";
            break;
        case BTK_START_GATHER_BEFORE_START_SERVICE_ERROR:
            title = @"开始采集失败";
            message = @"开始采集必须在开始服务之后调用";
            break;
        case BTK_START_GATHER_LOCATION_SERVICE_OFF_ERROR:
            title = @"开始采集失败";
            message = @"没有开启系统定位服务";
            break;
        case BTK_START_GATHER_LOCATION_ALWAYS_USAGE_AUTH_ERROR:
            title = @"开始采集失败";
            message = @"没有开启后台定位权限";
            break;
        case BTK_START_GATHER_INTERNAL_ERROR:
            title = @"开始采集失败";
            message = @"SDK服务内部出现错误";
            break;
        default:
            title = @"通知";
            message = @"开始采集轨迹的结果未知";
            break;
    }
    NSDictionary *info = @{@"type":@(YY_SERVICE_OPERATION_TYPE_START_GATHER),
                           @"title":title,
                           @"message":message,
                           };
    // 发送广播
    [self sendEventWithName:@"BAIDU_TRACE_ON_START_GATHER" body:info];
}

-(void)onStopGather:(BTKGatherErrorCode)error {
    // 维护状态标志
    if (error == BTK_STOP_GATHER_NO_ERROR) {
        NSLog(@"停止采集成功");
        self.isGatherStarted = FALSE;
    } else {
        NSLog(@"停止采集失败");
    }
    // 构造广播内容
    NSString *title = nil;
    NSString *message = nil;
    switch (error) {
        case BTK_STOP_GATHER_NO_ERROR:
            title = @"停止采集成功";
            message = @"SDK停止采集本设备的轨迹信息";
            break;
        case BTK_STOP_GATHER_NOT_YET_STARTED_ERROR:
            title = @"开始采集失败";
            message = @"还没有开始采集，无法停止";
            break;
        default:
            title = @"通知";
            message = @"停止采集轨迹的结果未知";
            break;
    }
    NSDictionary *info = @{@"type":@(YY_SERVICE_OPERATION_TYPE_STOP_GATHER),
                           @"title":title,
                           @"message":message,
                           };
    // 发送广播
    [self sendEventWithName:@"BAIDU_TRACE_ON_STOP_GATHER" body:info];
}

-(void)onUpdateEntity:(NSData *)response {
  NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
  if (nil == dict) {
      NSLog(@"Update Entity 格式转换出错");
      return;
  }
  if (0 != [dict[@"status"] intValue]) {
      NSLog(@"Update Entity 返回错误");
      return;
  }
  // 构造广播内容
  NSDictionary *info = @{@"type":@([dict[@"status"] intValue]),
                         @"title": @"Entity更新",
                         @"message":dict[@"message"],
                         };
  // 发送广播
  [self sendEventWithName:@"BAIDU_TRACE_ON_UPDATE_ENTITY" body:info];
}

@end
