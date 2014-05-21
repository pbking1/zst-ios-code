//
//  ZacFloatInputView.h
//  huyihui
//
//  Created by zaczh on 14-4-3.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

@protocol ZacFloatInputViewDelegate;

#import <UIKit/UIKit.h>

@interface ZacFloatInputView : UIView<UITextFieldDelegate>

@property (assign, nonatomic) id<ZacFloatInputViewDelegate>delegate;

- (id)initWithTitle:(NSString *)title
       initialValue:(NSString *)initialValue
           maxValue:(NSString *)maxValue
           delegate:(id<ZacFloatInputViewDelegate>)delegate;

- (id)initWithTitle:(NSString *)title
       initialValue:(NSString *)initialValue
           maxValue:(NSString *)maxValue
         completion:(void (^)(NSString *))completeBlock;

- (void)show;
@end


@protocol ZacFloatInputViewDelegate<NSObject>

- (void)ZacFloatInputView:(ZacFloatInputView *)view didInputValue:(NSString *)value;

@end