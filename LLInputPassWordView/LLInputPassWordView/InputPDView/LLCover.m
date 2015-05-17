//
//  LLCover.m
//  BusinessAreaPlat
//
//  Created by lauren on 15/5/8.
//
//

#import "LLCover.h"

#define LLKeyWindow [UIApplication sharedApplication].keyWindow

@implementation LLCover



+(void)show{
    LLCover *view = [[LLCover alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    
    [LLKeyWindow addSubview:view];
}


+(void)dismiss{
    for (UIView *view in LLKeyWindow.subviews) {
        if ([view isKindOfClass:[LLCover class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
