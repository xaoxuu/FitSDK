//
//  FitAcitvity.h
//  FitSDK
//
//  Created by xaoxuu on 04/07/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>



@class FitActivityRecord;
typedef NS_ENUM(NSUInteger, FitActivityType) {
    FitActivityTypeWalk,
    FitActivityTypeRun,
    FitActivityTypeRide,
    FitActivityTypeSwim,
    FitActivityTypeHike,
};

@interface FitActivity : NSObject

// @xaoxuu: fit 文件路径
@property (copy, readonly, nonatomic) NSString *path;

// @xaoxuu: 活动名
@property (copy, nonatomic) NSString *name;

// @xaoxuu: 活动类型
@property (assign, nonatomic) FitActivityType type;

// @xaoxuu: 活动类型
@property (copy, readonly, nonatomic) NSString *typeString;


// @xaoxuu: records
@property (strong, nonatomic) NSMutableArray<FitActivityRecord *> *records;


/**
 添加一条record

 @param record record
 */
- (void)addRecord:(void (^)(FitActivityRecord *aRecord))record;


@end

@interface FitActivityRecord : NSObject

// @xaoxuu: timestamp
@property (assign, nonatomic) unsigned int timestamp;

// @xaoxuu: position_lat
@property (assign, nonatomic) int position_lat;

// @xaoxuu: position_long
@property (assign, nonatomic) int position_long;

// @xaoxuu: distance
@property (assign, nonatomic) unsigned int distance;

// @xaoxuu: altitude
@property (assign, nonatomic) unsigned short altitude;

// @xaoxuu: speed
@property (assign, nonatomic) unsigned short speed;

// @xaoxuu: heart_rate
@property (assign, nonatomic) unsigned char heart_rate;


@end
