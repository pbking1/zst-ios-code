//
//  ChoosePayMeansViewController.h
//  huyihui
//
//  Created by zaczh on 14-4-8.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"

@interface ChoosePayMeansViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
- (id)initWithOptions:(NSArray *)options selectedIndex:(NSInteger)index completion:(void (^)(NSDictionary *res))completionBlock;
@end