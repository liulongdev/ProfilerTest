//
//  MXRProfilerUtils.m
//  easywayout
//
//  Created by Martin.Liu on 2017/1/17.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MXRProfilerUtils.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

#import <UIKit/UIKit.h>

uint64_t MXRProfilerResidentMemoryInBytes() {
    kern_return_t rval = 0;
    mach_port_t task = mach_task_self();
    
    struct task_basic_info info = {0};
    mach_msg_type_number_t tcnt = TASK_BASIC_INFO_COUNT;
    task_flavor_t flavor = TASK_BASIC_INFO;
    
    task_info_t tptr = (task_info_t) &info;
    
    if (tcnt > sizeof(info))
        return 0;
    
    rval = task_info(task, flavor, tptr, &tcnt);
    if (rval != KERN_SUCCESS) {
        return 0;
    }
    
    return info.resident_size;
}
