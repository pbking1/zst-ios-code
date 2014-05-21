//
//  AppRecommendDetailViewController.h
//  huyihui
//
//  Created by pengzhizhong on 14-4-25.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"
#import "HorizontalScrollImageShow.h"

@interface AppRecommendDetailViewController : BaseViewController<HorizontalScrollImageShowDataSource,HorizontalScrollImageShowDelegate,UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *table;
- (IBAction)sectionExpand:(id)sender;

@property (retain, nonatomic)NSDictionary *appInfo;
- (id)initWithAppInfo:(NSDictionary *)appInfo;

@property (retain, nonatomic) NSMutableArray *hsImageList;//广告图片地址数组
@property (retain, nonatomic) HorizontalScrollImageShow *hsImageShow;//对象

@end
