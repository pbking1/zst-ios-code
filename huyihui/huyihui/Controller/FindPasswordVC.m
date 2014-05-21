//
//  FindPasswordVC.m
//  huyihui
//
//  Created by zaczh on 14-3-24.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "FindPasswordVC.h"

@interface FindPasswordVC ()

@end

@implementation FindPasswordVC

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
    self.title = @"忘记密码";
    self.inputVerifyText.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestForgetPassword{
    [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"请稍候",@"")];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:self.inputVerifyText.text forKey:@"email"];
    
    [RemoteManager Posts:kFORGET_PASSWORD Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
//                [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2 type:0 text:@"验证邮件已发送" duration:2.0];
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"验证邮件已发送" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:^(){
                    [self.navigationController popViewControllerAnimated:YES];
                } otherBlock:nil];
                [alert show];
                [alert release];
            }else{
                [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2 type:1 text:@"该邮箱尚未注册账户" duration:2.0];
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

- (void)dealloc {
    [_optionView release];
    [_currentVerifyName release];
    [_inputVerifyText release];
    [_inputHintLabel release];
    [_selectVerifyTypeButton release];
    [_sendBtn release];
    [super dealloc];
}
- (IBAction)onSendRecoveryEmail:(id)sender {
    [self.inputVerifyText resignFirstResponder];
    //手机号码验证//
    if([self.currentVerifyName.text isEqualToString:@"手机号码验证"]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"服务端暂不支持:\"手机号码验证\"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    //验证邮箱地址的格式是否正确//
    if(self.inputVerifyText.text == nil||[self.inputVerifyText.text isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(![Util isValidateEmail:self.inputVerifyText.text]){//验证邮箱地址的格式是否正确//
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        //向服务端发数据请求处理结果//
        [self requestForgetPassword];
    }
}

- (IBAction)onShowOption:(id)sender {
    self.optionView.hidden = !self.optionView.hidden;
    UIButton *btn = (UIButton *)sender;
    if(!self.optionView.hidden){
        [btn setImage:[UIImage imageNamed:@"list_pack up_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"list_pack up_normal"] forState:UIControlStateHighlighted];
    }else{
        [btn setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateHighlighted];
    }
}
- (IBAction)onSendPassword:(id)sender {
}
- (IBAction)onVerifyPhone:(id)sender {
    self.optionView.hidden = YES;
    [self.selectVerifyTypeButton setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateNormal];
    [self.selectVerifyTypeButton setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateHighlighted];
    self.currentVerifyName.text = @"手机号码验证";
    self.inputHintLabel.text = @"请输入手机号码";
    [self.sendBtn setTitle:@"发送验证短信" forState:UIControlStateNormal];
    self.inputVerifyText.placeholder = self.inputHintLabel.text;
}

- (IBAction)onVerifyEmail:(id)sender {
    self.optionView.hidden = YES;
    [self.selectVerifyTypeButton setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateNormal];
    [self.selectVerifyTypeButton setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateHighlighted];
    self.currentVerifyName.text = @"邮箱验证";
    self.inputHintLabel.text = @"请输入邮箱地址";
    [self.sendBtn setTitle:@"发送验证邮件" forState:UIControlStateNormal];
    self.inputVerifyText.placeholder = self.inputHintLabel.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}
@end