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
