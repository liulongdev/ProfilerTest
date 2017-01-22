//
//  UIViewController+MXRProfier.m
//  easywayout
//
//  Created by Martin.Liu on 2017/1/22.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "UIViewController+MXRProfier.h"
#import "MXRProfilerURLProtocol.h"
#import <objc/runtime.h>

@implementation UIViewController (MXRProfier)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self mxr_swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(mxr_swizzled_viewWillAppear:)];
        [self mxr_swizzleSEL:@selector(viewDidAppear:) withSEL:@selector(mxr_swizzled_viewDidAppear:)];
    });
}

- (void)mxr_swizzled_viewWillAppear:(BOOL)animated
{
    [self mxr_swizzled_viewWillAppear:animated];
    if (![self isKindOfClass:[UINavigationController class]] && ![self isKindOfClass:[UITabBarController class]]) {
        MXRPROFILERVCURLMANAGER.currentVCClassName = NSStringFromClass(self.class);
    }
}

- (void)mxr_swizzled_viewDidAppear:(BOOL)animated
{
    [self mxr_swizzled_viewDidAppear:animated];
}

+ (void)mxr_swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
