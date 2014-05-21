//
//  MyProductRating.h
//  huyihui
//
//  Created by zhangmeifu on 14/4/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProductRating : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *ratingTable;

@property (retain,nonatomic)NSMutableArray *discussListArr;
@property (retain, nonatomic) IBOutlet UILabel *noRatingLabel;

@end
