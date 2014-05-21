//
//  ZacNoticeView.h
//  huyihui
//
//  Created by zaczh on 14-4-1.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZacNoticeView : UIView

@property (retain, nonatomic) UIImage *image;

@property (copy, nonatomic) NSString *text;

//@property (assign, nonatomic) CGFloat width;
//
//@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGFloat duration;

+ (void)showAtYPosition:(CGFloat)yPosition
                  image:(UIImage *)image
                   text:(NSString *)text
               duration:(CGFloat)duration;

+ (void)showAtYPosition:(CGFloat)yPosition
                   type:(NSInteger)type //type=0 显示操作成功图片 1 显示操作失败图片
                   text:(NSString *)text
               duration:(CGFloat)duration;
@end
