//
//  BTKDeleteMonitoredObjectRequest.h
//  BaiduTraceSDK
//
//  Created by DanielBey on 2019/4/8.
//  Copyright © 2019 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"

/// 删除服务端地理围栏的监控对象的请求信息类
@interface BTKDeleteMonitoredObjectRequest : BTKAPIBaseRequest

/**
 要删除监控对象的地理围栏的唯一标识符
 */
@property (nonatomic, assign) NSUInteger fenceID;

/**
 需要删除的监控对象的名称数组，必选。
 数组中每一项代表一个被监控对象的名称。
 数组为空或传入nil则删除该围栏的所有监控对象
 */
@property (nonatomic, copy) NSArray <NSString *> *monitoredObjects;

/**
 构造方法
 
 @param fenceID 围栏的唯一标识符
 @param monitoredObjects 被监控对象
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return BTKDeleteMonitoredObjectRequest对象
 */
- (instancetype)initWithFenceID:(NSUInteger)fenceID monitoredObjects:(NSArray *)monitoredObjects serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end

