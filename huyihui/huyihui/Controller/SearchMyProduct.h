//
//  SecondLevelDirectory.h
//  huyihui
//
//  Created by zhangmeifu on 27/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchMyProduct : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UITableView *firstLevelTable;
@property (retain, nonatomic) IBOutlet UITableView *secondLevelTable;

@property (retain, nonatomic)  UISearchBar *searchBar;


@property(retain,nonatomic)NSMutableArray *dataArr;
@property(retain,nonatomic)NSMutableArray *firstCatalogueArr;
@property(retain,nonatomic)NSMutableArray *subCatalogArr;
@property(assign,nonatomic)int  selectIndex;


@end
