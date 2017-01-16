//
//  MXRProfilerTool.m
//  easywayout
//
//  Created by Martin.Liu on 2017/1/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MXRProfilerTool.h"
#import "MXRProfilerWindow.h"
#import "MXRProfilerWindowTouchesHandling.h"
#import "MXRProfilerContainerViewController.h"
#import "MXRProfilerSimpleInfoViewController.h"
static const NSUInteger kFBFloatingButtonSize = 100.0;

@interface MXRProfilerTool() <MXRProfilerWindowTouchesHandling>

@property (nonatomic, strong) MXRProfilerWindow *profilerWindow;

@end

@implementation MXRProfilerTool
{
    MXRProfilerContainerViewController *_containerViewController;
    
    MXRProfilerSimpleInfoViewController *_simpleInfoViewController;
}

- (MXRProfilerWindow *)profilerWindow
{
    if (!_profilerWindow) {
        _profilerWindow = [[MXRProfilerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _profilerWindow.hidden = NO;
        _profilerWindow.touchesDelegate = self;
    }
    return _profilerWindow;
}


- (void)startAnalyze
{
    _containerViewController = [[MXRProfilerContainerViewController alloc] init];
    self.profilerWindow.rootViewController = _containerViewController;
    
    [_containerViewController dismissCurrentViewController];
    _simpleInfoViewController = [MXRProfilerSimpleInfoViewController new];
    
    [_containerViewController presentViewController:_simpleInfoViewController
                                           withSize:CGSizeMake(kFBFloatingButtonSize,
                                                               kFBFloatingButtonSize)];
}

- (void)endAnalyze
{
    
}

#pragma mark - MXRProfilerWindowTouchesHandling
- (BOOL)mxr_window:(UIWindow *)window shouldReceiveTouchAtPoint:(CGPoint)point
{
    return CGRectContainsPoint(_simpleInfoViewController.view.bounds,
                               [_simpleInfoViewController.view convertPoint:point
                                                                 fromView:window]);
}

@end
