//
//  SecondLevelDirectory.m
//  huyihui
//
//  Created by zhangmeifu on 27/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "SecondLevelDirectory.h"
#import "searchResultViewController.h"

@interface SecondLevelDirectory ()

@end

@implementation SecondLevelDirectory

@synthesize dataArr=_dataArr;
@synthesize selectIndex=_selectIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//         self.extendedLayoutIncludesOpaqueBars=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.extendedLayoutIncludesOpaqueBars=YES;
//    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.title=@"搜索";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    _secondLevelTable.backgroundColor=[UIColor colorWithWhite:0.835 alpha:1.000];
    _secondLevelTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    for (NSMutableDictionary *dic in _dataArr)
    {
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
    }
    
    [[_dataArr objectAtIndex:_selectIndex]setObject:[NSNumber numberWithBool:true] forKey:@"expand"];

    
    [_firstLevelTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
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
        return [[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog" ]count];
        
    }
    
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
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
      
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
        cell.textLabel.text=[[[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog" ]objectAtIndex:indexPath.row]objectForKey:@"content"];
        
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
        searchResultCtrl.conId=[[[[_dataArr objectAtIndex:_selectIndex]objectForKey:@"subCatalog"]objectAtIndex:indexPath.row]objectForKey:@"id"];
        searchResultCtrl.isSearch=NO;
        [self.navigationController pushViewController:searchResultCtrl animated:YES];
        [searchResultCtrl release];
        
        
    }
    
}




@end
