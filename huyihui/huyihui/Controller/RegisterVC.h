//
//  RegisterVC.h
//  huyihui
//
//  Created by zaczh on 14-3-12.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : BaseViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *captchaIV;

//注册成功后的回调，可以在这里添加自定义操作
@property (retain, nonatomic) IBOutlet UITextField *accountText;
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (retain, nonatomic) IBOutlet UITextField *emailText;
//（例如，用户进到某个需要登录的页面，登录或注册完成后可继续该操作。
@property (retain, nonatomic) IBOutlet UITextField *confirmPasswordText;
//@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topbarHeightConstraint;
@property (nonatomic, copy) void(^successBlock)(void);
@end
