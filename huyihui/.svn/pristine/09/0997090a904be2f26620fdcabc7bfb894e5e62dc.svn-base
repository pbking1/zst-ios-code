//
//  ProductSearchViewController.m
//  huyihui
//
//  Created by zaczh on 14-2-20.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ProductSearchViewController.h"
#import "searchResultViewController.h"
#import "SearchMyProduct.h"
#import "UIImage+imageWithColor.h"

@interface ProductSearchViewController ()

@end

@implementation ProductSearchViewController


@synthesize searchBar=_searchBar;
@synthesize categoryTable=_categoryTable;
@synthesize firstCatalogueArr=_firstCatalogueArr;
@synthesize subCatalogArr=_subCatalogArr;
@synthesize dataArr=_dataArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _firstCatalogueArr=[[NSMutableArray alloc]init];
        _dataArr=[[NSMutableArray alloc]init];
        
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        //_searchBar.backgroundImage = [UIImage imageNamed:@"nav_background"];
        _searchBar.backgroundImage=[UIImage imageWithColor:[UIColor colorWithRed:0.847 green:0.024 blue:0.071 alpha:1.000] andSize:CGSizeMake(SCREEN_WIDTH, 44) ];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _searchBar.delegate=self;
        [view setBackgroundColor:[UIColor colorWithRed:0.847 green:0.024 blue:0.071 alpha:1.000]];
        //[view setBackgroundColor:[UIColor clearColor]];
        
        [view addSubview:_searchBar];
        self.navigationItem.titleView=view;
        [view release];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_IOS_6"] forBarMetrics:UIBarMetricsDefault];
        
       
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    }
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }

    //self.navigationItem.leftBarButtonItem = nil;
    _categoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _categoryTable.delegate=self;
    _categoryTable.dataSource=self;
    [self.view addSubview:_categoryTable];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectZero];
    _categoryTable.tableFooterView=headerView;
    [headerView release];
    
    
//    _categoryTable.tableHeaderView=_searchBar;
//    self.searchDisplayController.searchResultsDataSource=self;
//     self.searchDisplayController.searchResultsDelegate=self;
//     self.searchDisplayController.delegate=self;
    

    [NSThread detachNewThreadSelector:@selector(getCategoryFromServer) toTarget:self withObject:nil];
    
}

-(void)dealloc
{
   
    self.searchBar=nil;
    [_categoryTable release];
    self.firstCatalogueArr=nil;
    self.subCatalogArr=nil;
    self.dataArr=nil;
   
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -tableview dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([[[_dataArr objectAtIndex:section]objectForKey:@"expand"]boolValue])
//    {
//        return [[[_dataArr objectAtIndex:section]objectForKey:@"subCatalog"]count];
//    }
//    else
//    {
//        return 0;
//        
//    }
//    return 0;
    
    return [_firstCatalogueArr count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *titleLabel=nil;
    UILabel *resultLabel=nil;
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        titleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 12, 120, 25)]autorelease];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
         resultLabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 37, 100, 25)]autorelease]
        ;
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:resultLabel];
    }
   
    
    
    titleLabel.text=[[_firstCatalogueArr objectAtIndex:indexPath.row]objectForKey:@"content"];
    resultLabel.text=[[_firstCatalogueArr objectAtIndex:indexPath.row]objectForKey:@"description"];
   
    [resultLabel setFont:[UIFont systemFontOfSize:14]];
    [resultLabel setTextColor:[UIColor lightGrayColor]];
        
    

    
//    static NSString *cellIdentifier=@"cell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (nil==cell)
//    {
//        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
//    }
//    cell.indentationLevel=6;
//    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
//    [cell.textLabel setTextColor:[UIColor grayColor]];
//    cell.textLabel.text=[[[[_dataArr objectAtIndex:indexPath.section]objectForKey:@"subCatalog" ]objectAtIndex:indexPath.row]objectForKey:@"content"];
    return cell;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSArray *imageArr=@[@"2-01Search page_icon01",@"2-01Search page_icon02",@"2-01Search page_icon03",@"2-01Search page_icon04",@"2-01Search page_icon05",@"2-01Search page_icon06"];
//    
//    UIView *headerView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 79)]autorelease];
//    UIImageView *headerImageView=[[[UIImageView alloc]initWithFrame:CGRectMake(10, 24, 50, 50)]autorelease];
//    headerImageView.image=[UIImage imageNamed:[imageArr objectAtIndex:section]];
//    UILabel *titleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 24, 120, 25)]autorelease];
//    [titleLabel setFont:[UIFont systemFontOfSize:18]];
//    UILabel *resultLabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 49, 100, 25)]autorelease];
//    UIImageView *downImage=[[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 42, 10, 10)]autorelease];
//    downImage.image=[UIImage imageNamed:@"list_more_normal"];
//    
//    UIView *lineView=[[[UIView alloc]initWithFrame:CGRectMake(0,  5, SCREEN_WIDTH, 1)]autorelease];
//    lineView.backgroundColor=[UIColor colorWithWhite:0.824 alpha:1.000];
//    
//    UIView *lineDownView=[[[UIView alloc]initWithFrame:CGRectMake(0,  79, SCREEN_WIDTH, 1)]autorelease];
//    lineDownView.backgroundColor=[UIColor colorWithWhite:0.824 alpha:1.000];
//    [headerView addSubview:headerImageView];
//    [headerView addSubview:titleLabel];
//    [headerView addSubview:resultLabel];
//    [headerView addSubview:downImage];
//    [headerView addSubview:lineView];
//    [headerView addSubview:lineDownView];
//    headerView.tag=section;
//    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downSelectAction:)];
//    [headerView addGestureRecognizer:tapGesture];
//    
//    titleLabel.text=[[_firstCatalogueArr objectAtIndex:section]objectForKey:@"content"];
//    resultLabel.text=[[_firstCatalogueArr objectAtIndex:section]objectForKey:@"description"];
//    [resultLabel setFont:[UIFont systemFontOfSize:14]];
//    [resultLabel setTextColor:[UIColor lightGrayColor]];
//    if ([[[_dataArr objectAtIndex:section]objectForKey:@"expand"]boolValue])
//        
//    {
//        lineDownView.hidden=NO;
//    }
//    else
//    {
//        lineDownView.hidden=YES;
//    }
//    if (section==[_firstCatalogueArr count]-1)
//    {
//         lineDownView.hidden=NO;
//    }
//   
//    return headerView;
//    
//}
//-(void)downSelectAction:(id)sender
//{
//    UITapGestureRecognizer *recognizer=(UITapGestureRecognizer*)sender;
//    BOOL expand=[[[_dataArr objectAtIndex:recognizer.view.tag]objectForKey:@"expand"]boolValue];
//    
//    if (!expand)
//    {
//        NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
//        NSArray *subArr=[[_dataArr objectAtIndex:recognizer.view.tag]objectForKey:@"subCatalog"];
//        for (int i=0; i<[subArr count]; i++)
//        {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:recognizer.view.tag];
//            [tmpArr addObject:indexPath];
//        }
//        [[_dataArr objectAtIndex:recognizer.view.tag]setObject:[NSNumber numberWithBool:true] forKey:@"expand"];
//        [self.categoryTable insertRowsAtIndexPaths:tmpArr withRowAnimation:NO];
//        
//        [tmpArr release];
//        
//        
//    }
//    else
//    {
//        NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
//        NSArray *subArr=[[_dataArr objectAtIndex:recognizer.view.tag]objectForKey:@"subCatalog"];
//
//        for (int i=0; i<[subArr count]; i++)
//        {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:recognizer.view.tag];
//            [tmpArr addObject:indexPath];
//        }
//        
//        [[_dataArr objectAtIndex:recognizer.view.tag]setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
//        [self.categoryTable deleteRowsAtIndexPaths:tmpArr withRowAnimation:NO];
//        [tmpArr release];
//        
//        
//        
//        
//    }
//    
//    [_categoryTable reloadData];
//    
//    
//}

#pragma mark -tableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    searchResultViewController *searchResultCtrl=[[searchResultViewController alloc]init];
//    [self.navigationController pushViewController:searchResultCtrl animated:YES];
//    
//    searchResultCtrl.parentId=[[[[_dataArr objectAtIndex:indexPath.section]objectForKey:@"subCatalog"]objectAtIndex:indexPath.row]objectForKey:@"parentId"];
//    searchResultCtrl.conId=[[[[_dataArr objectAtIndex:indexPath.section]objectForKey:@"subCatalog"]objectAtIndex:indexPath.row]objectForKey:@"id"];
//    searchResultCtrl.isSearch=NO;
   // [searchResultCtrl release];
    
    SearchMyProduct *secondLevelCtrl=[[SearchMyProduct alloc]initWithNibName:@"SecondLevelDirectory" bundle:nil];
    [self.navigationController pushViewController:secondLevelCtrl animated:NO];
    secondLevelCtrl.dataArr=self.dataArr;
    secondLevelCtrl.selectIndex=indexPath.row;
    secondLevelCtrl.hidesBottomBarWhenPushed=YES;
    [secondLevelCtrl release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -searchBardelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
     _searchBar.showsCancelButton=YES;
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
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton=NO;
    
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

-(void)getCategoryFromServer
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"num"];
       // [params setObject:_searchString forKey:@"keyWord"];
        [RemoteManager Posts:kCATALOG_INFO Parameters:params WithBlock:^(id json, NSError *error)
         {
             if (!error)
             {
                 
                 [self refreshTable:json];
                 
             }
             else
             {
                 NSLog(@"the error is:%@",error);
                 self.categoryTable.hidden=YES;
             }
         }];

     
    }
    
}

-(void)refreshTable:(id)json
{
    NSLog(@"the search result is:%@",json);
    if (json)
    {
        if ([json isKindOfClass:[NSDictionary class]])
        {
            _firstCatalogueArr =[[json objectForKey:@"wareCategoryList"]mutableCopy];
            for (NSDictionary *dic in _firstCatalogueArr)
            {
                NSMutableDictionary *tmpDic=[dic mutableCopy];
                [tmpDic setObject:[NSNumber numberWithBool:0] forKey:@"expand"];
                [_dataArr addObject:tmpDic];
                [tmpDic release];
            }
            
            if (![_firstCatalogueArr count])
            {
                self.categoryTable.hidden=YES;
            }
        }
    }
    [self.categoryTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
    for (NSMutableDictionary *dic in _dataArr)
    {
     [self getSubCatalogFromServer:[dic objectForKey:@"id"]];
    }
    
    

    
}
-(void)getSubCatalogFromServer:(NSString *)parentId
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:[NSNumber numberWithInt:1] forKey:@"num"];
         [params setObject:parentId forKey:@"conDirId"];
        [RemoteManager Posts:kCATALOG_INFO Parameters:params WithBlock:^(id json, NSError *error)
         {
             if (!error)
             {
                 
                 [self expandSubCatalog:json];
                 
             }
             else
             {
                 NSLog(@"the error is:%@",error);
             }
         }];
        
        
    }
    
}
-(void)expandSubCatalog:(id)json
{
    NSLog(@"the search result is:%@",json);
    if (json)
    {
        if ([json isKindOfClass:[NSDictionary class]])
        {
            _subCatalogArr =[[json objectForKey:@"wareCategoryList"]mutableCopy];
            
            for (NSMutableDictionary *dic in _dataArr)
            {
                if ([[dic objectForKey:@"id"]isEqualToString:[[_subCatalogArr objectAtIndex:0]objectForKey:@"parentId"]])
                {
                    [dic setObject:_subCatalogArr forKey:@"subCatalog"];
                }
            }
        }
    }
    [self.categoryTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 79;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}



@end
