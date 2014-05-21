//
//  SelectRequirementViewController.h
//  huyihui
//
//  Created by zhangmeifu on 24/2/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectRequirementViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

//  @property(retain,nonatomic)UITableView *requirementTable;
@property (retain, nonatomic) IBOutlet UITableView *requirementTable;

@property(retain,nonatomic)NSMutableArray *dataArr;

@property (retain,nonatomic)NSString *parentId;
@property (retain,nonatomic)NSString *conId;

@property (retain,nonatomic)NSMutableArray *directorySpecsArr;

@property (retain,nonatomic)NSMutableArray *productColumnsArr;

@property (retain,nonatomic)NSMutableDictionary *attributeForIndex;

@property (copy,nonatomic) void (^doneSelect)(NSString *specificId,NSMutableArray *array);






@end
