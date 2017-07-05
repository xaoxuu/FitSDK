//
//  FitSDK.h
//  FitSDK
//
//  Created by xaoxuu on 04/07/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FitAcitvity.h"


@interface FitSDK : NSObject


/**
 创建一个活动数据fit文件

 @param activity 活动数据
 @return 活动数据模型
 */
+ (FitActivity *)createActivity:(void (^)(FitActivity *activity))activity;


@end
