//
//  SpecificationSelect.m
//  huyihui
//
//  Created by zhangmeifu on 16/4/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "SpecificationSelect.h"

@interface SpecificationSelect ()

@end

@implementation SpecificationSelect
@synthesize directorySpecsArr=_directorySpecsArr;
@synthesize productColumnsDic=_productColumnsDic;
@synthesize isSelectType=_isSelectType;

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
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectZero];
    _specificationSelectTable.tableFooterView=headerView;
    [headerView release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_specificationSelectTable release];
    [super dealloc];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSelectType)
    {
        return [self.directorySpecsArr count]+1;
    }
    else
    {
        return [[self.productColumnsDic objectForKey:@"attributes"]count]+1;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    if (_isSelectType)
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"所有";

        }
        else
        {
             cell.textLabel.text=[[self.directorySpecsArr objectAtIndex:indexPath.row-1]objectForKey:@"content"];
            
        }
       
    }
    else
    {
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"所有";

        }
        else
        {
            cell.textLabel.text=[[[self.productColumnsDic objectForKey:@"attributes"]objectAtIndex:indexPath.row-1]objectForKey:@"value"];
            
        }
        
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.selectDone)
    {
        if (_isSelectType)
        {
            if (indexPath.row==0)
            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                [dic setObject:[NSNumber numberWithBool:true] forKey:@"all"];
                self.selectDone(dic);
                [dic release];
            }
            else
            {
                 self.selectDone([self.directorySpecsArr objectAtIndex:indexPath.row-1]);
                
            }
           
        }
        else
        {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            if (indexPath.row==0)
            {
                [dic setObject:[NSNumber numberWithBool:true] forKey:@"all"];
            }
            else
            {
                [dic setObject:[self.productColumnsDic objectForKey:@"category"] forKey:@"category"];
                [dic setObject:[self.productColumnsDic objectForKey:@"columnName"] forKey:@"columnName"];
                [dic setObject:[self.productColumnsDic objectForKey:@"phraseId"] forKey:@"phraseId"];
                [dic setObject:[[self.productColumnsDic objectForKey:@"attributes"]objectAtIndex:indexPath.row-1] forKey:@"attributes"];
                
            }
           
            self.selectDone(dic);
            [dic release];
            
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
