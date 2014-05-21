//
//  ShoppingCartViewController.h
//  huyihui
//
//  Created by zaczh on 14-2-20.
//  Copyright (c) 2014年 linyi. All rights reserved.
//
#import "HuEasyShoppingCart.h"

@interface ShoppingCartViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, UITextFieldDelegate>

@property(retain,nonatomic)UITableView *shoppingCartTable;

@property(retain,nonatomic)UITableViewController *mainTableViewController;


@property(copy,nonatomic)NSArray *shoppingCartArr;


@end
