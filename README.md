# FitSDK
FitSDK for iOS https://www.thisisant.com/resources/fit

## 相关下载

- [FitSDKRelease_20.35.00.zip](https://github.com/xaoxuu/FitSDK/releases/download/1.0.0/FitSDKRelease_20.35.00.zip)




## 配置环境

导入头文件

```objective-c
#import "FitSDK.h"
```



## 使用示例

```objective-c
FitActivity *activity = [FitSDK createActivity:^(FitActivity *activity) {
    activity.name = @"test";
    activity.type = FitActivityTypeRun;
    for (int i = 0; i<100; i++) {
        [activity addRecord:^(FitActivityRecord *aRecord) {
            aRecord.timestamp = [[NSDate date] timeIntervalSince1970] - 631065600;
            aRecord.position_lat = 495280430+i*1000;
            aRecord.position_long = -872696681-i*1500;
            aRecord.distance = 2+i/100;
            aRecord.altitude = 287.2+i;
            aRecord.speed = 0.29+i/50;
            aRecord.heart_rate = 68+i/4;
        }];
    }
}];
// activity.path就是生成的fit文件路径
NSLog(@"%@", activity.path);
```

