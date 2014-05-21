//
//  ZacNoticeView.m
//  huyihui
//
//  Created by zaczh on 14-4-1.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ZacNoticeView.h"
@interface ZacNoticeView()
@property (nonatomic,assign) dispatch_queue_t timerQueue;
@property (nonatomic,assign) dispatch_source_t timerSource;
@property (nonatomic,retain) ZacNoticeView *sharedInstance;
@end

@implementation ZacNoticeView

- (void)baseInit{
    self.backgroundColor = [UIColor colorWithRed:121/255.0
                                           green:121/255.0
                                            blue:120/255.0
                                           alpha:1.0];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.tag = 1;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    imageView.frame = CGRectMake(8, 5, 24, 24);
    [self addSubview:imageView];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:.0]
                           ]];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24.0f]];
    
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 240, 16)];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.text = self.text;
    label.tag = 2;
    [self addSubview:label];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10.0],
                           [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:.0]
                           ]];
    
    [label release];
    
    _duration = 3.0f;
    
    _timerQueue = dispatch_queue_create("timerQueue", NULL);
    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                          0,
                                          0,
                                          _timerQueue);
    NSAssert(_timerSource != NULL, @"set timer source failed.");
    dispatch_source_set_timer(_timerSource,
                              dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * _duration),
                              NSEC_PER_SEC * _duration,
                              0);
    
    dispatch_source_set_event_handler(_timerSource, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    });
    dispatch_resume(_timerSource);
}

- (void)setText:(NSString *)text{
    UILabel *label = (UILabel *)[self viewWithTag:2];
    label.text = text;
}

- (void)setImage:image{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:1];
    imageView.image = image;
}

- (void)setDuration:(CGFloat)duration{
    _duration = duration;
    dispatch_source_set_timer(_timerSource,
                              dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * _duration),
                              NSEC_PER_SEC * _duration,
                              0);
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

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self baseInit];
    }
    return self;
}

- (void)dealloc
{
    dispatch_suspend(_timerSource);
    dispatch_release(_timerQueue);
    _timerQueue = NULL;
    dispatch_release(_timerSource);
    _timerSource = NULL;
    
    self.image = nil;
    self.text = nil;
    [super dealloc];
}

- (void)dismiss{
    [self removeFromSuperview];
}

+ (void)showAtYPosition:(CGFloat)yPosition
                 image:(UIImage *)image
                  text:(NSString *)text
              duration:(CGFloat)duration{
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15]];
    CGFloat width = 10 + 24 + 10 + textSize.width + 10;
    ZacNoticeView *notice = [[ZacNoticeView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, yPosition, width, 34)];
    notice.text = text;
    notice.image = image;
    notice.duration = duration;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:notice];
    
    [notice release];
}

+ (void)showAtYPosition:(CGFloat)yPosition
                   type:(NSInteger)type
                   text:(NSString *)text
               duration:(CGFloat)duration{
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15]];
    CGFloat width = 10 + 24 + 10 + textSize.width + 10;
    ZacNoticeView *notice = [[ZacNoticeView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, yPosition, width, 34)];
    notice.text = text;
    if(type == 0){
        notice.image = [UIImage imageNamed:@"3-02checkout_center_03_success"];
    }else if(type == 1){
        notice.image = [UIImage imageNamed:@"3-02checkout_center_04_fail"];
    }
    notice.duration = duration;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    notice.alpha = .0f;
    [appDelegate.window addSubview:notice];
    [UIView animateWithDuration:0.5 animations:^{
        notice.alpha = 1.0f;
    }];
    
    [notice release];
}
@end
