//
//  CoordinatingController.h
//  huyihui
//
//  Created by linyi on 14-3-5.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageViewController.h"
#import "ProductSearchViewController.h"
#import "ShoppingCartViewController.h"
#import "MinePageViewController.h"
#import "FlashSaleViewController.h"
#import "CouponViewController.h"
//#import "GroupBuyViewController.h"

typedef enum
{
    kTagOpenGroupBuyViewController = 1,
    kTagOpenFlashSaleViewController,
    kTagOpenCouponViewController
}ButtonTag;

@interface CoordinatingController : NSObject
{
@private
    HomePageViewController *_homeViewController;
    ProductSearchViewController *_searchViewController;
    ShoppingCartViewController *_shoppingViewController;
    MinePageViewController *_mineViewController;
    UIViewController *_activeViewController;
    UIViewController *_activeSearchViewController;
    UIViewController *_activeShoppingViewController;
    UIViewController *_activeMineViewController;
}

@property (readonly, nonatomic) UIViewController *activeViewController;
@property (readonly, nonatomic) UIViewController *activeSearchViewController;
@property (readonly, nonatomic) UIViewController *activeShoppingViewController;
@property (readonly, nonatomic) UIViewController *activeMineViewController;
@property (readonly, nonatomic) HomePageViewController *homeViewController;
@property (readonly, nonatomic) ProductSearchViewController *searchViewController;
@property (readonly, nonatomic) ShoppingCartViewController *shoppingViewController;
@property (readonly, nonatomic) MinePageViewController *mineViewController;

+ (CoordinatingController *) sharedInstance;
- (IBAction)requestViewChangeByObject:(id)sender;

@end
