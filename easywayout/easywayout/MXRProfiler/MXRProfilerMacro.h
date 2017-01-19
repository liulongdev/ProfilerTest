//
//  MXRProfilerMacro.h
//  easywayout
//
//  Created by mxr on 17/1/17.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#ifndef MXRProfilerMacro_h
#define MXRProfilerMacro_h

#import <pthread.h>

#ifndef RGBHEX
#define RGBHEX(_hex)    [UIColor \
                            colorWithRed:((float)((_hex & 0xFF0000) >> 16))/255.0 \
                            green:((float)((_hex & 0xFF00) >> 8))/255.0 \
                            blue:((float)(_hex & 0xFF))/255.0 alpha:1]
#endif
#ifndef RGBHEXA
#define RGBHEXA(_hex, _alpha)    [UIColor \
                                colorWithRed:((float)((_hex & 0xFF0000) >> 16))/255.0 \
                                green:((float)((_hex & 0xFF00) >> 8))/255.0 \
                                blue:((float)(_hex & 0xFF))/255.0 alpha:_alpha]
#endif

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void dispatch_async_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void dispatch_sync_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#endif /* MXRProfilerMacro_h */
