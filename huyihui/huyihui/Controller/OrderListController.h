//
//  OrderListController.h
//  huyihui
//
//  Created by zhangmeifu on 11/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShareViewController.h"
#import "CommentViewController.h"
#import "LogisticsViewController.h"

@interface OrderListController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic)  UITableView *orderListTable;

@property (readonly, nonatomic) NSInteger orderStatus;
- (id)initWithOrderStatus:(NSInteger)status;

@end
