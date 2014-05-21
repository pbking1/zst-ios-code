//
//  SectionFactory.h
//  huyihui
//
//  Created by linyi on 14-3-3.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionFactory : NSObject
{
    
}
+ (instancetype)factory;        //组件工厂

//- (UIButton *)createButtonWithType:(int)type;     //创建按钮
- (id)create;
@end
