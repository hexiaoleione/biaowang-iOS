
//
//  Calculagraph.m
//  DelCalculagraph
//
//  Created by hehai on 16/11/24.
//  Copyright © 2016年 J. All rights reserved.
//

#import "Calculagraph.h"
#import<libkern/OSAtomic.h>

@interface Calculagraph ()
{
    BOOL isEnd;
    NSInteger count;
}

@end

@implementation Calculagraph

+(Calculagraph *)shareCalculagraph{
    static __strong Calculagraph *_shareObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareObj = [[Calculagraph alloc] init];
        [_shareObj stop];
    });
    return _shareObj;
}
-(NSInteger) getCurrentSeconds{
    return count;
}
-(void) stop{
    isEnd = YES;
}
-(void) start:(NSInteger) seconds{
    isEnd = NO;
    __block int32_t timeOutCount=seconds;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        OSAtomicDecrement32(&timeOutCount);
        count=timeOutCount;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Calculagraph" object:@(timeOutCount)];
        if (timeOutCount == 0) {
            isEnd = YES;
            dispatch_source_cancel(timer);
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{
    });
    dispatch_resume(timer);
}

+(void) startCalculagraph:(NSInteger)seconds{
    [[Calculagraph shareCalculagraph] start:seconds];
    
}
+(NSInteger) getCurrent{
    return [[Calculagraph shareCalculagraph] getCurrentSeconds];
}


@end
