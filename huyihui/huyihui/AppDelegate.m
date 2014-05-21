//
//  AppDelegate.m
//  huyihui
//
//  Created by linyi on 14-2-19.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h"
#import "LoginViewController.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <sys/utsname.h>
//#import "ChooseReceiptType.h"
//#import "CheckOutCenterViewController.h"
//#import "MoreConfigure.h"
#import "SearchMyProduct.h"
//shareSDK//
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "WXApi.h"
#import "YXApi.h"
//
#import <RennSDK/RennSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Pinterest/Pinterest.h>
//
#import "AGViewDelegate.h"


@interface AppDelegate()
@property (assign, nonatomic) BOOL isLoggedIn;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, retain) UITabBarController *tabs;
@property (nonatomic, copy) NSDictionary *merchantInfo;//商家信息，只读

//@property (nonatomic,readwrite) AGViewDelegate *viewDelegate;
@end

@implementation AppDelegate
@synthesize tabs;
@synthesize currentCtroller=_currentCtroller;
@synthesize regionsListArr=_regionsListArr;
@synthesize viewDelegate=pzz_viewDelegate;//ShareSDK_ViewDelegate

- (id)init
{
    if(self = [super init])
    {
        pzz_viewDelegate = [[AGViewDelegate alloc] init];
    }
    return self;
}
- (void)dealloc
{
    [tabs release];
    [_window release];
    [_tempParam release];
    self.wbtoken = nil;
    self.regionsListArr=nil;
    [super dealloc];
}

- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     //appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接Facebook应用以使用相关功能，此应用需要引用FacebookConnection.framework
     https://developers.facebook.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    /**
     连接Twitter应用以使用相关功能，此应用需要引用TwitterConnection.framework
     https://dev.twitter.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接Google+应用以使用相关功能，此应用需要引用GooglePlusConnection.framework、GooglePlus.framework和GoogleOpenSource.framework库
     https://code.google.com/apis/console上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectGooglePlusWithClientId:@"232554794995.apps.googleusercontent.com"
                               clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                redirectUri:@"http://localhost"
                                  signInCls:[GPPSignIn class]
                                   shareCls:[GPPShare class]];
    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppId:@"226427"
                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
                   renrenClientClass:[RennClient class]];
    
    /**
     连接开心网应用以使用相关功能，此应用需要引用KaiXinConnection.framework
     http://open.kaixin001.com上注册开心网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    
    /**
     连接易信应用以使用相关功能，此应用需要引用YiXinConnection.framework
     http://open.yixin.im/上注册易信开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
                           yixinCls:[YXApi class]];
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接打印
    [ShareSDK connectAirPrint];
    
    //连接拷贝
    [ShareSDK connectCopy];
    
    /**
     连接搜狐微博应用以使用相关功能，此应用需要引用SohuWeiboConnection.framework
     http://open.t.sohu.com上注册搜狐微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuWeiboWithConsumerKey:@"q70QBQM9T0COxzYpGLj9"
                               consumerSecret:@"XXYrx%QXbS!uA^m2$8TaD4T1HQoRPUH0gaG2BgBd"
                                  redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
     http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    
    /**
     连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
     http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
                            appSecret:@"9f1e7b4f71304f2f"
                          redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接印象笔记应用以使用相关功能，此应用需要引用EverNoteConnection.framework
     http://dev.yinxiang.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807"
                       consumerSecret:@"d05bf86993836004"];
    
    /**
     连接LinkedIn应用以使用相关功能，此应用需要引用LinkedInConnection.framework库
     https://www.linkedin.com/secure/developer上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectLinkedInWithApiKey:@"ejo5ibkye3vo"
                              secretKey:@"cC7B2jpxITqPLZ5M"
                            redirectUri:@"http://sharesdk.cn"];
    
    /**
     连接Pinterest应用以使用相关功能，此应用需要引用Pinterest.framework库
     http://developers.pinterest.com/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectPinterestWithClientId:@"1432928"
                              pinterestCls:[Pinterest class]];
    
    /**
     连接Pocket应用以使用相关功能，此应用需要引用PocketConnection.framework
     http://getpocket.com/developer/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                               redirectUri:@"pocketapp1234"];
    
    /**
     连接Instapaper应用以使用相关功能，此应用需要引用InstapaperConnection.framework
     http://www.instapaper.com/main/request_oauth_consumer_token上注册Instapaper应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    
    /**
     连接有道云笔记应用以使用相关功能，此应用需要引用YouDaoNoteConnection.framework
     http://note.youdao.com/open/developguide.html#app上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    
    /**
     连接搜狐随身看应用以使用相关功能，此应用需要引用SohuConnection.framework
     https://open.sohu.com上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
                           redirectUri:@"http://sharesdk.cn"];
    
    
    /**
     链接Flickr,此平台需要引用FlickrConnection.framework框架。
     http://www.flickr.com/services/apps/create/上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectFlickrWithApiKey:@"33d833ee6b6fca49943363282dd313dd"
                            apiSecret:@"3a2c5b42a8fbb8bb"];
    
    /**
     链接Tumblr,此平台需要引用TumblrConnection.framework框架
     http://www.tumblr.com/oauth/apps上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectTumblrWithConsumerKey:@"2QUXqO9fcgGdtGG1FcvML6ZunIQzAEL8xY6hIaxdJnDti2DYwM"
                            consumerSecret:@"3Rt0sPFj7u2g39mEVB3IBpOzKnM3JnTtxX2bao2JKk4VV1gtNo"
                               callbackUrl:@"http://sharesdk.cn"];
    
    /**
     连接Dropbox应用以使用相关功能，此应用需要引用DropboxConnection.framework库
     https://www.dropbox.com/developers/apps上注册应用，并将相关信息填写以下字段。
     **/
    [ShareSDK connectDropboxWithAppKey:@"7janx53ilz11gbs"
                             appSecret:@"c1hpx5fz6tzkm32"];
    
    /**
     连接Instagram应用以使用相关功能，此应用需要引用InstagramConnection.framework库
     http://instagram.com/developer/clients/register/上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectInstagramWithClientId:@"ff68e3216b4f4f989121aa1c2962d058"
                              clientSecret:@"1b2e82f110264869b3505c3fe34e31a1"
                               redirectUri:@"http://sharesdk.cn"];
    
    /**
     连接VKontakte应用以使用相关功能，此应用需要引用VKontakteConnection.framework库
     http://vk.com/editapp?act=create上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectVKontakteWithAppKey:@"3921561"
                               secretKey:@"6Qf883ukLDyz4OBepYF1"];
}

#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{}
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{}
#pragma mark - WXApiDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    //    _merchantId = @"13040811180531200001";
    _merchantId = @"13080815193235900001";//新的商家ID
    [NUSD setObject:_merchantId forKey:kMerchantId];
    [self performSelectorInBackground:@selector(getMerchantInfoFromServer) withObject:nil];
    
    
    //==shareSDK==>>>//
    [ShareSDK registerApp:ShareSDKAppKey];
    [self initializePlat];
//    //这里新浪微博
//    [ShareSDK connectSinaWeiboWithAppKey:@"948671001"
//                               appSecret:@"3942d49e3308c31bbeb930a4ca3cc48e"
//                             redirectUri:@"http://www.sharesdk.cn"];
    
    //
    //==shareSDK==original//
//    [ShareSDK registerApp:ShareSDKAppKey];
//    //添加新浪微博应用
//    [ShareSDK connectSinaWeiboWithAppKey:@"1282411068"
//                               appSecret:@"076c9e4ce62839acd5d72cbf5291fb1c"
//                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
//    //添加腾讯微博应用
//    [ShareSDK connectTencentWeiboWithAppKey:@"801213517"
//                                  appSecret:@"9819935c0ad171df934d0ffb340a3c2d"
//                                redirectUri:@"http://www.ying7wang7.com"];
//    //添加QQ空间应用
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    //添加豆瓣应用
//    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
//                            appSecret:@"e32896161e72be91"
//                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    //==shareSDK==<<<//
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

        
    [self createTabBarController];
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[CheckOutCenterViewController new] autorelease]];
//    self.window.rootViewController = navi;
//    [navi release];
    [NSThread detachNewThreadSelector:@selector(updateProvinceFromServer) toTarget:self withObject:nil ];
    
    //设置网络图片获取模式（其中判断网络连接状态）//
    [self updateUserPreferredImageQuality];
    //[NSThread detachNewThreadSelector:@selector(updateUserPreferredImageQuality) toTarget:self withObject:nil ];

    
    [self.window makeKeyAndVisible];
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
//    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)loggedOut
{
    [NUSD removeObjectForKey:kCurrentUserName];
    [NUSD removeObjectForKey:kCurrentUserId];
    self.isLoggedIn = NO;
    
    self.userInfo = nil;
    
    self.tabs.selectedIndex = 0;
    
    //退出登录后清空购物车
    [[HuEasyShoppingCart sharedInstance] clearAfterLogoutCompletion:nil];
}


- (void)loggedInWithUserInfo:(NSDictionary *)userInfo completion:(void(^)())completionBlock
{
    self.isLoggedIn = YES;
    self.userInfo = userInfo;
    
    [NUSD setObject:[userInfo objectForKey:@"userKo"] forKey:kCurrentUserId];
    [NUSD setObject:[userInfo objectForKey:@"account"] forKey:kCurrentUserName];
    [NUSD setObject:userInfo[@"email"] forKey:kCurrentUserEmail];
    [NUSD synchronize];
    
    NSAssert([NUSD objectForKey:kCurrentUserToken] != nil && ![[NUSD objectForKey:kCurrentUserToken] isEqual:[NSNull null]], @"User token can't be null!");
    
    //登录后同步购物车
    [CustomBezelActivityView activityViewForView:self.window];
    [[HuEasyShoppingCart sharedInstance] syncCompletion:^{
        if(completionBlock != nil){
            completionBlock();
        }
        [CustomBezelActivityView removeViewAnimated:YES];
    }];
}

- (void)saveWithUserInfo:(NSDictionary *)userInfo
{
    self.userInfo = userInfo;
    
    [NUSD setObject:[userInfo objectForKey:@"userKo"] forKey:kCurrentUserId];
    [NUSD setObject:[userInfo objectForKey:@"account"] forKey:kCurrentUserName];
    [NUSD setObject:userInfo[@"email"] forKey:kCurrentUserEmail];
    [NUSD synchronize];
    
    NSAssert([NUSD objectForKey:kCurrentUserToken] != nil && ![[NUSD objectForKey:kCurrentUserToken] isEqual:[NSNull null]], @"User token can't be null!");
    
}

-(void)getMerchantInfoFromServer
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [RemoteManager PostAsync:kGET_MERCHANT_INFO Parameters:params WithBlock:^(id json, NSError *error) {
        if (error==nil){
            self.merchantInfo = json[@"merchantBaseInfo"];
        }
    }];
    [params release];
}

- (void)createTabBarController
{
    
    tabs = [[UITabBarController alloc] init];
    tabs.delegate = self;
//    tabs.tabBar.tintColor = [Util rgbColor:"E22930"];
    tabs.tabBar.tintColor = [UIColor whiteColor];
    
    HomePageViewController *home = [[HomePageViewController alloc] init];
    //home.title = @"首页";
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:home];
    [home release];
    UITabBarItem *homeItem = [[[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home_normal"] tag:0] autorelease];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        homeItem.selectedImage = [[UIImage imageNamed:@"tab_home_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        homeItem.image = [[UIImage imageNamed:@"tab_home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [homeItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_home_highlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_home_normal"]];
    }
    [homeItem setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:225/255.0 green:40/255.0 blue:48/255.0 alpha:1.0]} forState:UIControlStateSelected];
    [homeNavi setTabBarItem:homeItem];

    
    
     SearchMyProduct*search = [[SearchMyProduct alloc] init];
    search.title = @"搜索";
    UINavigationController *searchNavi = [[UINavigationController alloc] initWithRootViewController:search];
    [search release];
    UITabBarItem *searchItem = [[[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"tab_search_normal"] tag:0] autorelease];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        searchItem.selectedImage = [[UIImage imageNamed:@"tab_search_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        searchItem.image = [[UIImage imageNamed:@"tab_search_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [searchItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_search_highlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_search_normal"]];
    }
    [searchItem setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:225/255.0 green:40/255.0 blue:48/255.0 alpha:1.0]} forState:UIControlStateSelected];
    [searchNavi setTabBarItem:searchItem];
    
    ShoppingCartViewController *cart = [[ShoppingCartViewController alloc] init];
    UINavigationController *cartNavi = [[UINavigationController alloc] initWithRootViewController:cart];
    cart.title = @"购物车";
    [cart release];
    UITabBarItem *cartItem = [[[UITabBarItem alloc] initWithTitle:@"购物车" image:[UIImage imageNamed:@"tab_shoppingcart_normal"] tag:0] autorelease];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        cartItem.selectedImage = [[UIImage imageNamed:@"tab_shoppingcart_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cartItem.image = [[UIImage imageNamed:@"tab_shoppingcart_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [cartItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_shoppingcart_highlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_shoppingcart_normal"]];
    }
    [cartItem setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:225/255.0 green:40/255.0 blue:48/255.0 alpha:1.0]} forState:UIControlStateSelected];
    [cartNavi setTabBarItem:cartItem];
    
    MinePageViewController *mine = [[MinePageViewController alloc]initWithNibName:@"MinePageViewController" bundle:nil];
    UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mine];
    mine.title = @"个人中心";
    [mine release];
    UITabBarItem *mineItem = [[[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tab_personal homepage_normal"] tag:0] autorelease];
    mineItem.title = @"我";
    [mineItem setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor colorWithRed:225/255.0 green:40/255.0 blue:48/255.0 alpha:1.0]} forState:UIControlStateSelected];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        mineItem.selectedImage = [[UIImage imageNamed:@"tab_personal homepage_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        mineItem.image = [[UIImage imageNamed:@"tab_personal homepage_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [mineItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_personal homepage_highlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_personal homepage_normal"]];
    }
    [mineNavi setTabBarItem:mineItem];

//    [tabs.tabBar setBackgroundImage:[UIImage imageNamed:@"tap _background"]];
//    [tabs.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@""]];
    
    [tabs setViewControllers:@[homeNavi,searchNavi,cartNavi,mineNavi]];
    
    [homeNavi release];
    [searchNavi release];
    [cartNavi release];
    [mineNavi release];
    
    self.window.rootViewController = tabs;
//    CoordinatingController *coordinatingController = [CoordinatingController sharedInstance];
//    [[tabs.viewControllers objectAtIndex:0] addChildViewController:[coordinatingController activeViewController]];
//    [[tabs.viewControllers objectAtIndex:1] addChildViewController:[coordinatingController activeSearchViewController]];
//    [[tabs.viewControllers objectAtIndex:2] addChildViewController:[coordinatingController activeShoppingViewController]];
//    [[tabs.viewControllers objectAtIndex:3] addChildViewController:[coordinatingController activeMineViewController]];
//    [coordinatingController release];
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    return !(tabBarController.selectedViewController==viewController);
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is:%@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"failed to get token,error:%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    NSLog(@"Receive remote notification:%@,%@", userInfo,[userInfo class]);
//    NSLog(@"%@",[userInfo objectForKey:@"aps"]);
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        NSLog(@"%@:%@", title, message);
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        
//        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        
//        [alert show];
        //        [alert release];
        NSLog(@"%@:%@", title, message);
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //return [WeiboSDK handleOpenURL:url delegate:self] || [self parseURL:url application:application] ;
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self] || [self parseURL:url application:application];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //return [WeiboSDK handleOpenURL:url delegate:self] || [self parseURL:url application:application] ;
    return [ShareSDK handleOpenURL:url wxDelegate:self] || [self parseURL:url application:application];
}

//支付宝支付回调
- (BOOL)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
    BOOL res=NO;
	if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			/*
			 *用公钥验证签名
			 */
			id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:result.statusMessage
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}//验签错误
			else {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:@"签名错误"
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		}
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:result.statusMessage
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		res = YES;
	}
    return res;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.viewControllers[3] == viewController)
    {
        if (!self.isLoggedIn)
        {
            LoginViewController *loginCtrl=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            loginCtrl.successBlock=^(void){

                APP_DELEGATE.tabs.selectedIndex=3;
            };
            UINavigationController *naviLogin=[[UINavigationController alloc]initWithRootViewController:loginCtrl];
            [APP_DELEGATE.tabs.selectedViewController presentViewController:naviLogin animated:YES completion:nil];
            [loginCtrl release];
            [naviLogin release];
            return false;
           

        }
        else
        {
            return true;
        }
        
    }
    else
    {
        return true;
    }
    
    return true;
    
}

#pragma mark get ProvinceAndCityList

-(void)updateProvinceFromServer
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [RemoteManager PostAsync:kGET_PROVINCEINFO Parameters:nil WithBlock:^(id json, NSError *error) {
            if (error==nil) {
//                NSLog(@"%d",[[json objectForKey:@"regionsList"]count]);
//                NSLog(@"%@",json);
                NSMutableArray *plistArr=[[NSMutableArray alloc]init];
                self.regionsListArr=[[json objectForKey:@"regionsList"]mutableCopy];
                
                NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
                for (int i=0;i<4;i++)
                {
                    [tmpArr addObject:[self newPlistFile:[NSMutableDictionary dictionaryWithDictionary:[self.regionsListArr objectAtIndex:i]]]];
                }
                
                for (int i=0;i<[tmpArr count];i++)
                {
                    NSMutableDictionary *dic=[tmpArr objectAtIndex:i];
                    if ([[dic objectForKey:@"id"]intValue]==2)
                    {
                        [plistArr addObjectsFromArray:[dic objectForKey:@"subArr"]];
                        [tmpArr removeObject:dic];
                        
                    }
                }
                [plistArr addObjectsFromArray:tmpArr];
                [tmpArr release];

                
                NSString *plistFilePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/region.plist"];
                [plistArr writeToFile:plistFilePath atomically:YES];
           
                [plistArr release];
                
            }
        }];
        [params release];
        
    }
    
}
-(NSMutableDictionary *)newPlistFile:(NSMutableDictionary *)parentDic
{
    
    NSMutableArray *subArr=[[[NSMutableArray alloc]init]autorelease];
    
    for (NSMutableDictionary *Dic in self.regionsListArr)
    {
        
        
        if ([[parentDic objectForKey:@"id"]isEqual:[Dic objectForKey:@"parentId"]])
        {
            
            NSMutableDictionary *subDic=[self newPlistFile:[NSMutableDictionary dictionaryWithDictionary:Dic]];
            [subArr addObject:subDic];
            
            
            
        }
        if ([subArr count])
        {
            [parentDic setObject:subArr forKey:@"subArr"];
        }
        
        
    }
    
    
    return parentDic;
    
}
#pragma mark updateUserPreferredImageQuality://设置网络图片获取模式//
-(void)updateUserPreferredImageQuality
{
    //@autoreleasepool
    //{
        //预设初始值
        int UserPreferredImageQuality_Mode=0; //0 智能模式(默认)，1 高质量，2 普通， >根据模式再去决定具体取图标准值
        int UserPreferredImageQuality_Value=0;//0：2G/3G(使用标清图),  1：wifi（使用高清图）
        //取出先前设置的模式
        UserPreferredImageQuality_Mode=[[NUSD objectForKey:kUserPreferredImageQuality] integerValue];
        //三模式去处理
        if(UserPreferredImageQuality_Mode==0){//智能模式才需要判断网络去决定取图质量标准
            __block int UserPreferredImageQuality_Value2=UserPreferredImageQuality_Value;
            [Util checkNetType:^(int currentNetType){
                NSLog(@"WIFI=1,WWAN=2,NONET=3,UNKNOW=4, currentNetType=%d",currentNetType);
                if(currentNetType==1){//智能模式下wifi用高清图
                    NSLog(@"智能模式下wifi用高清图...");
                    UserPreferredImageQuality_Value2=1;
                }else if (currentNetType==2){//智能模式下wlan用标清图
                    NSLog(@"智能模式下wlan用标清图");
                    UserPreferredImageQuality_Value2=0;
                }else if(currentNetType==3){
                    NSLog(@"当前网络似乎未连接...");
                }else{
                    NSLog(@"当前网络判断出错...");
                }
                self.userPreferredImageQuality_Value=UserPreferredImageQuality_Value2;
                NSLog(@"0：2G/3G(使用标清图),  1：wifi（使用高清图） 当前userPreferredImageQuality_Value=%d",self.userPreferredImageQuality_Value);
            }];
            
//            int currentNetType=[Util checkNetType];
//            NSLog(@"WIFI=1,WWAN=2,NONET=3,UNKNOW=4,\n, currentNetType:%d",currentNetType);
//            if(currentNetType==1){//智能模式下wifi用高清图
//                NSLog(@"智能模式下wifi用高清图...");
//                UserPreferredImageQuality_Value=1;
//            }else if (currentNetType==2){//智能模式下wlan用标清图
//                NSLog(@"智能模式下wlan用标清图");
//                UserPreferredImageQuality_Value=0;
//            }else if(currentNetType==3){
//                NSLog(@"当前网络似乎未连接...");
//            }else{
//                NSLog(@"当前网络判断出错...");
//            }
//            UserPreferredImageQuality_Value=0;//默认使用标清图
        }else if(UserPreferredImageQuality_Mode==1){//强制高清图模式
            UserPreferredImageQuality_Value=1;//默认使用标清图
        }else if(UserPreferredImageQuality_Mode==2){//强制普通图模式
            UserPreferredImageQuality_Value=0;//默认使用标清图
        }
        //
        self.userPreferredImageQuality_Value=UserPreferredImageQuality_Value;
        NSLog(@"0：2G/3G(使用标清图),  1：wifi（使用高清图） 当前userPreferredImageQuality_Value=%d",self.userPreferredImageQuality_Value);
    //}
    
}

- (void) forcedLogOut:(id)sender
{
    if ([[sender objectForKey:@"state"] integerValue] == -1)
    {
//        NSLog(@"强制退出 %@", sender);
        [self performSelectorOnMainThread:@selector(alertViewShow) withObject:nil waitUntilDone:NO];
    }
}

- (void) alertViewShow
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录过期，请重新登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = 123;
    alertView.delegate = self;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        强制退出
        [self loggedOut];
        
        LoginViewController *loginCtrl=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        loginCtrl.successBlock=^(void){
            
            APP_DELEGATE.tabs.selectedIndex=3;
        };
        UINavigationController *naviLogin=[[UINavigationController alloc]initWithRootViewController:loginCtrl];
        [APP_DELEGATE.tabs.selectedViewController presentViewController:naviLogin animated:YES completion:nil];
        [loginCtrl release];
        [naviLogin release];
    }
}


@end
