//
//  FeedbackViewController.m
//  huyihui
//
//  Created by zaczh on 14-4-21.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (nonatomic, retain) UIScrollView *wrapView;
@property (nonatomic, retain) UITextView *feedbackTextView;
@property (nonatomic, retain) UITextField *contactMeansTextField;
@end

@implementation FeedbackViewController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1.0];
    self.title = @"意见反馈";
    
    _wrapView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_wrapView addGestureRecognizer:tap];
    [tap release];
    
    UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    contentTitle.font = [UIFont systemFontOfSize:13];
    contentTitle.backgroundColor = [UIColor clearColor];
    contentTitle.text = @"请输入您的意见";
    contentTitle.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
    [_wrapView addSubview:contentTitle];
    [contentTitle release];
    
    _feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 180)];
    _feedbackTextView.delegate = (id<UITextViewDelegate>)self;
    _feedbackTextView.font = [UIFont systemFontOfSize:13];
    [_wrapView addSubview:_feedbackTextView];
    
    UILabel *contactInfoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 200, 20)];
    contactInfoTitle.font = [UIFont systemFontOfSize:13];
    contactInfoTitle.backgroundColor = [UIColor clearColor];
    contactInfoTitle.text = @"您的联系方式";
    contactInfoTitle.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
    [_wrapView addSubview:contactInfoTitle];
    [contactInfoTitle release];
    
    _contactMeansTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 260, 300, 44)];
    _contactMeansTextField.delegate = self;
    _contactMeansTextField.backgroundColor = [UIColor whiteColor];
    _contactMeansTextField.font = [UIFont systemFontOfSize:15];
    _contactMeansTextField.placeholder = @"请输入您的姓名、邮箱、QQ号码等";
    [_wrapView addSubview:_contactMeansTextField];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 314, 290, 50)];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    submitButton.titleLabel.textColor = [UIColor whiteColor];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"5-02registered_registered button_normal"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_wrapView addSubview:submitButton];
    [submitButton release];
    
    _wrapView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 150);
    
    [self.view addSubview:_wrapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)checkInput{
    BOOL res = NO;
    if(![_feedbackTextView.text isEqualToString:@""] && ![_contactMeansTextField.text isEqualToString:@""]){
        res = YES;
    }
    return res;
}

- (void)tap:(UIGestureRecognizer *)gesture{
    [self becomeFirstResponder];
}

- (void)onSubmit:(id)sender{
    if(![self checkInput]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"意见反馈" message:@"反馈意见和联系方式不能为空" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:nil otherBlock:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSDictionary *param = @{
                           @"merchantId":[NUSD objectForKey:kMerchantId],
                           @"userKo":[NUSD objectForKey:kCurrentUserId],
                           @"token":[NUSD objectForKey:kCurrentUserToken],
                           @"suggestion":_feedbackTextView.text,
                           @"contact":_contactMeansTextField.text
                           };
    [RemoteManager Posts:kADD_SUGGESTION_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([json[@"state"] integerValue] == 1){
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"意见反馈" message:@"您的反馈意见已经提交" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } otherBlock:nil];
                [alert show];
                [alert release];
            }else{
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"意见反馈" message:[NSString stringWithFormat:@"反馈意见提交失败：%@",json[@"message"]] cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:nil otherBlock:nil];
                [alert show];
                [alert release];
            }
        }else{
            [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 + 100 type:1 text:@"网络连接失败，请检查你的网络" duration:1.5];
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;{
    CGRect rect = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, SCREEN_WIDTH, 400);
    [_wrapView scrollRectToVisible:rect animated:YES];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView;{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, textView.frame.size.height);
    [_wrapView scrollRectToVisible:rect animated:YES];
}
@end
