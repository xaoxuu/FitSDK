//
//  FitSDK.m
//  FitSDK
//
//  Created by xaoxuu on 04/07/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "FitSDK.h"
#import "fit_mgr.h"

@implementation FitSDK

+ (FitActivity *)createActivityFitFile:(void (^)(FitActivity *activity))activity{
    FitActivity *act = [FitActivity new];
    if (activity) {
        activity(act);
    }
    [self createActivityFitFileWithModel:act];
    return act;
}


+ (void)createActivityFitFileWithModel:(FitActivity *)activity{
    // @xaoxuu: fit file
    const char *fp = [activity.path cStringUsingEncoding:NSUTF8StringEncoding];
    fit_transaction(fp, ^(FILE *fp) {
        [activity.records enumerateObjectsUsingBlock:^(FitActivityRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            fit_record_msg(fp, obj.timestamp, obj.position_lat, obj.position_long, obj.distance, obj.altitude, obj.speed, obj.heart_rate);
        }];
    });
}

@end
