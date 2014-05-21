//
//  UIButton+IdxAddtionButton.m
//  huyihui
//
//  Created by linyi on 14-3-11.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+IdxAddtionButton.h"

@implementation UIButton (IdxAddtionButton)

- (NSInteger)idx
{
    NSInteger idx = objc_getAssociatedObject(self, kBUTTONIDXKEY);
    return idx;
}

- (void)setIdx:(NSInteger)idx
{
    objc_setAssociatedObject(self, kBUTTONIDXKEY, idx, OBJC_ASSOCIATION_ASSIGN);
}

@end
