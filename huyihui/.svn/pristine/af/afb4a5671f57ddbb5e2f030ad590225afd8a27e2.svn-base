//
//  SecondLevelDirectory.m
//  huyihui
//
//  Created by zhangmeifu on 27/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "SearchMyProduct.h"
#import "searchResultViewController.h"
#import "UIImage+imageWithColor.h"

@interface SearchMyProduct ()

@end

@implementation SearchMyProduct

@synthesize dataArr=_dataArr;
@synthesize selectIndex=_selectIndex;
@synthesize firstCatalogueArr=_firstCatalogueArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _selectIndex=0;
        _firstCatalogueArr=[[NSMutableArray alloc]init];
        _dataArr=[[NSMutableArray alloc]init];
//         self.extendedLayoutIncludesOpaqueBars=NO;
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 40)];
        _searchBar.placeholder = @"搜索商品名                                 ";

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
//    self.extendedLayoutIncludesOpaqueBars=YES;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_IOS_6"] forBarMetrics:UIBarMetricsDefault];
        
        
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    }
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    

    
    self.title=@"搜索";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    _secondLevelTable.backgroundColor=[UIColor colorWithWhite:0.835 alpha:1.000];
//    _secondLevelTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    
//    for (NSMutableDictionary *dic in _dataArr)
//    {
//        [dic setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
//    }
    
//    [[_dataArr objectAtIndex:_selectIndex]setObject:[NSNumber numberWithBool:true] forKey:@"expand"];
//
//    
//    [_firstLevelTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    [NSThread detachNewThreadSelector:@selector(getCategoryFromServer) toTarget:self withObject:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    self.dataArr=nil;
    [_firstLevelTable release];
    [_secondLevelTable release];
    [super dealloc];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    for (NSMutableDictionary *dic in _dataArr)
//    {
//        [dic setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
//    }
//}
#pragma  mark tableView dataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_firstLevelTable)
    {
        return [_dataArr count];
    }
    else
    {
        if ([_dataArr count]>0)
        {
            return [[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog" ]count];

        }
        
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (tableView==_firstLevelTable)
    {
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        }
//        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        if ([_dataArr count]>0)
        {
            cell.textLabel.text=[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"content"];
            
            if ([[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"expand"]boolValue])
            {
                [cell.textLabel setTextColor:[UIColor redColor]];
                [cell setBackgroundColor:[UIColor colorWithWhite:0.835 alpha:1.000]];
            }
            else
            {
                [cell.textLabel setTextColor:[Util rgbColor:"3d4245"]];
                [cell setBackgroundColor:[UIColor whiteColor]];
                
            }

        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.indentationLevel=2;


    }
    else
    {
        if (nil==cell)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        }
        cell.backgroundColor=[UIColor colorWithWhite:0.835 alpha:1.000];
        cell.indentationLevel=1;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[Util rgbColor:"3d4245"]];
        if ([_dataArr count]>0)
        {
            cell.textLabel.text=[[[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog" ]objectAtIndex:indexPath.row]objectForKey:@"content"];
        }
        
        
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_firstLevelTable)
    {
        
//        BOOL expand=[[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"expand"]boolValue];
//        
//        if (!expand)
//        {
            for (NSMutableDictionary *dic in _dataArr)
            {
                [dic setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
            }
            
            _selectIndex=indexPath.row;
          
            [[_dataArr objectAtIndex:indexPath.row]setObject:[NSNumber numberWithBool:true] forKey:@"expand"];
            
           
            
         
            
            
      //  }
//        else
//        {
//           
//
//            _selectIndex=indexPath.row;
//            
//            
//            [[_dataArr objectAtIndex:indexPath.row]setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
//           
//           
//            
//            
//            
//        }
        
    
        [_firstLevelTable reloadData];
        [_secondLevelTable reloadData];
    }
    else
    {
        searchResultViewController *searchResultCtrl=[[searchResultViewController alloc]init];
        searchResultCtrl.parentId=[[[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog"]objectAtIndex:indexPath.row]objectForKey:@"parentId"];
        searchResultCtrl.hidesBottomBarWhenPushed=YES;
        searchResultCtrl.conId=[[[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog"]objectAtIndex:indexPath.row]objectForKey:@"id"];
        searchResultCtrl.isSearch=NO;
        [self.navigationController pushViewController:searchResultCtrl animated:YES];
        [searchResultCtrl release];
        
        
    }
    
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
                // self.categoryTable.hidden=YES;
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
               // self.categoryTable.hidden=YES;
            }
        }
    }
    [[_dataArr objectAtIndex:_selectIndex]setObject:[NSNumber numberWithBool:true] forKey:@"expand"];
    [self.firstLevelTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
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
    
    [self.secondLevelTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    
    
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







@end
