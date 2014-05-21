//
//  ViewController.m
//  huyihui
//
//  Created by linyi on 14-2-19.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImageView+AFNetworking.h"
#import "RemoteManager.h"
#import "SectionFactory.h"

@interface ViewController ()

@property (retain, nonatomic)NSDictionary *restDict;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imgView.center = CGPointMake(240, 160);
    [self.view addSubview:imgView];
    [imgView release];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          APP_DELEGATE.merchantId, @"merchantId",
                          [NSNumber numberWithInt:10], @"num",
                          [NSNumber numberWithInt:1], @"pageIndex",nil];
    
    [RemoteManager Posts:@"ware/getNewWareInfo.json" Parameters:dict WithBlock:^(id json, NSError *error)
     {
         if (!error)
         {
             NSLog(@"json is:%@", json);
             _restDict = json;
             
             
             NSString *str = [[[_restDict objectForKey:@"newWareList"] objectAtIndex:0] objectForKey:@"mathPath"];
             
             NSString *tmp = [NSString stringWithFormat:@"http://192.168.116.11%@", str];
             
             NSLog(@"math str is : %@", tmp);
             [imgView setImageWithURL:[NSURL URLWithString:tmp] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
         }
     }];
    
    [dict release];
    
    //按钮工厂调用方式
    
//    SectionFactory *factory = [SectionFactory factoryType:BACKBUTTON];
//    UIButton *backBtn = [factory createButton];
//    backBtn.frame = CGRectMake(0, 0, 60, 44);
//    [backBtn setBackgroundColor:[UIColor redColor]];
////    [backBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBarButtonItem;
//    [backBtn release];
//    
//    SectionFactory *factory1 = [SectionFactory factoryType:DONEBUTTON];
//    UIButton *shareBtn = [factory1 createButton];
//    shareBtn.frame = CGRectMake(0, 0, 60, 44);
//    [shareBtn setBackgroundColor:[UIColor redColor]];
////    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = shareBarButtonItem;
//    [shareBtn release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
