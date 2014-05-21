//
//  searchResultViewController.m
//  huyihui
//
//  Created by zhangmeifu on 20/2/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "searchResultViewController.h"
#import "MyCustomerCell.h"
#import "SelectRequirementViewController.h"
#import <objc/message.h>
#import "GroupBuyItemDetailViewController.h"

#define kNumber_PerPage  4


@interface searchResultViewController ()
{
    UIScrollView *_selectScrollView;
    UIButton  *allBtn;
    UIButton *salesBtn;
    UIButton *popularityBtn;
    UIButton *priceBtn;
    
    BOOL scrollUp;
    BOOL isFlowLayout;
    BOOL downPrice;
    BOOL stopRequest;
    BOOL isLoadingData;
    
    UIActivityIndicatorView *activity;
}

@end

@implementation searchResultViewController

@synthesize searchString=_searchString;
@synthesize searchResultArr=_searchResultArr;
//@synthesize resultTable=_resultTable;
@synthesize parentId=_parentId;
@synthesize conId=_conId;
@synthesize isSearch=_isSearch;
@synthesize collectionView=_collectionView;
@synthesize orderByString=_orderByString;
@synthesize currentPage=_currentPage;
@synthesize requirementArr=_requirementArr;
@synthesize specificId=_specificId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        scrollUp=false;
        isFlowLayout=YES;
        downPrice=YES;
        _currentPage=1;
        self.searchResultArr=[[NSMutableArray alloc]init];
        stopRequest=NO;
        isLoadingData=false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ///self.tabBarController.tabBar.hidden = YES;
    self.title=@"搜索结果";
    
    UIButton *styleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [styleBtn setFrame:CGRectMake(SCREEN_WIDTH-60,0,35, 35)
     ];
    [styleBtn setBackgroundColor:[UIColor clearColor]];
    [styleBtn setImage:[UIImage imageNamed:@"2-03search listings_ chart icon"] forState:UIControlStateNormal];
    [styleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [styleBtn addTarget:self action:@selector(flowStyleSwitchAction:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *flowItem=[[UIBarButtonItem alloc]initWithCustomView:styleBtn];
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(SCREEN_WIDTH-60,0, 44, 35)
     ];
    [selectBtn setBackgroundColor:[UIColor clearColor]];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:selectBtn];
    
    if (_isSearch)
    {
         self.navigationItem.rightBarButtonItems = @[flowItem];
    }
    else
    {
         self.navigationItem.rightBarButtonItems = @[rightItem,flowItem];
        
    }
   
    [rightItem release];
    [flowItem release];
    
    
    [self.navigationItem.titleView addSubview:styleBtn];

    
    [self createWaitedDoScroll];
    

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset=UIEdgeInsetsMake(10, 0, 0, 10);

    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) collectionViewLayout:flowLayout];
    [flowLayout release];
    [self.view addSubview:_collectionView];
    [_collectionView showsVerticalScrollIndicator];
    _collectionView.backgroundColor=[UIColor lightGrayColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
    _collectionView.userInteractionEnabled=YES;
    _collectionView.alwaysBounceVertical=YES;

    
//    UIRefreshControl *refreshCtrl=[[UIRefreshControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
//    
//    [_collectionView addSubview:refreshCtrl];
//    NSAttributedString *attributeString=[[NSAttributedString alloc]initWithString:@"上拉加载更多"];
//    refreshCtrl.attributedTitle=attributeString;
//    [attributeString release];
//    [refreshCtrl release];
//
   
    
 
    
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    [_resultTable release];
    [_searchResultArr release];
    [_searchString release];
    self.requirementArr=nil;
    self.specificId=nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.currentPage=1;
    if (_searchResultArr)
    {
        [_searchResultArr removeAllObjects];
    }
    
    if (_isSearch)
    {
        [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self showNaviBar];

}


- (void)createWaitedDoScroll
{
    _selectScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _selectScrollView.scrollEnabled = YES;
    _selectScrollView.backgroundColor = [UIColor lightGrayColor];
    _selectScrollView.showsHorizontalScrollIndicator = NO;
    _selectScrollView.delegate = self;
    
    [self.view addSubview:_selectScrollView];
    _selectScrollView.hidden = NO;
    
    allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    allBtn.frame = CGRectMake(0, 0, 80, 44);
    
    [allBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
    [allBtn setTitle:@"综合" forState:UIControlStateNormal];
    [allBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [allBtn setTitleColor:[self rgbColor:"818181"] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectScrollView addSubview:allBtn];
    
    
    
    salesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    salesBtn.frame = CGRectMake(80, 0, 80, 44);
    [salesBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [salesBtn setTitle:@"销量" forState:UIControlStateNormal];
    [salesBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [salesBtn setTitleColor:[self rgbColor:"818181"] forState:UIControlStateNormal];
    [salesBtn addTarget:self action:@selector(salesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectScrollView addSubview:salesBtn];
    
    popularityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    popularityBtn.frame = CGRectMake(160, 0, 80, 44);
    [popularityBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [popularityBtn setTitle:@"时间" forState:UIControlStateNormal];
    [popularityBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [popularityBtn setTitleColor:[self rgbColor:"818181"] forState:UIControlStateNormal];
    [popularityBtn addTarget:self action:@selector(popularityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectScrollView addSubview:popularityBtn];
    
    priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.frame = CGRectMake(240, 0, 80, 44);
    priceBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 60, 0, 0);
    priceBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 20);
    [priceBtn setImage:[UIImage imageNamed:@"2-03search_list_pricedown2"] forState:UIControlStateNormal];
    [priceBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [priceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [priceBtn setTitleColor:[self rgbColor:"818181"] forState:UIControlStateNormal];
    [priceBtn addTarget:self action:@selector(priceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_selectScrollView addSubview:priceBtn];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(80, 10, 1, 25)];
    [lineView1 setBackgroundColor:[UIColor lightGrayColor]];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(161, 10, 1, 25)];
    [lineView2 setBackgroundColor:[UIColor lightGrayColor]];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(241, 10, 1,25)];
    [lineView3 setBackgroundColor:[UIColor lightGrayColor]];
    
    [_selectScrollView addSubview:lineView1];
    [_selectScrollView addSubview:lineView2];
    [_selectScrollView addSubview:lineView3];
    [lineView1 release];
    [lineView2 release];
    [lineView3 release];

    
}

-(void)allBtnClicked:(id)sender
{
    _currentPage=1;
    [_searchResultArr removeAllObjects];
    [allBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
    [salesBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [popularityBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [priceBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    
    _orderByString=nil;
    
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    
    
    if (_isSearch)
    {
        [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
        
    }

    
    
}
-(void)salesBtnClicked:(id)sender
{
     _currentPage=1;
     [_searchResultArr removeAllObjects];
    [allBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [salesBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
    [popularityBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [priceBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    
     self.orderByString=@"10";
    
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    
    if (_isSearch)
    {
        [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
    }
    else
    {
    
    [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
    }
    
}

-(void)popularityBtnClicked:(id)sender
{
     _currentPage=1;
     [_searchResultArr removeAllObjects];
    [allBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [salesBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [popularityBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
    [priceBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    self.orderByString=@"20";
    
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    
    if (_isSearch)
    {
        [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
        
    }

    
}

-(void)priceBtnClicked:(id)sender
{
     _currentPage=1;
     [_searchResultArr removeAllObjects];
    downPrice=!downPrice;
    
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    
    if (downPrice)
    {
        self.orderByString=@"00";
        
        [priceBtn setImage:[UIImage imageNamed:@"2-03search_list_pricedown2"] forState:UIControlStateNormal];
        if (_isSearch)
        {
            [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
        }
        else
        {
        [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
        }
        
        

    }
    else
    {
        [priceBtn setImage:[UIImage imageNamed:@"2-03search_list_priceup1"] forState:UIControlStateNormal];
        
        self.orderByString=@"01";

        if (_isSearch)
        {
            [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
        }
        else
        {

        [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
        }
        
      
    }
    
    [allBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [salesBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [popularityBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_normal"] forState:UIControlStateNormal];
    [priceBtn setBackgroundImage:[UIImage imageNamed:@"4-01background_selected"] forState:UIControlStateNormal];
    
}

-(UIColor *)rgbColor:(char*)color
{
    int Red = 0, Green = 0, Blue = 0;
    sscanf(color, "%2x%2x%2x", &Red, &Green, &Blue);
    return [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:1.0];
}

-(void)selectAction:(id)sender
{
    SelectRequirementViewController *selectRequireCtrl=[[SelectRequirementViewController alloc]init];
    selectRequireCtrl.parentId=self.parentId;
    selectRequireCtrl.conId=self.conId;
    selectRequireCtrl.doneSelect= ^(NSString *specificId,NSMutableArray *array){
        self.requirementArr=array;
        self.specificId=specificId;
        
        
    };
    [self.navigationController pushViewController:selectRequireCtrl animated:YES];
    [selectRequireCtrl release];
    
    
}
-(void)flowStyleSwitchAction:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    isFlowLayout=!isFlowLayout;
    
    if (isFlowLayout)
    {
        [btn setImage:[UIImage imageNamed:@"2-03search listings_ chart icon"] forState:UIControlStateNormal];
        
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"2-03search listings_list icon"] forState:UIControlStateNormal];

    }
    
    
//    if (btn.state==UIControlStateNormal)
//    {
//        isFlowLayout=YES;
//    }
//    else
//    {
//        isFlowLayout=NO;
//    }
//    
    [self.collectionView reloadData];
    
    
    
}


#pragma mark - collectionView datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  
   return  1;
        
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
   return [_searchResultArr count];
       
    
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFlowLayout)
    {
        return CGSizeMake(150, 217);
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH, 120);
    }
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section

{
    if (isFlowLayout)
    {
        return 0;
    }
    else
    {
        return 0;
    }
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_queue_t newQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      UICollectionViewCell *cell=nil;
    if (isFlowLayout)
    {
        [collectionView registerNib:[UINib nibWithNibName:@"searchResultCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"flowCell"];
          cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"flowCell" forIndexPath:indexPath];
        
    }
    else
    {
        [collectionView registerNib:[UINib nibWithNibName:@"searchResultHorizonCell" bundle:nil] forCellWithReuseIdentifier:@"resultCell"];
         cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"resultCell" forIndexPath:indexPath];
        
    }
    
  

    cell.userInteractionEnabled=YES;
    cell.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
    
    UIImageView *productImageView=( UIImageView *)[cell viewWithTag:10];
    productImageView.layer.borderWidth=2;
    productImageView.layer.borderColor=[UIColor whiteColor].CGColor;
   

    NSDictionary *dic=nil;
    
    dic=[_searchResultArr objectAtIndex:indexPath.row];
    
    if (dic)
    {
         [productImageView setImage:[UIImage imageNamed:@"2-03search listings_list_Material picture's "]];
        

        for (UIView *view in cell.subviews)
        {
            if ([view isKindOfClass:[UILabel class]])
            {
                UILabel *label=(UILabel*)view;
                switch (label.tag) {
                    case 1:
                        label.font=[UIFont systemFontOfSize:14];
                        label.textColor=[Util rgbColor:"3d4245"];
                        if (_isSearch)
                        {
                            label.text=[dic objectForKey:@"speciesName"];
                        }
                        else
                        {
                            label.text=[dic objectForKey:@"prodName"];
                        }
                        
                        
                        break;
                    case 2:
                        label.text=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"minSalePrice"]];
                        [label setFont:[UIFont systemFontOfSize:15]];
                        [label setTextColor:[Util rgbColor:"c80000"]];
                        break;
                    case 3:
                    {
                        NSDictionary *attributeDic=@{
                                NSStrikethroughStyleAttributeName:
                                   [NSNumber numberWithInt:NSUnderlineStyleSingle],//NSStrikethroughColorAttributeName:[UIColor grayColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:12],
                                NSForegroundColorAttributeName:[UIColor grayColor]
                                };
                        NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"minRetailPrice"]] attributes:attributeDic];
                        label.attributedText=attributeString;
                       
                    }
                        break;
                    case 4:
                    {
                        float scalePrice=[[dic objectForKey:@"minSalePrice"]floatValue];
                        float retailPrice=[[dic objectForKey:@"minRetailPrice"]floatValue];
                        if (retailPrice)
                        {
                            label.text=[NSString stringWithFormat:@"%0.1f折",10*scalePrice/retailPrice];
                        }
                        else
                        {
                            label.text=[NSString stringWithFormat:@"0折"];
                            
                        }
                        
                        [label setFont:[UIFont systemFontOfSize:12]];
                         label.textColor=[Util rgbColor:"3d4245"];
                    }
                        break;
                    case 5:
                        if ([dic objectForKey:@"sales" ])
                        {
                             label.text=[NSString stringWithFormat:@"%@人购买",[dic objectForKey:@"sales" ]];
                        }
                        label.textColor=[Util rgbColor:"b7b7b7"];
                        label.font=[UIFont systemFontOfSize:13];
                        break;
                        
                    default:
                        break;
                }
            }
            if ([view isKindOfClass:[UITextView class]])
            {
                UITextView *textView=(UITextView*)view;
                textView.text=[dic objectForKey:@"speciesName"];
            }
    
        }
        
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[dic objectForKey:@"mediaPath"]]];
        
        [Util UIImageFromURL:url withImageBlock:^(UIImage *image) {
            if (image)
            {
                [productImageView setImage:image];
            }
        } errorBlock:nil ];
        

        

    }
    


    
    return cell;
    
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 28);
    
}


-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
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

    label.text = @"上拉加载更多";
    if (isLoadingData)
    {
        label.text = @"加载中";
        
    }
    if (stopRequest)
    {
        label.text = @"全部加载完毕";

    }
    if (_searchResultArr.count == 0)
    {
        label.text = @"未找到符合的商品";
    }
     return footerView;
}
#pragma mark collectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-0---------");
//    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor=[UIColor redColor];
    GroupBuyItemDetailViewController *groupBuyItemDetailCtrl=[[GroupBuyItemDetailViewController alloc]initWithNibName:@"GroupBuyItemDetailViewController" bundle:nil];
    [groupBuyItemDetailCtrl initWithProductInfo:[self.searchResultArr objectAtIndex:indexPath.row] andType:HuEasyProductTypeOrdinary];
    [self.navigationController pushViewController:groupBuyItemDetailCtrl animated:YES];
    [groupBuyItemDetailCtrl release];
    
}



#pragma mark -scrollview delgate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    static float lastOffy=0;
    float curOffy=scrollView.contentOffset.y;
    
    //    if (scrollView.frame.size.height>=scrollView.contentSize.height||SCREEN_HEIGHT+fabs(curOffy)>scrollView.contentSize.height||curOffy<0)
    //    {
    //        return;
    //    }
    
    if (curOffy-lastOffy>40)
    {
        //向上
        scrollUp=true;
        lastOffy=curOffy;
        if (!self.navigationController.navigationBar.hidden)
        {
            //  [self hideNaviBar];
        }
        
    }
    else if (lastOffy-curOffy>40)
    {
        //向下
        
        scrollUp=false;
        lastOffy=curOffy;
        if (self.navigationController.navigationBar.hidden)
        {
            //   [self showNaviBar];
        }
        
        
    }
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    {
        
        // proceed with the loading of more data
        NSLog(@"currentPage is:%d",_currentPage);
        if (!stopRequest)
        {
            if (!isLoadingData)
            {
                [activity startAnimating];
                if (_isSearch)
                {
                    
                    [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
                }
                else
                {
                    [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
                }
                
            }
            
            
            
        }
        
        
        
        
        
        
    }

    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    static float lastOffy=0;
//    float curOffy=scrollView.contentOffset.y;
//    
////    if (scrollView.frame.size.height>=scrollView.contentSize.height||SCREEN_HEIGHT+fabs(curOffy)>scrollView.contentSize.height||curOffy<0)
////    {
////        return;
////    }
//    
//    if (curOffy-lastOffy>40)
//    {
//        //向上
//        scrollUp=true;
//        lastOffy=curOffy;
//        if (!self.navigationController.navigationBar.hidden)
//        {
//          //  [self hideNaviBar];
//        }
//        
//    }
//    else if (lastOffy-curOffy>40)
//    {
//        //向下
//        
//        scrollUp=false;
//        lastOffy=curOffy;
//        if (self.navigationController.navigationBar.hidden)
//        {
//          //   [self showNaviBar];
//        }
//       
//        
//    }
//    
//    
//    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
//    {
//        
//            // proceed with the loading of more data
//            NSLog(@"currentPage is:%d",_currentPage);
//                if (!stopRequest)
//                {
//                    if (!isLoadingData)
//                    {
//                        if (_isSearch)
//                        {
//                            
//                            [NSThread detachNewThreadSelector:@selector(searchProductFromServer) toTarget:self withObject:nil];
//                        }
//                        else
//                        {
//                            [NSThread detachNewThreadSelector:@selector(getProductFromServerByCatalog) toTarget:self withObject:nil];
//                        }
//
//                    }
//                   
//                    
//                   
//                }
//               
//               
//                
//        
//
//        
//    }
//    
//    
//}
-(void)searchProductFromServer
{
    @autoreleasepool
    {
         isLoadingData=true;
    
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"pageIndex"];
        [params setObject:[NSNumber numberWithInt:kNumber_PerPage] forKey:@"num"];
        [params setObject:_searchString forKey:@"keyWord"];
        if (self.orderByString)
        {
            [params setObject:self.orderByString forKey:@"orderBy"];
        }
        [RemoteManager Posts:kGET_SEARCH_INFO Parameters:params WithBlock:^(id json, NSError *error)
        {
            if (error==nil)
            {
                 _currentPage++;
                [CustomBezelActivityView removeView];
                [activity stopAnimating];
                
                [self refreshTable:json];
                
            }
            else
            {
             NSLog(@"the error is:%@",error);
            }
        }];
        
        
    }
    
   // NSInvocation
   
}
-(void)refreshTable:(id)json
{
    
    NSLog(@"the search result is:%@",json);
    if (json)
    {
        if ([json isKindOfClass:[NSDictionary class]])
        {
        
            if ([[json objectForKey:@"searchWareList"]count]<kNumber_PerPage)
            {
                stopRequest=YES;
            }
            else
            {
                stopRequest=NO;
                
            }
            [_searchResultArr addObjectsFromArray:[json objectForKey:@"searchWareList"]];

        }
    }
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    isLoadingData=false;
    
}

-(void)getProductFromServerByCatalog
{
    @autoreleasepool
    {
        isLoadingData=true;
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:[NSNumber numberWithInt:kNumber_PerPage] forKey:@"num"];
        [params setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"pageIndex"];
        if (_parentId)
        {
             [params setObject:_parentId forKey:@"parentId"];
        }
        if (_conId)
        {
            [params setObject:_conId forKey:@"conId"];
        }
        
        
        if (self.specificId!=nil)
        {
           
            if (![self.specificId isEqualToString:@""])
            {
                [params setObject:_specificId forKey:@"specificationId"];
            }
        }
        
        NSString *speciesColumnValue=@"";
        if (self.requirementArr)
        {
            if ([self.requirementArr count])
            {
                speciesColumnValue=[NSString stringWithFormat:@"%@,%@,%@,%@",[[self.requirementArr objectAtIndex:0] objectForKey:@"category"],[[self.requirementArr objectAtIndex:0] objectForKey:@"columnName"],[[self.requirementArr objectAtIndex:0] objectForKey:@"attributesphraseId"],[[self.requirementArr objectAtIndex:0] objectForKey:@"phraseId"]];
                for(int i=1;i<[self.requirementArr count];i++)
                {
                    NSMutableDictionary *dic=[self.requirementArr objectAtIndex:i];
                    speciesColumnValue=[speciesColumnValue stringByAppendingString:[NSString stringWithFormat:@":%@,%@,%@,%@",[dic objectForKey:@"category"],[dic objectForKey:@"columnName"],[dic objectForKey:@"attributesphraseId"],[dic objectForKey:@"phraseId"]]];
                }
                
                [params setObject:speciesColumnValue forKey:@"speciesColumnValue"];
            }
            
            
        }
        if (self.orderByString)
        {
            [params setObject:self.orderByString forKey:@"orderBy"];
        }
        [RemoteManager Posts:kGET_WARELIST Parameters:params WithBlock:^(id json, NSError *error)
         {
             if (error==nil)
             {
                  _currentPage++;
                 [activity stopAnimating];
                 [CustomBezelActivityView removeView];
                 NSLog(@"JSON IS %@",json);
                 //[self refreshTable:json];
                 if (json)
                 {
                     if ([json isKindOfClass:[NSDictionary class]]&&![[json objectForKey:@"warelist"]isEqual:[NSNull null]])
                     {
                         if ([[json objectForKey:@"warelist"]count]<kNumber_PerPage)
                         {
                             stopRequest=YES;
                         }
                         else
                         {
                             stopRequest=NO;
                             
                         }
                         [_searchResultArr addObjectsFromArray:[json objectForKey:@"warelist"]];

                     }
                 }
                 
                
                 [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                 
                 isLoadingData=false;
                 
             }
             else
             {
                 NSLog(@"the error is:%@",error);
             }
         }];
        
        
    }
    

    
}

- (void)showNaviBar
{
//    if (self.tabBarController.tabBar.hidden == NO)
//    {
//        return;
//    }
//    
//    UIView *contentView;
//    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    else
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,
//                                   contentView.bounds.origin.y,
//                                   contentView.bounds.size.width,
//                                   contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.4f;
//    animation.type = kCATransitionMoveIn;
//    animation.subtype = kCATransitionFromTop;
//    self.tabBarController.tabBar.hidden = NO;
//  	[self.tabBarController.tabBar.layer addAnimation:animation forKey:@"animation2"];
    
    CATransition *animation1 = [CATransition animation];
    animation1.duration = 0.4f;
    animation1.type = kCATransitionMoveIn;
    animation1.subtype = kCATransitionFromBottom;
    self.navigationController.navigationBarHidden = NO;
//  	[self.navigationController.navigationBar.layer addAnimation:animation1 forKey:@"animation3"];
    
}
- (void)hideNaviBar
{
//    if (self.tabBarController.tabBar.hidden == YES)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    else
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,
//                                   contentView.bounds.origin.y,
//                                   contentView.bounds.size.width,
//                                   contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    
    
    CATransition *animation1 = [CATransition animation];
    animation1.timingFunction=UIViewAnimationCurveEaseInOut;
    animation1.duration = 0.4f;
    animation1.delegate =self;
    animation1.type = kCATransitionReveal;
    animation1.subtype = kCATransitionFromTop;
    self.navigationController.navigationBarHidden = YES;
  	[self.navigationController.navigationBar.layer addAnimation:animation1 forKey:@"animation0"];
    
//    //定义个转场动画
//    CATransition *animation = [CATransition animation];
//    //转场动画持续时间
//    animation.duration = 0.4f;
//    //计时函数，从头到尾的流畅度？？？
//    animation.timingFunction=UIViewAnimationCurveEaseInOut;
//    //转场动画类型
//    animation.type = kCATransitionReveal;
//    //转场动画子类型
//    animation.subtype = kCATransitionFromBottom;
//    //动画时你需要的实现
//    self.tabBarController.tabBar.hidden = YES;
//    //添加动画 （转场动画是添加在层上的动画）
//  	[self.tabBarController.tabBar.layer addAnimation:animation forKey:@"animation1"];
}



@end
