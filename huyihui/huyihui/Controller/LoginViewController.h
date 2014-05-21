//
//  LoginViewController.h
//  huyihui
//
//  Created by zaczh on 14-2-24.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"
#import "FindPasswordVC.h"


@interface LoginViewController : BaseViewController

@property (retain, nonatomic) IBOutlet UITextField *accountText;

@property (retain, nonatomic) IBOutlet UITextField *passwordText;

@property (retain, nonatomic) IBOutlet UIButton *loginBtn;

@property (retain, nonatomic) IBOutlet UIButton *registerBtn;

@property (retain, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

- (IBAction)doLogin:(id)sender;

//@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)onRegister:(id)sender;
- (IBAction)onForgetPassword:(id)sender;
//@property (retain, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConstraint;

//如果你想在登录后进行一些额外的操作，请加到下面的block中
@property (nonatomic, copy) void(^successBlock)(void);



@end
