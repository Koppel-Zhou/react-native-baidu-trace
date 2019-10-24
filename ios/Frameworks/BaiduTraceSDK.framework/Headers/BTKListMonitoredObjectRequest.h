//
//  BTKListMonitoredObjectRequest.h
//  BaiduTraceSDK
//
//  Created by DanielBey on 2019/4/8.
//  Copyright © 2019 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"

/// 查询服务端地理围栏的监控对象的请求信息类
@interface BTKListMonitoredObjectRequest : BTKAPIBaseRequest

/**
 地理围栏的唯一标识符
 */
@property (nonatomic, assign) NSUInteger fenceID;

/**
 分页索引，选填。
 pageIndex与pageSize一起计算从第几条结果返回，代表返回第几页。
 */
@property (nonatomic, assign) NSUInteger pageIndex;

/**
 分页大小，选填。
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几条记录。
 */
@property (nonatomic, assign) NSUInteger pageSize;


/**
 构造方法

 @param fenceID 围栏的唯一标识符
 @param pageIndex 分页索引
 @param pageSize 分页大小
 @param serviceID 轨迹服务ID
 @param tag 请求标志
 @return BTKListMonitoredObjectRequest对象
 */
- (instancetype)initWithFenceID:(NSUInteger)fenceID pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;

@end

