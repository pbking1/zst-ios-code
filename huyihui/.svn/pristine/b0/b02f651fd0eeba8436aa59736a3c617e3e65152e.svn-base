//
//  AppDelegate.h
//  huyihui
//
//  Created by linyi on 14-2-19.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "ProductSearchViewController.h"
#import "ShoppingCartViewController.h"
#import "MinePageViewController.h"
//#import "CoordinatingController.h"
#import "ButtonFactory.h"
#import "HuEasyShoppingCart.h"
#import "SearchMyProduct.h"
#import "WXApi.h"
#import "WeiboSDK.h"
//
#import "AGViewDelegate.h"
//

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, WXApiDelegate, WeiboSDKDelegate, UIAlertViewDelegate>

@property (nonatomic,readonly) AGViewDelegate *viewDelegate;//ShareSDK_ViewDelegate

@property (retain, nonatomic) UIWindow *window;

@property (nonatomic, assign) int userPreferredImageQuality_Value;//取图质量//0：2G/3G(标清图),1：wifi（高清图）

@property (readonly, atomic) NSMutableDictionary *tempParam;

@property (retain, nonatomic) NSString *wbtoken;

@property (nonatomic, readonly) BOOL isLoggedIn;//当前用户是否已登录

@property (nonatomic, readonly) NSDictionary *userInfo;//登录成功后的用户信息字典，包含所有信息，只读

@property (nonatomic, readonly) NSDictionary *merchantInfo;//商家信息，只读

@property (nonatomic, readonly) NSString *merchantId;//商家Id

//@property (nonatomic, readonly) NSMutableArray *shoppingCart;//购物车

@property (nonatomic, readonly) UITabBarController *tabs;
@property (nonatomic,retain)  UIViewController *currentCtroller;

@property (nonatomic,retain)  NSMutableArray *regionsListArr;

//设置网络图片获取模式（其中判断网络连接状态）//
- (void)updateUserPreferredImageQuality;

//当用户退出登录后需要清除登录状态、清空购物车
- (void)loggedOut;

//当用户登录成功后需要保存登录状态
//- (void)loggedInWithUserInfo:(NSDictionary *)userInfo;
- (void)loggedInWithUserInfo:(NSDictionary *)userInfo completion:(void(^)())completionBlock;

- (void)saveWithUserInfo:(NSDictionary *)userInfo;

- (void) forcedLogOut:(id)sender;
@end
