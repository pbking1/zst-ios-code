//
//  SelectRequirementViewController.m
//  huyihui
//
//  Created by zhangmeifu on 24/2/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "SelectRequirementViewController.h"
#import "SearchMyProduct.h"
#import "SpecificationSelect.h"

@interface SelectRequirementViewController ()

@end

@implementation SelectRequirementViewController

@synthesize requirementTable=_requirementTable;
@synthesize dataArr=_dataArr;
@synthesize parentId=_parentId;
@synthesize conId=_conId;
@synthesize directorySpecsArr=_directorySpecsArr;
@synthesize productColumnsArr=_productColumnsArr;
@synthesize attributeForIndex=_attributeForIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _dataArr=[[NSMutableArray alloc]init];
        _productColumnsArr=[[NSMutableArray alloc]init];
        _attributeForIndex=[[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"筛选";
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    
    UIButton *finishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.frame=CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    _requirementTable.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];

    
    for (int i=0; i<5; i++)
    {
        NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc]init];
        [tmpDic setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr  addObjectsFromArray:@[@"江西",@"广东",@"湖南",@"湖北",@"山东"]];
        [tmpDic setObject:arr forKey:@"dataSource"];
        [tmpDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        [_dataArr addObject:tmpDic];
        [arr release];
        [tmpDic release];
        
    }
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectZero];
    _requirementTable.tableFooterView=headerView;
    [headerView release];

    
    [NSThread detachNewThreadSelector:@selector(chooseDirectoryFromServer) toTarget:self withObject:nil];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
    self.requirementTable=nil;
    self.parentId=nil;
    self.conId=nil;
    self.directorySpecsArr=nil;
    self.attributeForIndex=nil;
    [super dealloc];
}

-(void)finishAction:(id)sender

{
    if (self.doneSelect)
    {
        NSMutableArray *array=[[NSMutableArray alloc]init];
        __block NSString *specificId=@"";
        [_attributeForIndex enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            if ([key isEqualToString:@"0"])
            {
                if ([dic objectForKey:@"all"]==nil)
                {
                 specificId=[obj objectForKey:@"specificationId"];
                }
                
            }
            else
            {
                if ([dic objectForKey:@"all"]==nil)
                {
                    [dic setObject:[obj objectForKey:@"category"] forKey:@"category"];
                    [dic setObject:[obj objectForKey:@"columnName"] forKey:@"columnName"];
                    [dic setObject:[obj objectForKey:@"phraseId"] forKey:@"phraseId"];
                    [dic setObject:[[obj objectForKey:@"attributes"]objectForKey:@"phraseId"] forKey:@"attributesphraseId"];
                    [array addObject: dic];
                }
                
            }
            
        }];
        
        self.doneSelect(specificId, array);
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -tableview dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+[self.productColumnsArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([[[_dataArr objectAtIndex:section]objectForKey:@"expand"]boolValue])
//    {
//        return 5;
//    }
//    else
//    {
//         return 0;
//        
//    }
    
    return 1;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil==cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
    }
    if (indexPath.section==0)
    {
//        cell.textLabel.text=[[[_dataArr objectAtIndex:indexPath.section]objectForKey:@"dataSource" ]objectAtIndex:indexPath.row];
      //   cell.textLabel.text=@"所有类别";
        
        if ([_attributeForIndex objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]])
        {
            if ([[_attributeForIndex objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]]objectForKey:@"all"])
            {
                cell.textLabel.text=@"所有";
            }
            else
            {
                cell.textLabel.text=[[_attributeForIndex objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]]objectForKey:@"content"];
                
            }
            
        }
        else
        {
            cell.textLabel.text=@"所有";
            
        }
    }
    else
    {
        if ([_attributeForIndex objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]])
        {
            if ([[_attributeForIndex objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]]objectForKey:@"all"])
            {
                 cell.textLabel.text=@"所有";
            }
            else
            {
                cell.textLabel.text=[[[_attributeForIndex objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]]objectForKey:@"attributes" ] objectForKey:@"value"];
            }
        }
        
        else
        {
            cell.textLabel.text=@"所有";
            
        }
        
        
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleString=@"";
//    switch (section) {
//        case 0:
//            titleString=@"选择类目";
//            break;
//        case 1:
//            titleString=@"选择所在地";
//            break;
//        case 2:
//            titleString=@"品牌";
//            break;
//        case 3:
//            titleString=@"优惠";
//            break;
//        case 4:
//            titleString=@"选择价格区间";
//            break;
//            
//        default:
//            break;
//    }
    if (section==0)
    {
        titleString=@"选择类目";
    }
    else
    {
        titleString=[[_productColumnsArr objectAtIndex:section-1]objectForKey:@"display"];
        
    }
    
    return titleString;

    
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *backView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)]autorelease];
//    backView.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
//    
//    UILabel *sectionTitleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 120, 30)]autorelease];
//    [backView addSubview:sectionTitleLabel];
//    sectionTitleLabel.backgroundColor=[UIColor clearColor];
//    UIView *headerView=[[[UIView alloc]initWithFrame:CGRectMake(8, 30, SCREEN_WIDTH-16, 40)]autorelease];
//    headerView.backgroundColor=[UIColor whiteColor];
//    UILabel *titleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 30)]autorelease];
//    UILabel *resultLabel=[[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140, 5, 100, 30)]autorelease];
//    UIImageView *downImage=[[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 15, 20, 10)]autorelease];
//    [downImage setContentMode:UIViewContentModeCenter];
//    downImage.image=[UIImage imageNamed:@"list_pull down_normal"];
//    [headerView addSubview:titleLabel];
//    [headerView addSubview:resultLabel];
//    [headerView addSubview:downImage];
//    headerView.tag=section;
//    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downSelectAction:)];
//    [headerView addGestureRecognizer:tapGesture];
//    
//    switch (section) {
//        case 0:
//            sectionTitleLabel.text=@"选择所在地";
//            titleLabel.text=@"所有区域";
//            break;
//        case 1:
//            sectionTitleLabel.text=@"选择类目";
//            titleLabel.text=@"所有类目";
//            break;
//        case 2:
//            sectionTitleLabel.text=@"品牌";
//            titleLabel.text=@"所有品牌";
//            break;
//        case 3:
//            sectionTitleLabel.text=@"优惠";
//            titleLabel.text=@"无";
//            break;
//        case 4:
//            sectionTitleLabel.text=@"选择价格区间";
//            titleLabel.text=@"100~200";
//            break;
//            
//        default:
//            break;
//    }
//    resultLabel.text=[[_dataArr objectAtIndex:section]objectForKey:@"selectResult"];
//    [backView addSubview:headerView];
//    
//    return backView;
//
//}
-(void)downSelectAction:(id)sender
{
    
    
//    UITapGestureRecognizer *recognizer=(UITapGestureRecognizer*)sender;
//    BOOL expand=[[[_dataArr objectAtIndex:recognizer.view.tag]objectForKey:@"expand"]boolValue];
//    
//    if (!expand)
//    {
//        NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
//        for (int i=0; i<5; i++)
//        {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:recognizer.view.tag];
//            [tmpArr addObject:indexPath];
//        }
//        [[_dataArr objectAtIndex:recognizer.view.tag]setObject:[NSNumber numberWithBool:true] forKey:@"expand"];
//        [self.requirementTable insertRowsAtIndexPaths:tmpArr withRowAnimation:UITableViewRowAnimationBottom];
//        
//        [tmpArr release];
//        
//        
//    }
//    else
//    {
//        NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
//        for (int i=0; i<5; i++)
//        {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:recognizer.view.tag];
//            [tmpArr addObject:indexPath];
//        }
//        
//        [[_dataArr objectAtIndex:recognizer.view.tag]setObject:[NSNumber numberWithBool:false] forKey:@"expand"];
//        [self.requirementTable deleteRowsAtIndexPaths:tmpArr withRowAnimation:UITableViewRowAnimationTop];
//        [tmpArr release];
//
//        
//       
//        
//    }
//    
//    [_requirementTable reloadData];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *tmpString=[[[_dataArr objectAtIndex:indexPath.section]objectForKey:@"dataSource" ]objectAtIndex:indexPath.row];
//    [[_dataArr objectAtIndex:indexPath.section]setObject:tmpString forKey:@"selectResult"];
//    [_requirementTable reloadData];
    if (indexPath.section==0)
    {
        SpecificationSelect *specificationCtrl=[[SpecificationSelect alloc]initWithNibName:@"SpecificationSelect" bundle:nil];
        specificationCtrl.directorySpecsArr=self.directorySpecsArr;
        specificationCtrl.isSelectType=YES;
        [self.navigationController pushViewController:specificationCtrl animated:YES];
        
        specificationCtrl.selectDone=^(NSDictionary *dic){
            [_attributeForIndex removeAllObjects];
            
             [_attributeForIndex setObject:dic forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
            [NSThread detachNewThreadSelector:@selector(updateColumnsFromServer:) toTarget:self withObject:dic];
            
        };
        [specificationCtrl release];
    }
    else
    {
        SpecificationSelect *specificationCtrl=[[SpecificationSelect alloc]initWithNibName:@"SpecificationSelect" bundle:nil];
        specificationCtrl.productColumnsDic=[self.productColumnsArr objectAtIndex:indexPath.section-1];
        specificationCtrl.isSelectType=NO;
       
        
        specificationCtrl.selectDone=^(NSMutableDictionary *dic){
            
//            [NSThread detachNewThreadSelector:@selector(updateColumnsFromServer:) toTarget:self withObject:dic];
            [_attributeForIndex setObject:dic forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
            
            [self.requirementTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
        };
        
        [self.navigationController pushViewController:specificationCtrl animated:YES];
        [specificationCtrl release];
        
    }
    
}


-(void)chooseDirectoryFromServer
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        if (_parentId)
        {
            [params setObject:self.parentId forKey:@"parentId"];
        }
        if (_conId)
        {
            [params setObject:self.conId forKey:@"conId"];
        }
        
        [RemoteManager Posts:kCHOOSE_COLUMNINFO Parameters:params WithBlock:^(id json, NSError *error) {
            if (error==nil)
            {
                if ([[json objectForKey:@"state"] intValue]==1)
                {
                    NSLog(@"%@",json);
                    self.directorySpecsArr=[[json objectForKey:@"directorySpecs"]mutableCopy];
                }
            }
        }];
        [params release];
    }
    
}

-(void)updateColumnsFromServer:(NSDictionary *)dic
{
    
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:self.parentId forKey:@"parentId"];
        [params setObject:self.conId forKey:@"conId"];
        if ([dic objectForKey:@"specificationId"])
        {
            [params setObject:[dic objectForKey:@"specificationId"] forKey:@"specificationId"];
        }
        
        
        [RemoteManager Posts:kCHOOSE_COLUMNINFO Parameters:params WithBlock:^(id json, NSError *error) {
            if (error==nil)
            {
                if ([[json objectForKey:@"state"] intValue]==1)
                {
                    NSLog(@"%@",json);
                    if ([json objectForKey:@"productColumns"]&&![[json objectForKey:@"productColumns"]isEqual:[NSNull null]])
                    {
                        self.productColumnsArr=[[json objectForKey:@"productColumns"]mutableCopy];
                    }
                    
                    [self.requirementTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }
            }
        }];
        [params release];
    }

    
}
@end
