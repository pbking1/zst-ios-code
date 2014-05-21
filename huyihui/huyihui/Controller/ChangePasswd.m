//
//  ChangePasswd.m
//  huyihui
//
//  Created by zhangmeifu on 8/4/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "ChangePasswd.h"
#import "MyKeyChainHelper.h"

@interface ChangePasswd ()

@end

@implementation ChangePasswd

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
    self.title=@"修改密码";
    // Do any additional setup after loading the view from its nib.
    [_confirmBtn addTarget:self action:@selector(confirmNewPasswdAction:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor colorWithWhite:0.918 alpha:1.000];
    _oldPasswdField.secureTextEntry=YES;
    _newPasswdField.secureTextEntry=YES;
    _repeatNewPasswdField.secureTextEntry=YES;
    _confirmBtn.layer.cornerRadius=5;
    
    UIButton *cancellBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancellBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [cancellBtn addTarget:self action:@selector(cancellAndPopback:) forControlEvents:UIControlEventTouchUpInside];
    [cancellBtn setTitle:@"取消" forState:UIControlStateNormal];
    UIBarButtonItem *cancellItem=[[UIBarButtonItem alloc]initWithCustomView:cancellBtn];
    self.navigationItem.rightBarButtonItem=cancellItem;
    [cancellItem release];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_oldPasswdField release];
    [_newPasswdField release];
    [_repeatNewPasswdField release];
    [_confirmBtn release];
    [super dealloc];
}

-(void)cancellAndPopback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmNewPasswdAction:(id)sender
{
    if ([_oldPasswdField.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"请输入旧密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
    else if ([_newPasswdField.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"请输入新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
    else if ([_repeatNewPasswdField.text length]==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"请确认新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
    else if (![self CheckInput:_newPasswdField.text] || ![self CheckInput:_repeatNewPasswdField.text])
    {
        //Regex(^[a-zA-Z0-9]{6,20}$)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6-20位的字母或数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (![_newPasswdField.text isEqualToString:_repeatNewPasswdField.text])
    {
        //Regex(^[a-zA-Z0-9]{6,20}$)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次新密码输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (![Util isValidateNormPwd:_newPasswdField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的密码过于简单，请使用字母、数字或字符相互叠加组成！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
        [NSThread detachNewThreadSelector:@selector(updateNewAccountToServer) toTarget:self withObject:nil];
        
    }
}


-(BOOL)CheckInput:(NSString *)checkTextString
{
    NSString *regex=@"^[a-zA-Z0-9]{6,20}$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:checkTextString];
    
}

-(void)updateNewAccountToServer
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        if (_oldPasswdField.text)
        {
            [params setObject:_oldPasswdField.text forKey:@"passwordPre"];
            
        }
        if (_newPasswdField.text)
        {
            [params setObject:_newPasswdField.text forKey:@"password"];
            
        }
       
        
        [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
        [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
        [RemoteManager Posts:kEDIT_SUBSCRIBERINFO Parameters:params WithBlock:^(id json, NSError *error) {
            [CustomBezelActivityView removeViewAnimated:YES];
            if (error==nil)
            {
                
                NSLog(@"JSON IS %@",json);
                if ([[json objectForKey:@"state"]intValue]==1)
                {
//                    [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2 type:0 text:@"密码修改成功" duration:2];
                    [NUSD setObject:[json objectForKey:@"token"] forKey:kCurrentUserToken];
                    [MyKeyChainHelper saveUserName:[NUSD objectForKey:kCurrentUserName] userNameService:kKEYCHAIN_USER_NAME password:_newPasswdField.text passwordService:kKEYCHAIN_USER_PASSWORD];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag=1;
                    [alert show];
                    [alert release];
                
                    
                }
                else
                {
//                    [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2 type:1 text:@"密码修改失败" duration:2];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[json objectForKey:@"message"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"旧密码输入错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
//                    [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2 type:1 text:[NSString stringWithFormat:@"%@",[json objectForKey:@"message"]] duration:2];
                }
            }
            else
            {
//                [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2 type:1 text:@"密码修改失败" duration:2];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            }
        }];
        [params release];
        
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
