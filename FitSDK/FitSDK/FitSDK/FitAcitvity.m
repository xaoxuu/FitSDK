//
//  FitAcitvity.m
//  FitSDK
//
//  Created by xaoxuu on 04/07/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "FitAcitvity.h"


@implementation FitActivity

- (instancetype)init {
    if (self = [super init]) {
        
        _records = [NSMutableArray array];
        self.type = FitActivityTypeWalk;
    }
    return self;
}


- (void)setType:(FitActivityType)type{
    _type = type;
    
    switch (type) {
        case FitActivityTypeWalk:
            _typeString = @"walk";
            break;
        case FitActivityTypeRun:
            _typeString = @"run";
            break;
        case FitActivityTypeRide:
            _typeString = @"ride";
            break;
        case FitActivityTypeSwim:
            _typeString = @"swim";
            break;
        case FitActivityTypeHike:
            _typeString = @"hike";
            break;
            
    }
}


- (void)setName:(NSString *)name{
    _name = name;
    _path = [self pathWithName:name];
}

- (void)addRecord:(void (^)(FitActivityRecord *aRecord))record{
    if (record) {
        FitActivityRecord *rec = [FitActivityRecord new];
        record(rec);
        [self.records addObject:rec];
    }
}

- (NSString *)pathWithName:(NSString *)name{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:name];
    path = [path stringByAppendingPathExtension:@"fit"];
    return path;
}

@end

@implementation FitActivityRecord

- (instancetype)init{
    if (self = [super init]) {
        _timestamp = 702940946;
        _position_lat = 0;
        _position_long = 0;
        _distance = 0;
        _altitude = 0;
        _speed = 0;
        _heart_rate = 0;
    }
    return self;
}

@end
