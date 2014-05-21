//
//  HomePageViewController.m
//  huyihui
//
//  Created by zaczh on 14-2-20.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "HomePageViewController.h"

#import "RemoteManager.h"
#import "UIImageView+AFNetworking.h"
#import "LoginViewController.h"
#import "ZacNoticeView.h"
#import "UIImage+imageWithColor.h"
#import "searchResultViewController.h"
#import "HuEasySystemInfo.h"

@interface HomePageViewController ()
{
    
}

@property (copy, nonatomic)NSDictionary *restDict;

@property (copy, nonatomic) NSArray *recommendList;

@property (copy, nonatomic) NSArray *updatedList;

@property (copy, nonatomic) NSArray *hotList;

//@property (retain, nonatomic) NSArray *adsList;
@property (retain, nonatomic) NSMutableArray *adsImageList;

@property (retain, nonatomic) CarouselView *adsView;

@end

@implementation HomePageViewController

@synthesize searchBar=_searcBar;

static NSString *cellIdentifier = @"Cell";
static NSString *header0 = @"header0";
static NSString *header1 = @"header1";
static NSString *header2 = @"header2";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = nil;
    self.adsImageList = [[NSMutableArray new] autorelease];
    
  
    
    _searcBar=[[UISearchBar alloc]initWithFrame:CGRectMake(92, 7, 220, 30)];
    _searcBar.backgroundImage=[UIImage imageWithColor:[UIColor colorWithRed:0.847 green:0.024 blue:0.071 alpha:1.000] andSize:CGSizeMake(SCREEN_WIDTH, 44) ];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _searcBar.delegate=self;
    [_searcBar setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    _searcBar.placeholder=@"搜索商品名                          ";

    [view setBackgroundColor:[UIColor colorWithRed:0.847 green:0.024 blue:0.071 alpha:1.000]];
    [view addSubview:_searcBar];
    
    UIImageView *naviImageView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 9, 80, 25)];
    naviImageView.image=[UIImage imageNamed:@"huyihui"];
    [self.navigationController.navigationBar addSubview:naviImageView];
    [view addSubview:naviImageView];
    [naviImageView release];
    self.navigationItem.titleView=view;
    [view release];

    
//    [self.table0 registerClass:NSClassFromString(@"HomePageCustomCell") forCellWithReuseIdentifier:cellIdentifier];
//    [self.table1 registerClass:NSClassFromString(@"HomePageCustomCell") forCellWithReuseIdentifier:cellIdentifier];
//    [self.table2 registerClass:NSClassFromString(@"HomePageCustomCell") forCellWithReuseIdentifier:cellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewProductCollectionView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
//    [self.table1 registerNib:[UINib nibWithNibName:@"NewProductCustomCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
//    [self.table2 registerNib:[UINib nibWithNibName:@"NewProductCustomCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionHeader0" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header0];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionHeader1" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionHeader2" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header2];
    
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.collectionView = nil;
    self.adsImageList = nil;
    self.searchBar=nil;

    [super dealloc];
}

- (void)requestData{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NSNumber numberWithInt:3] forKey:@"num"];
    [param setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    
    dispatch_group_t localGroup = dispatch_group_create();
    
    dispatch_group_enter(localGroup);
    [RemoteManager Posts:kGET_RECOMMEND_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                self.recommendList = [json objectForKey:@"recommendList"];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 0:%@",error);
        }
        dispatch_group_leave(localGroup);
    }];
    
    dispatch_group_enter(localGroup);
    [RemoteManager Posts:kGET_HOT_WARE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                self.hotList = [json objectForKey:@"hotSaleList"];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 1:%@",error);
        }
        dispatch_group_leave(localGroup);
    }];
    
//    [RemoteManager Posts:kGET_NEW_WARE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
//        if(error == nil){
//            if([[json objectForKey:@"state"] integerValue] == 1){
//                self.updatedList = [json objectForKey:@"newWareList"];
//                check++;
//                if(check == 4){
//                    [self.collectionView reloadData];
//                }
//            }else{
//                NSLog(@"server error");
//                NSLog(@"reason: %@",[json objectForKey:@"message"]);
//            }
//        }else{
//            NSLog(@"network error 2:%@",error);
//        }
//    }];
    
    dispatch_group_enter(localGroup);
    [RemoteManager Posts:kGET_NEW_WARE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                self.updatedList = [json objectForKey:@"newWareList"];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 2:%@",error);
        }
        dispatch_group_leave(localGroup);
    }];
    
    //查询广告
    [param setValue:nil forKey:@"num"];
    [param setValue:nil forKey:@"pageIndex"];
    [param setObject:@"1" forKey:@"pageType"];
    [param setObject:@"0" forKey:@"position"];
    
    dispatch_group_enter(localGroup);
    [RemoteManager Posts:kGET_POSTER_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                    NSArray *adsList = [json objectForKey:@"posterMediaList"];
                    [self.adsImageList removeAllObjects];
                    for(NSDictionary *dict in adsList){
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER, [dict objectForKey:@"mediaPath"]]];
                        [self.adsImageList addObject:url];
                    }
//#ifdef DEBUG
//                [self.adsImageList removeAllObjects];
//                [self.adsImageList addObjectsFromArray:@[
//                                                        [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/shouyeangel.jpg"],
//                                                        [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/shouyemingxingouba.jpg"],
//                                                        [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/142-142xuxiyuan.jpg"]]];
//#endif
                [self.adsView reloadData];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 3:%@",error);
        }
        dispatch_group_leave(localGroup);
    }];
    [param release];
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    dispatch_release(localGroup);
}

#pragma mark - carouseView datasource
- (NSInteger)numOfItemsInCarouselView:(CarouselView *)carouselView
{
    return self.adsImageList.count;
}

//- (UIView *)carouselView:(CarouselView *)carouselView imageForItemAtIndex:(NSInteger)index
//{
//    NSLog(@"%@",self.adsList[index]);
//    return self.adsImageList[index];
//}

- (NSURL *)carouselView:(CarouselView *)carouselView imageUrlForItemAtIndex:(NSInteger)index{
    return self.adsImageList[index];
}

#pragma mark - collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section < 2){
        return 0;
    }else if(section == 2){
        return [self.updatedList count];
    }else if (section == 3){
        return self.recommendList.count;
    }else if (section == 4){
        return self.hotList.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSArray *dataSource = nil;
    if(indexPath.section == 2){
        dataSource = self.updatedList;
    }else if (indexPath.section == 3){
        dataSource = self.recommendList;
    }else if (indexPath.section == 4){
        dataSource = self.hotList;
    }
    
    //TODO:set data
    UIImageView *picture = (UIImageView *)[cell viewWithTag:1];
    UILabel *desc = (UILabel *)[cell viewWithTag:2];
    UILabel *curPrice = (UILabel *)[cell viewWithTag:3];
    UILabel *oldPrice = (UILabel *)[cell viewWithTag:4];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER, [dataSource[indexPath.row] objectForKey:@"mathPath"]]];
    
    [picture setBackgroundColor:[UIColor grayColor]];
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[picture viewWithTag:999];
    if(loadingView == nil){
        loadingView = [[UIActivityIndicatorView alloc] initWithFrame :CGRectMake(0, 0, picture.frame.size.width, picture.frame.size.height)];
        loadingView.color= [UIColor blackColor];
        loadingView.tag = 999;
        [loadingView startAnimating];
        [picture addSubview:loadingView];
        [loadingView release];
    }
    [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
        if(image){
            [picture setImage:image];
            [picture setBackgroundColor:[UIColor clearColor]];
            if(loadingView){
                [loadingView removeFromSuperview];
            }
        }
    } errorBlock:nil];
    
#ifdef DEBUG
//    [picture setImage:[UIImage imageNamed:@"1-01home_list_Material picture of the recommendation 03 "]];

#endif
    
    desc.text = [NSString stringWithFormat:@"%@",[dataSource[indexPath.row] objectForKey:@"speciName"]];
    
    NSDictionary *nowPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"c80000"],
                                   NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSDictionary *oldPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"b7b7b7"],
                                   NSFontAttributeName:[UIFont systemFontOfSize:12],
                                   NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    double nowP = [dataSource[indexPath.row][@"minSalePrice"] doubleValue];
    double oldP = [dataSource[indexPath.row][@"minRetailPrice"] doubleValue];
    curPrice.attributedText = [[[NSAttributedString alloc]
                                initWithString:[NSString stringWithFormat:@"￥%.1f",nowP]
                                attributes:nowPriceAttr] autorelease];
    oldPrice.attributedText = [[[NSAttributedString alloc]
                                initWithString:[NSString stringWithFormat:@"￥%.1f",oldP]
                                attributes:oldPriceAttr] autorelease];
    
//    curPrice.text = [NSString stringWithFormat:@"￥%@",[dataSource[indexPath.row] objectForKey:@"minSalePrice"]];//minRetailPrice
//    
//    oldPrice.text = [NSString stringWithFormat:@"￥%@",[dataSource[indexPath.row] objectForKey:@"maxSalePrice"]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = nil;
    if(indexPath.section == 0){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:header0 forIndexPath:indexPath];
        CarouselView *carouse = (CarouselView *)[view viewWithTag:1];
        carouse.dataSource = self;
        carouse.delegate = self;
        self.adsView = carouse;
//        [carouse reloadData];
    }else if (indexPath.section == 1){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:header1 forIndexPath:indexPath];
        
    }else{
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:header2 forIndexPath:indexPath];
        UILabel *title = (UILabel *)[view viewWithTag:1];
        UIButton *btn = (UIButton *)[view viewWithTag:2];
        if(indexPath.section == 2){
            title.text = @"新品上市";
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(onLoadMoreNew:) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.section == 3){
            title.text = @"精品推荐";
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(onLoadMoreRecommend:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            title.text = @"热卖推荐";
            [btn removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(onLoadMoreHot:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGSizeMake(SCREEN_WIDTH, 121);
    }else if(section == 1){
        return CGSizeMake(SCREEN_WIDTH, 80);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(93, 171);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *dataSource = nil;
    if(indexPath.section == 2){
        dataSource = self.updatedList;
    }else if (indexPath.section == 3){
        dataSource = self.recommendList;
    }else if (indexPath.section == 4){
        dataSource = self.hotList;
    }
    
//    [APP_DELEGATE.tempParam removeAllObjects];
//    if(dataSource[indexPath.row][@"speciesId"] == nil){
//        [APP_DELEGATE.tempParam setObject:dataSource[indexPath.row][@"speciId"] forKey:@"speciesId"];
//    }
//    [APP_DELEGATE.tempParam addEntriesFromDictionary:dataSource[indexPath.row]];
    
    GroupBuyItemDetailViewController *detailView = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:dataSource[indexPath.row] andType:HuEasyProductTypeOrdinary];
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
}

#pragma mark - callbacks
- (void)shouldOpenProductDetailPage:(NSDictionary *)productInfo
{
    //TODO:navigate to detail page
}

- (void)carouselView:(CarouselView *)carouselView didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark - user interaction
-(IBAction)groupBuyBtnClicked:(UIButton *)sender
{
    FlashSaleViewController *groupBuy = [[FlashSaleViewController alloc] initWithSaleType:0];
    groupBuy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupBuy animated:YES];
    [groupBuy release];
//    if (APP_DELEGATE.tempParam)
//    {
//        [APP_DELEGATE.tempParam removeAllObjects];
//    }
    
    
}

-(IBAction)couponBtnClicked:(UIButton *)sender
{
    void (^successBlock)() =^(){
        CouponViewController *coupon = [[CouponViewController alloc] init];
        coupon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coupon animated:YES];
        [coupon release];
    };
    
    if(![APP_DELEGATE isLoggedIn]){
        //跳转到登录界面
        LoginViewController *login = [[LoginViewController alloc] init];
        login.successBlock = successBlock;
//        login.modalPresentationStyle = UIModalPresentationNone;
//        [self presentViewController:login animated:YES completion:nil];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
        [login release];
        [self presentViewController:navi animated:YES completion:nil];
        [navi release];
        
    }else{
        successBlock();
    }
}
- (void)onLoadMoreNew:(UIButton *)sender{
    /*
    [ZacNoticeView showAtPosition:CGPointMake(20, 300) image:[UIImage imageNamed:@"3-03shipping address_add address_normal"] text:@"您已经成功提交订单" duration:2.0];
    return;
    */
    
    MoreProductVC *moreVC = [[MoreProductVC alloc] initWithType:HomePageMoreProductNew];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
    [moreVC release];
}

- (void)onLoadMoreHot:(UIButton *)sender{
    MoreProductVC *moreVC = [[MoreProductVC alloc] initWithType:HomePageMoreProductHot];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
    [moreVC release];
}

- (void)onLoadMoreRecommend:(UIButton *)sender{
    MoreProductVC *moreVC = [[MoreProductVC alloc] initWithType:HomePageMoreProductRecommend];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
    [moreVC release];
}

 -(IBAction)flashSaleBtnClicked:(UIButton *)sender;
{
    FlashSaleViewController *flashSale = [[FlashSaleViewController alloc] initWithSaleType:1];
    flashSale.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:flashSale animated:YES];
    [flashSale release];
}


#pragma mark -searchBardelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=YES;
    UIView* view=searchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton=NO;
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchResultViewController *searchResultCtrl=[[searchResultViewController alloc]initWithNibName:@"searchResultViewController" bundle:nil];
    searchResultCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchResultCtrl animated:YES];
    
    //    [self.navigationController.tabBarController setHidesBottomBarWhenPushed:YES];//这句没用
    searchResultCtrl.searchString=searchBar.text;
    searchResultCtrl.isSearch=YES;
    
    [searchResultCtrl release];
    
}

@end
