//
//  TimerLabel.m
//  huyihui
//
//  Created by zaczh on 14-3-4.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "TimerLabel.h"

#define HEARTBEAT_INTERVAL .1

@interface TimerLabel()
@property (copy, nonatomic) NSMutableAttributedString *mutableAttrText;
//@property (retain, nonatomic) NSTimer *timer;

@property (nonatomic,assign) dispatch_queue_t timerQueue;
@property (nonatomic,assign) dispatch_source_t timerSource;

@end

@implementation TimerLabel

- (void)baseInit
{
    _beginPrefix = @"距离开始";
    _endPrefix = @"距离结束";
    _endText = @"已经结束";
    _mutableAttrText = [NSMutableAttributedString new];

    _timerQueue = dispatch_queue_create("heartbeatQueue", NULL);
    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                              0,
                                              0,
                                              _timerQueue);
    NSAssert(_timerSource != NULL, @"set heartbeat source failed.");
    dispatch_source_set_timer(_timerSource,
                              dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * HEARTBEAT_INTERVAL),
                              NSEC_PER_SEC * HEARTBEAT_INTERVAL,
                              NSEC_PER_SEC * HEARTBEAT_INTERVAL/2);
    
    dispatch_source_set_event_handler(_timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self tick];
        });
    });
    dispatch_resume(_timerSource);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self baseInit];
    }
    return self;
}

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}

- (void)setBeginTime:(NSTimeInterval)beginTime
{
    dispatch_suspend(_timerSource);
    _beginTime = beginTime;
    dispatch_resume(_timerSource);
}

- (NSArray *)timeIntervalToFlashBuyTime:(NSTimeInterval)timeInterval
{
    long  seconds = timeInterval/1000;
    long hour = 0,minute = 0,second = 0;
    
    hour = seconds/3600;
    minute = (seconds % 3600)/60;
    second = seconds % 60;
    
//    return [NSString stringWithFormat:@"%.2ld : %.2ld : %.2ld", hour, minute, second];
    return @[[NSNumber numberWithLong:hour],[NSNumber numberWithLong:minute],[NSNumber numberWithLong:second]];
}

- (void)tick
{
    long beginInterval = self.beginTime - [[NSDate date] timeIntervalSince1970]*1000;
    long endInterval = self.endTime - [[NSDate date] timeIntervalSince1970]*1000;
    
    long b_seconds = beginInterval/1000;
    long e_seconds = endInterval/1000;

    long b_hour = 0,b_minute = 0,b_second = 0;
    

    
    NSString *prefix;
    
    if(beginInterval > 0){//尚未开始
        prefix = [NSString stringWithFormat:@"%@ ", self.beginPrefix];
        b_hour = b_seconds/3600;
        b_minute = (b_seconds % 3600)/60;
        b_second = b_seconds % 60;
    }else if(endInterval > 0){//正在进行中
        prefix = [NSString stringWithFormat:@"%@ ", self.endPrefix];
        b_hour = e_seconds/3600;
        b_minute = (e_seconds % 3600)/60;
        b_second = e_seconds % 60;
    }else{//已经结束
        self.text = self.endText;
        [self setNeedsDisplay];
        return;
    }
    
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc]
                                           init];
    UIFont *font = [UIFont systemFontOfSize:11];
    UIFont *smallFont = [UIFont systemFontOfSize:9];
    UIColor *backColor = [UIColor grayColor];
    UIColor *foreColor = [UIColor whiteColor];
    
    NSAttributedString *attr0 = [[NSAttributedString alloc] initWithString:prefix attributes:@{NSFontAttributeName:font}];
    [attrText appendAttributedString:attr0];
    [attr0 release];
    
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2ld",b_hour] attributes:@{NSFontAttributeName:smallFont,NSBackgroundColorAttributeName:backColor,NSForegroundColorAttributeName:foreColor}];
    [attrText appendAttributedString:attr1];
    [attr1 release];
    
    NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:@" : " attributes:@{NSFontAttributeName:smallFont}];
    [attrText appendAttributedString:attr2];
    [attr2 release];
    
    NSAttributedString *attr3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2ld",b_minute] attributes:@{NSFontAttributeName:smallFont,NSBackgroundColorAttributeName:backColor,NSForegroundColorAttributeName:foreColor}];
    [attrText appendAttributedString:attr3];
    [attr3 release];
    
    NSAttributedString *attr4 = [[NSAttributedString alloc] initWithString:@" : " attributes:@{NSFontAttributeName:smallFont}];
    [attrText appendAttributedString:attr4];
    [attr4 release];
    
    NSAttributedString *attr5 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2ld",b_second] attributes:@{NSFontAttributeName:smallFont,NSBackgroundColorAttributeName:backColor,NSForegroundColorAttributeName:foreColor}];
    [attrText appendAttributedString:attr5];
    [attr5 release];
    
//    [attrText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 4)];
//    [attrText addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(4, attrText.length - 4)];
//    [attrText addAttribute:NSBackgroundColorAttributeName value:backColor range:NSMakeRange(5, 2)];
//    [attrText addAttribute:NSForegroundColorAttributeName value:foreColor range:NSMakeRange(5, 2)];
//    [attrText addAttribute:NSBackgroundColorAttributeName value:backColor range:NSMakeRange(10, 2)];
//    [attrText addAttribute:NSForegroundColorAttributeName value:foreColor range:NSMakeRange(10, 2)];
//    [attrText addAttribute:NSBackgroundColorAttributeName value:backColor range:NSMakeRange(15, 2)];
//    [attrText addAttribute:NSForegroundColorAttributeName value:foreColor range:NSMakeRange(15, 2)];
    self.attributedText = attrText;

    [attrText release];
    [self setNeedsDisplay];
}

- (void)dealloc
{
    dispatch_suspend(_timerSource);
    dispatch_release(_timerQueue);
    _timerQueue = NULL;
    dispatch_release(_timerSource);
    _timerSource = NULL;
    
    self.beginPrefix = nil;
    self.endPrefix = nil;
    self.mutableAttrText = nil;
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
