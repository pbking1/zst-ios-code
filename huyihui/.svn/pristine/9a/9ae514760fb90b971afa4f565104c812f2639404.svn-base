//
//  ZacAlertView.h
//  huyihui
//
//  Created by zaczh on 14-3-13.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

/***************************************
    Forget the delegate, using block!
 ***************************************/

#import <UIKit/UIKit.h>

@interface ZacAlertView : UIAlertView<UIAlertViewDelegate>

@property (copy, nonatomic) void (^otherBlock)(void);
@property (copy, nonatomic) void (^cancelBlock)(void);

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitle:(NSString *)otherButtonTitle
        cancelBlock:(void (^)(void))cancelBlock
            otherBlock:(void (^)(void))okBlock;
@end
