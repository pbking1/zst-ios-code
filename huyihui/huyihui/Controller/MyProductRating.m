//
//  MyProductRating.m
//  huyihui
//
//  Created by zhangmeifu on 14/4/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "MyProductRating.h"


@interface MyProductRating ()

@end

@implementation MyProductRating

@synthesize discussListArr=_discussListArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.discussListArr=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.noRatingLabel.hidden=YES;
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectZero];
    _ratingTable.tableFooterView=headerView;
    [headerView release];
    [NSThread detachNewThreadSelector:@selector(getDiscussFromServer) toTarget:self withObject:nil];
}
- (void)dealloc {
    [_ratingTable release];
    self.discussListArr=nil;
    [_noRatingLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return [_ratingArr count];
    return [self.discussListArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        NSString *text=@"";
        if ([self.discussListArr count]>0)
        {
            if ([[self.discussListArr objectAtIndex:indexPath.section] objectForKey:@"content"]&&![[[self.discussListArr objectAtIndex:indexPath.section] objectForKey:@"content"]isEqual:[NSNull null]])
            {
                text=[[self.discussListArr objectAtIndex:indexPath.section] objectForKey:@"content"];
                
                if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
                {
                    CGSize mySize=[text sizeWithFont:[UIFont systemFontOfSize:15] forWidth:SCREEN_WIDTH lineBreakMode:NSLineBreakByWordWrapping];
                     return (45+mySize.height);
                }
                else
                {
//                    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc]initWithString:text];
                    NSDictionary *dic=@{NSFontAttributeName: [UIFont systemFontOfSize:13]};
                    CGRect rect=[text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
                     return (45+rect.size.height);
                }
                
               
               
                
            }
        }
        

        return 45;
    
    }
    else
    {
        return 87;
        
    }
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *productIdentifier=@"productCell";
    static NSString *ratingIdentifier=@"ratingCell";
    UITableViewCell *cell=nil;
    if (indexPath.row==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:ratingIdentifier];
        if (cell==nil)
        {
            
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ratingIdentifier]autorelease];
            
            UIView *view=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 11)]autorelease];
            view.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
            [cell.contentView addSubview:view];
            
            UIImageView *imageView=[[[UIImageView alloc]init]autorelease];
            imageView.tag=1;
            imageView.userInteractionEnabled=NO;
            
            UIImage *image=[UIImage imageNamed:@"2-04Public Const LangProducts-rate"];
            imageView.backgroundColor=[UIColor colorWithPatternImage:image];
            
            [imageView setFrame:CGRectMake(10, 20, 58, 14)];
            [cell.contentView addSubview:imageView];
            
            UILabel *ratingTextLabel=[[[UILabel alloc]init]autorelease];
            ratingTextLabel.tag=2;
            ratingTextLabel.numberOfLines=0;
            [ratingTextLabel setFont:[UIFont systemFontOfSize:14]];
            ratingTextLabel.textColor=[UIColor grayColor];
            [cell.contentView addSubview:ratingTextLabel];
        
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        
        UIImageView *imageView=(UIImageView*)[cell viewWithTag:1];
        UILabel *ratingTextLabel=(UILabel *)[cell viewWithTag:2];
        if (![[[self.discussListArr objectAtIndex:indexPath.section]objectForKey:@"score"]isEqual:[NSNull null]])
        {
            int score=[[[self.discussListArr objectAtIndex:indexPath.section]objectForKey:@"score"]intValue];
            [imageView setFrame:CGRectMake(10, 20, 14.5*score, 14)];
        }
        
        if ([[self.discussListArr objectAtIndex:indexPath.section] objectForKey:@"content"]&&![[[self.discussListArr objectAtIndex:indexPath.section] objectForKey:@"content"]isEqual:[NSNull null]])
        {
            ratingTextLabel.text=[NSString stringWithFormat:@"%@",[[self.discussListArr objectAtIndex:indexPath.section] objectForKey:@"content"]];
        }
        
        CGSize size=[ratingTextLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-10, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        [ratingTextLabel setFrame:CGRectMake(10, 40, SCREEN_WIDTH-10, size.height)];
       
        
        
        
        
        
    }
    else
    {
        [tableView registerNib:[UINib nibWithNibName:@"MyRatingCell" bundle:nil] forCellReuseIdentifier:productIdentifier];
        cell=[tableView dequeueReusableCellWithIdentifier:productIdentifier];
        
        //TODO:set data
        UIImageView *picture = (UIImageView *)[cell viewWithTag:1];
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
        UILabel *itemIdLabel = (UILabel *)[cell viewWithTag:3];
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:4];
       
        NSDictionary *dataDic=[self.discussListArr objectAtIndex:indexPath.section];
        
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER, [self.discussListArr[indexPath.section] objectForKey:@"mediaPath"]]];
        
        [picture setBackgroundColor:[UIColor grayColor]];
      
        [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
            if(image){
                [picture setImage:image];
                [picture setBackgroundColor:[UIColor clearColor]];
                
            }
        } errorBlock:nil];
        
        nameLabel.text=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"prodName"]];
        itemIdLabel.text=[NSString stringWithFormat:@"产品编号：%@",[dataDic objectForKey:@"itemId"]];
        timeLabel.text=[NSString stringWithFormat:@"下单时间：%@",[dataDic objectForKey:@"orderTime"]];
        
    }
    
    return cell;
    
}

-(void)getDiscussFromServer
{
    @autoreleasepool {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:[NUSD objectForKey:kCurrentUserId ] forKey:@"userKo"];
        [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
        [params setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
        [params setObject:@5 forKey:@"num"];
        [params setObject:@1 forKey:@"pageIndex"];
        
        [RemoteManager Posts:kGET_MYDISCUSSINFO Parameters:params WithBlock:^(id json, NSError *error) {
            if (error==nil)
            {
                NSLog(@"%@",json);
                if ([[json objectForKey:@"state"]intValue]==1)
                {
                    [self.discussListArr addObjectsFromArray:[json objectForKey:@"discussList"]];
                    
                }
            }
            else
            {
                
            }
            if ([self .discussListArr count]>0)
            {
                self.noRatingLabel.hidden=YES;
            }
            else
            {
                self.noRatingLabel.hidden=NO;
            }
            
            [self.ratingTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

        }];
        
        [params release];
        
        
    }
    
}



@end
