//
//  searchResultViewController.h
//  huyihui
//
//  Created by zhangmeifu on 20/2/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchResultViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (retain,nonatomic)NSString *searchString;

@property (retain,nonatomic)NSString *parentId;
@property (retain,nonatomic)NSString *conId;
@property (assign)BOOL isSearch;

@property (retain,nonatomic)NSMutableArray *searchResultArr;
@property (retain,nonatomic)NSString *orderByString;
@property (assign,nonatomic)NSInteger currentPage;

//@property (retain,nonatomic)UITableView *resultTable;
@property (retain,nonatomic)UICollectionView *collectionView;

@property (retain,nonatomic)NSMutableArray *requirementArr;
@property (retain,nonatomic)NSString *specificId;

@end
