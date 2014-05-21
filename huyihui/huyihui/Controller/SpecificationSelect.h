//
//  SpecificationSelect.h
//  huyihui
//
//  Created by zhangmeifu on 16/4/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecificationSelect : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *specificationSelectTable;

@property (retain,nonatomic)NSMutableArray *directorySpecsArr;

@property (retain,nonatomic)NSMutableDictionary *productColumnsDic;

@property (assign,nonatomic)BOOL isSelectType;


@property (copy,nonatomic) void(^selectDone)(NSMutableDictionary *dic);


@end
