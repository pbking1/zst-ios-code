//
//  MinePageViewController.m
//  huyihui
//
//  Created by zaczh on 14-2-20.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "MinePageViewController.h"
//#import "ShareViewController.h"
#import "OrderListController.h"
#import "SectionFactory.h"
#import "MoreConfigure.h"
#import "accountManage.h"
#import "ReceiveAddressController.h"
#import "MyProductRating.h"

#define kNumber_PerPage  6

@interface moreFooterView ()
{
    
    UIButton *moreBtn;
    
}

@end

@implementation moreFooterView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.tag=1;
        [moreBtn setFrame:CGRectMake(self.bounds.size.width/2-75, 0, 150, 50)];
        [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"4-01personal center_more"] forState:UIControlStateNormal];
        [moreBtn setBackgroundColor:[UIColor clearColor]];
        moreBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 40, 0,0 );
        [moreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
        
       
        
        [self addSubview:moreBtn];
        
    }
    
    return self;
}

-(void)dealloc
{

    [super dealloc];
}

@end


@interface MinePageViewController ()
{
    UIButton *footPrintsBtn;
    UIButton *collectBtn;
    BOOL isBrowse;
    BOOL stopRequest;
    BOOL isLoadingData;
    UIActivityIndicatorView *activity;
    
    
    
//    NSArray *myCollection;
//    
//    NSArray *myViewHistory;
}

@end

@implementation MinePageViewController

@synthesize browseHistoryArr=_browseHistoryArr;
@synthesize myCollection=_myCollection;
@synthesize currentBrowsePage=_currentBrowsePage;
@synthesize currentCollectPage=_currentCollectPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//         moreBtn.frame=CGRectMake(SCREEN_WIDTH-100, 0, 80, 30);
//        [moreBtn setBackgroundColor:[UIColor clearColor]];
//        [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
//        [moreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        //    self.navigationController.navigationItem.titleView=moreBtn;
//        [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:moreBtn];
        
        _currentBrowsePage=1;
        _currentCollectPage=1;
        stopRequest=NO;
        isLoadingData=false;
        
        isBrowse=true;
        self.browseHistoryArr=[[NSMutableArray alloc]init];
        self.myCollection=[[NSMutableArray alloc]init];
        
        ButtonFactory *buttonFactory = [ButtonFactory factory];
        UIButton *rightBtn = [buttonFactory createButtonWithType:HuEasyButtonTypeMore];
        [rightBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        [rightBarItem release];
        
        // [self.navigationController.navigationItem setRightBarButtonItem:rightBar];
//        NSLog(@"----%@",self.navigationItem);
//        NSLog(@"----%@",self.navigationController.navigationItem);
//        self.navigationItem.rightBarButtonItem=rightBar;
        //    self.navigationController.navigationItem.leftBarButtonItem=rightBar;
//        [rightBar release];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!isBrowse)
    {
        [self.myCollection removeAllObjects];
        [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
        [NSThread detachNewThreadSelector:@selector(getCollectInfoFromServer) toTarget:self withObject:nil];
    }
    else
    {
        [self.browseHistoryArr removeAllObjects];
        [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
        [NSThread detachNewThreadSelector:@selector(getBroswerWareFromServer) toTarget:self withObject:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = nil;
    self.mineCollectionView.backgroundColor=[UIColor whiteColor];
//    UICollectionViewFlowLayout *flowLayout=(UICollectionViewFlowLayout*)self.mineCollectionView.collectionViewLayout;
    
//    UICollectionViewController *collectionCtrl;
//    UIRefreshControl *refreshCtrl=[[UIRefreshControl alloc]init];
//    refreshCtrl.tintColor=[UIColor grayColor];
//    
//    [self.mineCollectionView addSubview:refreshCtrl];
 //   [refreshCtrl release];
    self.mineCollectionView.alwaysBounceVertical=YES;
    self.mineCollectionView.showsVerticalScrollIndicator=NO;
    [NSThread detachNewThreadSelector:@selector(getBroswerWareFromServer) toTarget:self withObject:nil];
    
    
    
    [self.mineCollectionView registerNib:[UINib nibWithNibName:@"NewProductCollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
//    SectionFactory *section=[SectionFactory factory];
//    UIButton *moreBtn=[section createButtonWithType:MOREBTN];
    
    //[self.view addSubview:moreBtn];
    
    
//    self.mineCollectionView.collectionViewLayout registerClass:(Class) forDecorationViewOfKind:(NSString *)
    
//    NSString *text = @"first";
//    NSMutableAttributedString *textLabelStr = [[NSMutableAttributedString alloc] initWithString:text];
//    
//    textLabelStr addAttribute:NSUnderlineStyleAttributeName value:(id) range:(NSRange)
//    [textLabelStr setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor],	NSFontAttributeName : [UIFont systemFontOfSize:17]} range:NSMakeRange(11, 10)];
    
   
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    btn.backgroundColor = [UIColor greenColor];
//    [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    [btn release];
}

//- (void)viewWillAppear:(BOOL)animated{
//    if(!APP_DELEGATE.isLoggedIn){
//        LoginViewController *login = [[LoginViewController alloc] init];
//        login.successBlock = ^(){
//            [self requestData];
//        };
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
//        [login release];
//        [self presentViewController:navi animated:YES completion:nil];
//        [navi release];
//    }else{
//        [self requestData];
//    }
//    [super viewWillAppear:animated];
//}

//- (void)tap:(id)sender
//{
//    ShareViewController *share = [[ShareViewController alloc] init];
//    share.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:share animated:YES];
//    [share release];
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.myCollection=nil;
    self.browseHistoryArr=nil;
    [_mineCollectionView release];
    [super dealloc];
}


-(void)moreBtnAction:(id)sender
{
    NSLog(@"more action swith!");
    
    MoreConfigure *moreSetConfigure=[[MoreConfigure alloc]initWithNibName:@"MoreConfigure" bundle:nil];
    moreSetConfigure.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreSetConfigure animated:YES];
    moreSetConfigure.title=@"更多";
    [moreSetConfigure release];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (isBrowse)
    {
        return  [self.browseHistoryArr count];
    }
    else
    {
        return  [self.myCollection count];
        
    }
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(93, 171);
    return size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

   UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *picture=(UIImageView *)[cell viewWithTag:1];
    UILabel  *productNameLabel=(UILabel*)[cell viewWithTag:2];
    UILabel *nowPriceLabel=(UILabel *)[cell viewWithTag:3];
    UILabel *oldPriceLabel=(UILabel *)[cell viewWithTag:4];
    
    NSDictionary *localData = nil;
    if (isBrowse)
    {
        localData = [self.browseHistoryArr objectAtIndex:indexPath.row];
    }
    else
    {
        localData = [self.myCollection objectAtIndex:indexPath.row];
    }
    if (isBrowse) {
        productNameLabel.text=[localData objectForKey:@"prodName"];
    }
    else
    {
        productNameLabel.text=[localData objectForKey:@"name"];
    }
    
    nowPriceLabel.text=[NSString stringWithFormat:@"￥%@",[localData objectForKey:@"salePrice"]];
   
    NSDictionary *attributedDic=@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger: NSUnderlineStyleSingle],NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]};
//    ,NSStrikethroughColorAttributeName:[UIColor redColor]
   // NSString *oldPrice=[[self.browseHistoryArr objectAtIndex:indexPath.row]objectForKey:@"prodName"];
    NSMutableAttributedString *oldPriceString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f", [localData[@"salePrice"] floatValue]] attributes:attributedDic];
    oldPriceLabel.attributedText=oldPriceString;
   
    oldPriceLabel.hidden = YES;
    
    [oldPriceString release];
//
    NSURL *imageUrl = nil;
    if(isBrowse){
    imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER, [localData objectForKey:@"picturePath"]]];
    }else{
        imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER, [localData objectForKey:@"imgPath"]]];
    }
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
            picture.layer.borderWidth=2;
            picture.layer.borderColor=[UIColor whiteColor].CGColor;

            if(loadingView){
                [loadingView removeFromSuperview];
            }
        }
    } errorBlock:nil];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *cells=[[NSBundle mainBundle ]loadNibNamed:@"MinePageCell" owner:self options:nil];
//    return [cells objectAtIndex:1];
    
//     [collectionView registerNib:[UINib nibWithNibName:@"MinePageHeaderView" bundle:nil] forSupplementaryViewOfKind:@"headView" withReuseIdentifier:@"cellHeader"];
//   UICollectionReusableView *reusableView=[collectionView dequeueReusableSupplementaryViewOfKind:@"headView" withReuseIdentifier:@"cellHeader" forIndexPath:indexPath];
//    return reusableView;
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        [collectionView registerNib:[UINib nibWithNibName:@"MinePageHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
//        [collectionView registerNib:[cells objectAtIndex:1]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UILabel *nameLabel = (UILabel *)[headerView viewWithTag:2];
        UILabel *levelLabel = (UILabel *)[headerView viewWithTag:3];
        UIButton *waitToPay=(UIButton*)[headerView viewWithTag:4];
        UIButton *waitTosend=(UIButton*)[headerView viewWithTag:5];
        UIButton *waitToReceive=(UIButton*)[headerView viewWithTag:6];
        UIButton *haveDone=(UIButton*)[headerView viewWithTag:7];
        UIButton *accountManageBtn=(UIButton*)[headerView viewWithTag:8];
        UIButton *receiveAddressManage=(UIButton*)[headerView viewWithTag:9];
        UIButton *shareBtn=(UIButton*)[headerView viewWithTag:10];
         footPrintsBtn=(UIButton*)[headerView viewWithTag:11];
         collectBtn=(UIButton*)[headerView viewWithTag:12];
        
        nameLabel.text = [NUSD objectForKey:kCurrentUserName];
      
        [waitToPay addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [waitTosend addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [waitToReceive addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [haveDone addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [accountManageBtn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [receiveAddressManage addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [footPrintsBtn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [collectBtn addTarget:self action:@selector(headBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerView=nil;
        if ([kind isEqualToString:UICollectionElementKindSectionFooter])
        {
            [collectionView registerNib:[UINib nibWithNibName:@"RefreshFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"refresh"];
            footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"refresh" forIndexPath:indexPath];
            
        }
        UILabel *label=(UILabel*)[footerView viewWithTag:2];
        activity=(UIActivityIndicatorView*)[footerView viewWithTag:1];
        activity.hidesWhenStopped=YES;
        
        label.text=@"上拉加载更多";
        if (isLoadingData)
        {
            label.text=@"加载中";
            
        }
        if (stopRequest)
        {
            label.text=@"全部加载完毕";
            
        }
        if (!isBrowse && (self.myCollection.count == 0))
        {
            label.text=@"您的收藏夹中没有商品";
            
        }
        reusableview=footerView;
        
    }
    
    return reusableview;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------足迹");
    
    GroupBuyItemDetailViewController *groupBuyItemDetailCtrl = nil;
    if (isBrowse)
    {
        groupBuyItemDetailCtrl = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:[self.browseHistoryArr objectAtIndex:indexPath.row] andType:HuEasyProductTypeOrdinary];
    }
    else
    {
        groupBuyItemDetailCtrl = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:[self.myCollection objectAtIndex:indexPath.row] andType:HuEasyProductTypeOrdinary];
        
    }
    
    groupBuyItemDetailCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupBuyItemDetailCtrl animated:YES];
    [groupBuyItemDetailCtrl release];
}


#pragma mark -scrollview delegate

#pragma mark -scrollview delgate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isBrowse)
    {
         NSLog(@"currentBrowsePage is:%d",_currentBrowsePage);
    }
    else
    {
         NSLog(@"currentCollectPage is:%d",_currentCollectPage);
    }
   
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    {
        
        // proceed with the loading of more data
      
        if (!stopRequest)
        {
            if (!isLoadingData)
            {
        
                if (isBrowse)
                {
                    
                    [NSThread detachNewThreadSelector:@selector(getBroswerWareFromServer) toTarget:self withObject:nil];
                }
                else
                {
                    [NSThread detachNewThreadSelector:@selector(getCollectInfoFromServer) toTarget:self withObject:nil];
                }
                
            }
            
            
            
        }
        
        
        
        
        
        
    }
    
    
}



#pragma mark -button  action

-(void)headBtnAction:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    switch (btn.tag)
    {
        case 4:
        {
            OrderListController *myOrder=[[OrderListController alloc]initWithOrderStatus:1];
            myOrder.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myOrder animated:YES];
            [myOrder release];
            
        }
            break;
        case 5:
        {
            OrderListController *myOrder=[[OrderListController alloc]initWithOrderStatus:2];
            myOrder.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myOrder animated:YES];
            [myOrder release];
            
        }
            break;
        case 6:
        {
            OrderListController *myOrder=[[OrderListController alloc]initWithOrderStatus:4];
            myOrder.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myOrder animated:YES];
            [myOrder release];
            
        }
            break;
        case 7:
        {
            OrderListController *myOrder=[[OrderListController alloc]initWithOrderStatus:5];
            myOrder.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myOrder animated:YES];
            [myOrder release];
            
        }
            break;
        case 8:
        {
            accountManage *account=[[accountManage alloc]init];
            account.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:account animated:YES];
            [account release];
            
        }
            break;
        case 9:
        {
            ReceiveAddressController *receiveAddress=[[ReceiveAddressController alloc]init];
            receiveAddress.isManaging=true;
            receiveAddress.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:receiveAddress animated:YES];
            [receiveAddress release];
            
        }
            break;
        case 10:
        {
            MyProductRating *productRating=[[MyProductRating alloc]initWithNibName:@"MyProductRating" bundle:nil];
            productRating.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:productRating animated:YES];
            [productRating release];
            
        }
            break;
        case 11:
        {
            stopRequest=NO;
            _currentBrowsePage=1;
            [_browseHistoryArr removeAllObjects];
            isBrowse=true;
            [btn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
            [collectBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
            
            [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
            [NSThread detachNewThreadSelector:@selector(getBroswerWareFromServer) toTarget:self withObject:nil];
            
            
            
        }
            break;
        case 12:
        {
            stopRequest=NO;
            _currentCollectPage=1;
            [_myCollection removeAllObjects];
            isBrowse=false;
            [btn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
            [footPrintsBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
            
            [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
            [NSThread detachNewThreadSelector:@selector(getCollectInfoFromServer) toTarget:self withObject:nil];

            
        }
            break;

            
        default:
            break;
    }
    
    
}
-(void)getBroswerWareFromServer
{
    @autoreleasepool
    {
        isLoadingData=YES;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
        [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
        [param setObject:[NSNumber numberWithInt: kNumber_PerPage] forKey:@"num"];
        [param setObject:[NSNumber numberWithInt:_currentBrowsePage] forKey:@"pageIndex"];
        
        
        [RemoteManager Posts:kGET_BROWSER_WARE Parameters:param WithBlock:^(id json, NSError *error) {
            [CustomBezelActivityView removeViewAnimated:YES];
            if(error == nil){
                if([[json objectForKey:@"state"] integerValue] == 1){
                   
                
                    if ([json isKindOfClass:[NSDictionary class]]&&![[json objectForKey:@"browerList"]isEqual:[NSNull null]])
                    {
                        [self.browseHistoryArr addObjectsFromArray: json[@"browerList"]];
                        if ([[json objectForKey:@"browerList"]count]<kNumber_PerPage)
                        {
                            stopRequest=YES;
                        }
                        else
                        {
                            _currentBrowsePage++;
                            stopRequest=NO;
                            
                        }
                        
                    }
                    else
                    {
                        stopRequest=YES;
                        
                    }
                    
                    [self.mineCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    
                    
                    
                    isLoadingData=false;

                }else{
                    NSLog(@"server error");
                    NSLog(@"reason: %@",[json objectForKey:@"message"]);
                }
            }else{
                NSLog(@"network error :%@",error);
            }
        }];

    }
    [self.mineCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
    
}

-(void)getCollectInfoFromServer
{
    
    @autoreleasepool
    {
        isLoadingData=true;
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
        [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
        [params setObject:[NSNumber numberWithInt:6] forKey:@"num"];
        [params setObject:[NSNumber numberWithInt:_currentCollectPage] forKey:@"pageIndex"];
        [RemoteManager Posts:kGET_COLLECT_INFO Parameters:params WithBlock:^(id json, NSError *error) {
            [CustomBezelActivityView removeViewAnimated:YES];
            if(error == nil){
                if([[json objectForKey:@"state"] integerValue] == 1){
                  
                    
                    if ([json isKindOfClass:[NSDictionary class]]&&![[json objectForKey:@"collentList"]isEqual:[NSNull null]])
                    {
                         [self.myCollection addObjectsFromArray: json[@"collentList"]];
                        if ([[json objectForKey:@"collentList"]count]<kNumber_PerPage)
                        {
                            stopRequest=YES;
                        }
                        else
                        {
                            _currentCollectPage++;
                            stopRequest=NO;
                            
                        }
                        
                    }
                    else
                    {
                        stopRequest=YES;
                    }

                    [self.mineCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    
                    isLoadingData=false;
                }else{
                    NSLog(@"server error");
                    NSLog(@"reason: %@",[json objectForKey:@"message"]);
                }
            }else{
                NSLog(@"network error :%@",error);
            }
        }];

        [params release];
    }
     [self.mineCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

    
}




@end
