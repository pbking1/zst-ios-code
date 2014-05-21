//
//  FlashSaleViewController.h
//  huyihui
//
//  Created by zaczh on 14-2-25.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"
#import "TimerLabel.h"
#import "GroupBuyItemDetailViewController.h"

@interface FlashSaleViewController : BaseViewController<UISearchDisplayDelegate>

@property (assign, nonatomic) NSInteger saleType;//表示促销类型,0为最惠团,1为限时抢购(秒杀)

@property(retain, nonatomic) IBOutlet UITableView *table;

@property (retain, nonatomic) IBOutlet UITableView *sortTable;

@property (retain, nonatomic) IBOutlet UITableView *categoryTable;

@property (retain, nonatomic) IBOutlet UITableView *subCategoryTable;

@property (retain, nonatomic) IBOutlet UIView *sortView;

@property (retain, nonatomic) IBOutlet UIView *categoryView;
@property (retain, nonatomic) IBOutlet UILabel *placeholderHintLabel;

@property (retain, nonatomic) IBOutlet UIView *tablePlaceholder;
@property (retain, nonatomic) IBOutlet UIButton *categoryBtn;

@property (retain, nonatomic) IBOutlet UIImageView *headerBgIV;
@property (retain, nonatomic) IBOutlet UIButton *sortTypeBtn;

- (IBAction)clickSortBtn:(id)sender;

-(IBAction)clickCategoryBtn:(id)sender;

- (id)initWithSaleType:(NSInteger)saleType;
@end
