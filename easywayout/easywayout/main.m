//
//  main.m
//  easywayout
//
//  Created by Martin.Liu on 2017/1/1.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <FBAllocationTracker/FBAllocationTracker.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>

int main(int argc, char * argv[]) {
//    [FBAssociationManager hook];
//    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
//    [[FBAllocationTrackerManager sharedManager] enableGenerations];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
