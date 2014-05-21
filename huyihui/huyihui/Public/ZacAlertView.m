//
//  ZacAlertView.m
//  huyihui
//
//  Created by zaczh on 14-3-13.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ZacAlertView.h"
@interface ZacAlertView()

@end

@implementation ZacAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitle:(NSString *)otherButtonTitle
        cancelBlock:(void (^)(void))cancelBlock
         otherBlock:(void (^)(void))otherBlock{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    if(otherBlock){
        _otherBlock = Block_copy(otherBlock);
    }
    if(cancelBlock){
        _cancelBlock = Block_copy(cancelBlock);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if(_cancelBlock){
            _cancelBlock();
        }
    }else if (buttonIndex == 1){
        if(_otherBlock){
            _otherBlock();
        }
    }
}

- (void)dealloc{
    if(_otherBlock){
        Block_release(_otherBlock);
    }
    if(_cancelBlock){
        Block_release(_cancelBlock);
    }
    [super dealloc];
}

@end
