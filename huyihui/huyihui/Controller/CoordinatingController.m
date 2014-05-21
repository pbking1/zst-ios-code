//
//  CoordinatingController.m
//  huyihui
//
//  Created by linyi on 14-3-5.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "CoordinatingController.h"

@interface CoordinatingController()

- (void)initialize;

@end

@implementation CoordinatingController

@synthesize activeViewController = _activeViewController;
@synthesize activeSearchViewController = _activeSearchViewController;
@synthesize activeShoppingViewController = _activeShoppingViewController;
@synthesize activeMineViewController = _activeMineViewController;
@synthesize homeViewController = _homeViewController;
@synthesize searchViewController = _searchViewController;
@synthesize shoppingViewController = _shoppingViewController;
@synthesize mineViewController = _mineViewController;

static CoordinatingController *sharedSingleton = nil;

- (void)initialize
{
    _homeViewController = [[HomePageViewController alloc] init];
    _searchViewController = [[ProductSearchViewController alloc] init];
    _shoppingViewController = [[ShoppingCartViewController alloc] init];
    _mineViewController = [[MinePageViewController alloc] init];
    
    _activeViewController = _homeViewController;
    _activeSearchViewController = _searchViewController;
    _activeShoppingViewController = _shoppingViewController;
    _activeMineViewController = _mineViewController;
}

+ (CoordinatingController *)sharedInstance
{
    if (sharedSingleton == nil)
    {
        sharedSingleton = [[super allocWithZone:NULL] init];
        
        [sharedSingleton initialize];
    }
    
    return  sharedSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (oneway void) release
{
    // do nothing
}

- (id) autorelease
{
    return self;
}

- (void)navigateController:(UIViewController *)fromController
         ToControllerNamed:(NSString *)toControllerName
                withParameters:(NSDictionary *)params
               returnBlock:(void(^)(void))returnBlock{
    Class aClass = NSClassFromString(toControllerName);
    if(aClass == nil){
        NSLog(@"Can't find class named: %@", toControllerName);
        return;
    }
    
    UIViewController *controller = [[aClass alloc] init];
    [fromController.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)requestViewChangeByObject:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        switch ([(UIButton *)sender tag])
        {
            case kTagOpenCouponViewController:
            {
                CouponViewController *controller = [[[CouponViewController alloc] init] autorelease];
                controller.hidesBottomBarWhenPushed = YES;
                [_homeViewController.navigationController pushViewController:controller animated:YES];
                _activeViewController = controller;
            }
                break;
                
            case kTagOpenFlashSaleViewController:
            {
                FlashSaleViewController *controller = [[[FlashSaleViewController alloc] init] autorelease];
                controller.hidesBottomBarWhenPushed = YES;
                [_homeViewController.navigationController pushViewController:controller animated:YES];
                _activeViewController = controller;
            }
                break;
                
//            case kTagOpenGroupBuyViewController:
//            {
//                GroupBuyViewController *controller = [[[GroupBuyViewController alloc] init] autorelease];
//                controller.hidesBottomBarWhenPushed = YES;
//                [_homeViewController.navigationController pushViewController:controller animated:YES];
//                _activeViewController = controller;
//            }
//                break;
                
            default:
            {
                [_homeViewController dismissViewControllerAnimated:YES completion:nil];
                _activeViewController = _homeViewController;
            }
                break;
        }
    }
    else
    {
        [_homeViewController dismissViewControllerAnimated:YES completion:nil];
        _activeViewController = _homeViewController;
    }
}

@end
