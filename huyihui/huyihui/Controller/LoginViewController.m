//
//  LoginViewController.m
//  huyihui
//
//  Created by zaczh on 14-2-24.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterVC.h"
#import "MyKeyChainHelper.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav bar底图"] forBarMetrics:UIBarMetricsDefault];
//    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
//        self.topBarHeightConstraint.constant = 44.0f;
//    }else{
//        self.topBarHeightConstraint.constant = 64.0f;
//    }
    
    UIButton *leftBtn = [[ButtonFactory factory] createButtonWithType:HuEasyButtonTypeCancel];
    [leftBtn addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    self.title = @"登录";
    
    self.accountText.text = [MyKeyChainHelper getUserNameWithService:kKEYCHAIN_USER_NAME];
    self.passwordText.text = @""; //[MyKeyChainHelper getPasswordWithService:kKEYCHAIN_USER_PASSWORD];
}

- (void)dealloc{
    self.successBlock = nil;
//    [_topBarHeightConstraint release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestLogin{
    [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"正在登录...",@"")];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:self.accountText.text forKey:@"userName"];
    [param setObject:self.passwordText.text forKey:@"passWord"];
    
    [RemoteManager Posts:kLogin Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                [NUSD setObject:[json objectForKey:@"token"] forKey:kCurrentUserToken];
                [NUSD synchronize];
                [APP_DELEGATE loggedInWithUserInfo:[json objectForKey:@"subscriber"] completion:self.successBlock];
                [self dismissViewControllerAnimated:YES completion:nil];
                //记住密码
                [MyKeyChainHelper saveUserName:self.accountText.text userNameService:kKEYCHAIN_USER_NAME password:self.passwordText.text passwordService:kKEYCHAIN_USER_PASSWORD];
                [NSThread detachNewThreadSelector:@selector(getDeliveryInfoFromServer) toTarget:self withObject:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

- (IBAction)doLogin:(id)sender;
{
    if(self.accountText.text == nil || [self.accountText.text isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if (self.passwordText.text == nil || [self.passwordText.text isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        [self requestLogin];
    }
}

-(void)getDeliveryInfoFromServer
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
        [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
        [params setObject:[NSNumber numberWithInt:5] forKey:@"num"];
        [params setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
        [RemoteManager Posts:kGET_DELIVERY_INFO Parameters:params WithBlock:^(id json, NSError *error) {
            if (error==nil)
            {
                [CustomActivityView removeView];
//                NSLog(@"%@",json);
                NSArray  *addressArr=[json objectForKey:@"deliveryInfoList"];
                for (NSDictionary *dic in addressArr)
                {
                    if ([[dic objectForKey:@"latestAdd"]intValue]==1)
                    {
                        
                        [NUSD setValue:[NSKeyedArchiver archivedDataWithRootObject:dic] forKey:kUserDefaultAddress];
                        [NUSD synchronize];
//                        NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData: [NUSD objectForKey:kUserDefaultAddress]]);
                    }
                }
                
                
            }
        }];
        [params release];
    }
    
}



- (BOOL)canBecomeFirstResponder{
    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self becomeFirstResponder];
}

- (IBAction)onCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onRegister:(id)sender {
    RegisterVC *reg = [RegisterVC new];
//    reg.successBlock = ^(){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功，请登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    };
    [self.navigationController pushViewController:reg animated:YES];
    [reg release];
}

- (IBAction)onForgetPassword:(id)sender {
    FindPasswordVC *findPasswd = [[FindPasswordVC alloc] init];
    [self.navigationController pushViewController:findPasswd animated:YES];
    [findPasswd release];
}
@end
