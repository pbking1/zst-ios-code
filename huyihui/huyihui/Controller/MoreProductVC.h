//
//  MoreProductVC.h
//  huyihui
//
//  Created by zaczh on 14-3-24.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductConstants.h"

@interface MoreProductVC : BaseViewController
@property (readonly, nonatomic)HomePageMoreProductType pageType;
@property (retain, nonatomic) IBOutlet UITableView *table;

- (id)initWithType:(HomePageMoreProductType)type;
@end
