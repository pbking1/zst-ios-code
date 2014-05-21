//
//  TimerLabel.h
//  huyihui
//
//  Created by zaczh on 14-3-4.
//  Copyright (c) 2014年 linyi. All rights reserved.
//
//一个显示倒计时的标签

#import <UIKit/UIKit.h>

@interface TimerLabel : UILabel

//开始时间(自1970以来的毫秒数)
@property (assign, nonatomic) NSTimeInterval beginTime;

//结束时间(自1970以来的毫秒数)
@property (assign ,nonatomic) NSTimeInterval endTime;

//事件尚未开始时显示日期的前缀，如“距离开始”
@property (copy, nonatomic) NSString *beginPrefix;

//事件将要结束时显示日期的前缀，如“距离结束”
@property (copy, nonatomic) NSString *endPrefix;

//事件结束后显示的内容，如“已结束”
@property (copy, nonatomic) NSString *endText;

@end
