//
//  BTKQueryServerFenceStatusByCustomLocationRequest.h
//  BaiduTraceSDK
//
//  Created by Daniel Bey on 2017年04月20日.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTKAPIBaseRequest.h"
#import "BTKTypes.h"
#import <CoreLocation/CoreLocation.h>

/// 查询被监控对象，在指定的位置时，和服务端地理围栏的位置关系的请求信息类
/**
 查询指定的坐标位置，是在指定的服务端围栏的内部还是外部的请求信息，通过此类设置
 */
@interface BTKQueryServerFenceStatusByCustomLocationRequest : BTKAPIBaseRequest

/**
 服务端地理围栏监控对象的名称，必须为非空的字符串。
 */
@property (nonatomic, copy) NSString *monitoredObject;

/**
 指定的坐标位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D customLocation;

/**
 坐标类型
 */
@property (nonatomic, assign) BTKCoordType coordType;

/**
 服务端地理围栏的ID列表
 若为nil或空数组，则查询指定坐标位置相对该监控对象上的所有服务端地理围栏的位置关系。
 */
@property (nonatomic, copy) NSArray *fenceIDs;

/**
 分页索引，选填。
 默认值为1。
 pageIndex与pageSize一起计算从第几条结果返回，代表返回第几页。
 */
@property (nonatomic, assign) NSUInteger pageIndex;

/**
 分页大小，选填。
 默认值为100。
 pageSize与pageIndex一起计算从第几条结果返回，代表返回结果中每页有几条记录。
 */
@property (nonatomic, assign) NSUInteger pageSize;


/**
 构造方法
 
 @param monitoredObject 围栏的监控对象名称
 @param customLocation 指定的位置坐标
 @param fenceIDs 服务端地理围栏的ID列表
 @param tag 请求标志
 @return 请求对象
 */
-(instancetype)initWithmonitoredObject:(NSString *)monitoredObject CustomLocation:(CLLocationCoordinate2D)customLocation coordType:(BTKCoordType)coordType fenceIDs:(NSArray *)fenceIDs serviceID:(NSUInteger)serviceID tag:(NSUInteger)tag;


@end
