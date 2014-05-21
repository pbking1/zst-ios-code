//
//  ActivateCouponViewController.m
//  huyihui
//
//  Created by zaczh on 14-3-6.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ActivateCouponViewController.h"

@interface ActivateCouponViewController ()

@end

@implementation ActivateCouponViewController

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
    ButtonFactory *bf = [[ButtonFactory alloc] init];
    UIButton *rightBtn = [bf createButtonWithType:HuEasyButtonTypeConfirm];
    [bf release];
    [rightBtn addTarget:self action:@selector(onActivateCoupon:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem release];
}

- (void)requestActivateCoupon:(NSString *)couponPasswd
                      success:(void (^)())successBlock
                      failure:(void (^)())failureBlock
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"请稍候", @"")];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:couponPasswd forKey:@"couponPassword"];
    
    [RemoteManager Posts:kACTIVATION_COUPON Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                successBlock();
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                failureBlock();
            }
        }else{
            NSLog(@"network error 0:%@",error);
            failureBlock();
        }
    }];
    [param release];
}

- (void)onActivateCoupon:(UIButton *)sender{
    NSString *password = [self.passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!password || [password isEqualToString:@""]){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"")
                                                          message:NSLocalizedString(@"请填写优惠券密码", @"")
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }else{
        [self requestActivateCoupon:password success:^{
            ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"")
                                                              message:NSLocalizedString(@"成功激活优惠券！", @"") cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitle:nil cancelBlock:^{
                                                                  [self.navigationController popViewControllerAnimated: YES];
                                                              } otherBlock:nil];
            [alert show];
            [alert release];
        } failure:^{
            ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"")
                                                              message:NSLocalizedString(@"激活优惠券失败。", @"")
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
            [alert show];
            [alert release];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_passwordTF release];
    [super dealloc];
}
@end
