//
//  BaseViewController.m
//  huyihui
//
//  Created by linyi on 14-2-19.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithParameters:(NSDictionary *)params{
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    IOS7_LAYOUT_OPAQUEBARS;
	// Do any additional setup after loading the view.
//    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", @"") style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    

    
    
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_IOS_6"] forBarMetrics:UIBarMetricsDefault];
        
        CreateButton *backBtn = [[ButtonFactory factory] createButtonWithType:HuEasyButtonTypeBack];
        backBtn.clickHandler = ^(){
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = leftBarItem;
        self.navigationItem.hidesBackButton = YES;
        [leftBarItem release];
        
        /*new added
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        self.navigationItem.hidesBackButton = YES;
        [rightBarItem release];*/
        
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

//- (void)viewWillAppear:(BOOL)animated{
//    UINavigationItem *leftItem = self.navigationItem;
////    NSLog(@"leftItem: %@",leftItem.backBarButtonItem);
//    
//    [super viewWillAppear:animated];
//}

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
