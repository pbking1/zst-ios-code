//
//  SecondLevelDirectory.h
//  huyihui
//
//  Created by zhangmeifu on 27/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondLevelDirectory : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *firstLevelTable;
@property (retain, nonatomic) IBOutlet UITableView *secondLevelTable;



@property(retain,nonatomic)NSMutableArray *dataArr;
@property(assign,nonatomic)int  selectIndex;


@end
