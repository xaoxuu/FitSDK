//
//  ViewController.m
//  FitSDK
//
//  Created by xaoxuu on 04/07/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "ViewController.h"
#import "FitSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
