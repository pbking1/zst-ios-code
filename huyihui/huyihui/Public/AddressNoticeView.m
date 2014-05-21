//
//  AddressNoticeView.m
//  huyihui
//
//  Created by zhangmeifu on 23/4/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "AddressNoticeView.h"

@implementation AddressNoticeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        remindBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [remindBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        remindBtn.backgroundColor=[UIColor colorWithRed:0.847 green:0.024 blue:0.071 alpha:1.000];
        remindBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
        remindBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        
        
        [self addSubview:remindBtn];
        
        
    }
    return self;
}

-(void)addressNoticeViewAnimationWithTitle:(NSString *)title andTimeDuration:(NSTimeInterval)timeInterval

{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [remindBtn setTitle:title forState:UIControlStateNormal];
        [self setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        
        [APP_DELEGATE.window addSubview:self];
    } completion:^(BOOL finished) {
        NSLog(@"finish!");
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(removeBtnFromSuperView) userInfo:nil repeats:NO];
}


-(void)removeBtnFromSuperView
{
    [self removeFromSuperview];
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
