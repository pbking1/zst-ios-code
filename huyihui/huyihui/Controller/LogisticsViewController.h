//
//  LogisticsViewController.h
//  huyihui
//
//  Created by zaczh on 14-4-21.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"

@interface LogisticsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
- (id)initWithOrder:(NSDictionary *)orderInfo;
@end
