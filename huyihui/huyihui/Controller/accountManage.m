//
//  accountManage.m
//  huyihui
//
//  Created by zhangmeifu on 14/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "accountManage.h"
#import "ChangePasswd.h"
#import "MyKeyChainHelper.h"

@interface accountManage ()
{
    NSString *oldPasswd;
    NSString *newPasswd;
    NSString *nickName;
    NSString *telephoneNumBer;
    NSString *email;
    
    UITextField *nickNameTextField;
    UITextField *telephoneNumBerField;
    UITextField *emailField;
}

@end

@implementation accountManage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        oldPasswd=nil;
        newPasswd=nil;
        nickName=nil;
        telephoneNumBer=nil;
        email=nil;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(saveNewAccount:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *saveItem=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem=saveItem;
    [saveItem release];
    
    [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"请稍候...",@"")];
    [NSThread detachNewThreadSelector:@selector(getPersonalInfo) toTarget:self withObject:nil];
    
    _accountManageTable.scrollEnabled=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table Datasource 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil==cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        UITextField *inputField=[[[UITextField alloc]initWithFrame:CGRectMake(100, 5, 150, 30)]autorelease];
        inputField.font=[UIFont systemFontOfSize:15];
        inputField.tag=indexPath.row;
        
        
        UIButton *editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setFrame:CGRectMake(SCREEN_WIDTH-70, 5, 50, 30)];
        [editBtn setTitle:@"修改" forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(setAccountEdite:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setBackgroundColor:[UIColor redColor]];
        editBtn.layer.cornerRadius=5;
        editBtn.tag=indexPath.row;
        
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
          [cell addSubview:inputField];;
          [cell addSubview:editBtn];
        }
        else
        {
          [cell.contentView addSubview:inputField];;
          [cell.contentView addSubview:editBtn];
        }
        
    
    }
    
    NSArray *arr;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        arr=cell.subviews;
    }
    else
    {
        arr=cell.contentView.subviews;
    }
    for (UIView *view in arr)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *inputField=(UITextField *)view;
            inputField.delegate=self;
            inputField.userInteractionEnabled=NO;
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text=@"昵 称";
                    if ([APP_DELEGATE.userInfo objectForKey:@"nickName"]&&![[APP_DELEGATE.userInfo objectForKey:@"nickName"]isEqual:[NSNull null]])
                    {
                         inputField.text=[NSString stringWithFormat:@"%@",[APP_DELEGATE.userInfo objectForKey:@"nickName"]];
                    }
                   
                    nickNameTextField=inputField;
                    
                    break;
                case 1:
                    cell.textLabel.text=@"密 码";
                    inputField.text=@"*******";
                    
                    break;
                case 2:
                    cell.textLabel.text=@"手机号码";
                     telephoneNumBerField=inputField;
                    if (![[APP_DELEGATE.userInfo objectForKey:@"mobile"]isEqual:[NSNull null]])
                    {
                        inputField.text=[NSString stringWithFormat:@"%@",[APP_DELEGATE.userInfo objectForKey:@"mobile"]];
                    }
                    
                    NSLog(@"%@",APP_DELEGATE.userInfo);
                    
                    break;
                case 3:
                    cell.textLabel.text=@"邮箱地址";
                    emailField=inputField;
                    if (![[APP_DELEGATE.userInfo objectForKey:@"email"]isEqual:[NSNull null]])
                    {
                    inputField.text=[NSString stringWithFormat:@"%@",[APP_DELEGATE.userInfo objectForKey:@"email"]];
                    }
                    
                    break;
                    
                default:
                    break;
            }


        }
       
    }
    
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)getPersonalInfo
{
    NSString *userName=[MyKeyChainHelper getUserNameWithService:kKEYCHAIN_USER_NAME];
    NSString *passwd=[MyKeyChainHelper getPasswordWithService:kKEYCHAIN_USER_PASSWORD];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:userName forKey:@"userName"];
    [param setObject:passwd forKey:@"passWord"];
    
    [RemoteManager Posts:kLogin Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                [NUSD setObject:[json objectForKey:@"token"] forKey:kCurrentUserToken];
                [NUSD synchronize];
                [APP_DELEGATE saveWithUserInfo:[json objectForKey:@"subscriber"]];
                [self.accountManageTable reloadData];
            
                
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


-(void)setAccountEdite:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==1)
    {
        ChangePasswd   *passwdCtrl=[[ChangePasswd alloc]initWithNibName:@"ChangePasswd" bundle:nil];
        [self.navigationController pushViewController:passwdCtrl animated:YES];
//        passwdCtrl.block=^void(NSString *old,NSString *new){
//            oldPasswd=[old retain];
//            newPasswd=[new retain];
//        };
        [passwdCtrl release];
        
    }
    else
    {
        for (UIView *view in [btn.superview subviews] )
        {
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField=(UITextField*)view;
        
                textField.userInteractionEnabled=YES;
                [textField becomeFirstResponder];

            }
           
        }
    }
    
}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    switch (textField.tag) {
//        case 0:
//            nickName=[textField.text retain];
//            break;
//        case 2:
//            telephoneNumBer=[textField.text retain];
//            break;
//        case 3:
//            email=[textField.text retain];
//            break;
//        
//            
//        default:
//            break;
//    }
//    
//}


-(void)saveNewAccount:(id)sender
{
    nickName=[nickNameTextField.text retain];
    telephoneNumBer=[telephoneNumBerField.text retain];
    email=[emailField.text retain];
    if (nickName.length > 32)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称长度不能超过32位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (![Util isValidateMobile:telephoneNumBer])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (![Util isValidateEmail:email])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
        
        [NSThread detachNewThreadSelector:@selector(updateNewAccountToServer) toTarget:self withObject:nil];
    }
}
-(void)updateNewAccountToServer
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        if (nickName)
        {
            if (![nickName isEqualToString:[APP_DELEGATE.userInfo objectForKey:@"nickName"]])
            {
                [params setObject:nickName forKey:@"nickName"];
            }
        }
       
        if (telephoneNumBer&&![telephoneNumBer isEqualToString:@""])
        {
            if (![telephoneNumBer isEqualToString:[APP_DELEGATE.userInfo objectForKey:@"mobile"]])
            {
                [params setObject:telephoneNumBer forKey:@"mobile"];
            }
        }
        if (email)
        {
            if (![email isEqualToString:[APP_DELEGATE.userInfo  objectForKey:@"email"]])
            {
                [params setObject:email forKey:@"email"];
            }
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
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag=1;
                    alert.delegate=self;
                    [alert show];
                    [alert release];

                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            }
        }];
        [params release];

        
    }
    
}
- (void)dealloc {
    [_accountManageTable release];
    [nickName release];
    [telephoneNumBer release];
    [email release];
   

    
    [super dealloc];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
