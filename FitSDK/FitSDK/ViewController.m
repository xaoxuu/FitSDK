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
    
    
    FitActivity *ac = [FitSDK createActivityFitFile:^(FitActivity *activity) {
        activity.name = @"";
        [activity addRecord:^(FitActivityRecord *aRecord) {
            
        }];
    }];
    
    NSLog(@"%@", ac.path);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
