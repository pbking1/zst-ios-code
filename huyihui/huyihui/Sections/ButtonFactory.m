//
//  ButtonFactory.m
//  huyihui
//
//  Created by linyi on 14-3-6.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ButtonFactory.h"

@implementation ButtonFactory

+ (instancetype)factory
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)create
{
    UIButton *btn = [[[[self class] alloc] init] autorelease];
    return btn;
}

- (CreateButton *)createButtonWithType:(HuEasyButtonType)type
{
    CreateButton *btn = [[[CreateButton alloc] initWithType:type] autorelease];
    return btn;
}

@end
