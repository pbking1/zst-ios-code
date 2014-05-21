//
//  OrderDetailViewController.h
//  huyihui
//
//  Created by zhangmeifu on 20/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"

@interface OrderDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (retain,nonatomic)UITableView *orderDetailTable;

- (id)initWithOrderId:(NSString *)orderId;

@end
