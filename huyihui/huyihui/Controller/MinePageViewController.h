//
//  MinePageViewController.h
//  huyihui
//
//  Created by zaczh on 14-2-20.
//  Copyright (c) 2014年 linyi. All rights reserved.
//
#import "LoginViewController.h"

@interface moreFooterView : UICollectionReusableView


@end



@interface MinePageViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (retain, nonatomic) IBOutlet UICollectionView *mineCollectionView;

@property (retain, nonatomic) NSMutableArray *browseHistoryArr;
@property (retain, nonatomic) NSMutableArray *myCollection;
@property (assign,nonatomic)NSInteger currentBrowsePage;
@property (assign,nonatomic)NSInteger currentCollectPage;


@end
