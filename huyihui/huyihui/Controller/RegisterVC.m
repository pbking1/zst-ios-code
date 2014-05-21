//
//  RegisterVC.m
//  huyihui
//
//  Created by zaczh on 14-3-12.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "RegisterVC.h"
#import "Util.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIImage *img1 = [UIImage imageNamed:@"商品详情-收藏商品"];
//    UIImage *img2 = [UIImage imageNamed:@"商品详情-本单详情"];
//    UIImage *img3 = [UIImage imageNamed:@"商品详情-服务承诺"];
//    assert(img1 && img2 && img3);
//    self.captchaIV.animationImages = @[img1,img2,img3];
//    self.captchaIV.animationDuration = 3.0f;
//    [self.captchaIV startAnimating];
//    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
//        self.topbarHeightConstraint.constant = 44.0f;
//    }else{
//        self.topbarHeightConstraint.constant = 64.0f;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self becomeFirstResponder];
}

- (IBAction)onLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onRegister:(id)sender {
    if(self.accountText.text == nil||[self.accountText.text isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if (self.passwordText.text == nil||[self.passwordText.text isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(self.emailText.text == nil||[self.emailText.text isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(![Util isValidateEmail:self.emailText.text]){//验证邮箱地址的格式是否正确//
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if((self.passwordText.text.length < 6) || (self.passwordText.text.length > 20)){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入6-20位的字母或数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(![self.passwordText.text isEqualToString:self.confirmPasswordText.text]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if (![Util isValidateNormPwd:self.passwordText.text])
    {
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"您的密码过于简单，请使用字母、数字或字符相互叠加组成！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"请稍候...",@"")];
        [self requestRegisterCheckSuccess:^{
            [self requestRegister];
        } failure:^(NSString *msg) {
            [CustomBezelActivityView removeViewAnimated:YES];
            ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }];
    }
}

- (void)dealloc {
    self.successBlock = nil;
    [_captchaIV release];
    [_accountText release];
    [_passwordText release];
    [_emailText release];
    [_confirmPasswordText release];
//    [_topbarHeightConstraint release];
    [super dealloc];
}

- (void)requestRegisterCheckSuccess:(void (^)())block failure:(void (^)(NSString *msg))failure{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:self.accountText.text forKey:@"userName"];
    [param setObject:self.passwordText.text forKey:@"passWord"];
    [param setObject:self.passwordText.text forKey:@"rePassWord"];
    [param setObject:self.emailText.text forKey:@"email"];
    
    [RemoteManager Posts:kCHECK_SUBSCRIBER_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                if(block != NULL){
                    block();
                }
                
            }else{
                if(failure != NULL){
                    failure([json objectForKey:@"message"]);
                }
                
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 0:%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }];
    [param release];
}

- (void)requestRegister{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:self.accountText.text forKey:@"userName"];
    [param setObject:self.passwordText.text forKey:@"passWord"];
    [param setObject:self.emailText.text forKey:@"email"];
    
    [RemoteManager Posts:kREGISTRATION Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"注册成功！" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:^(){
                    if(self.successBlock != NULL){
                        self.successBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } otherBlock:nil];
                [alert show];
                [alert release];
                

                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 0:%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }];
    [param release];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self becomeFirstResponder];
}

@end
