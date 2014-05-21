//
//  CommentViewController.m
//  huyihui
//
//  Created by zaczh on 14-4-16.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
@property (copy, nonatomic) NSDictionary *orderInfo;
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithOrder:(NSDictionary *)order;
{
    self = [super init];
    if(self){
        _orderInfo = [order copy];
    }
    
    return self;
}

static NSString *CommentBodyCell = @"OrderDetailCellItem";
static NSString *CommentBottomCell = @"CommentBottomCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品评价";
    
    ButtonFactory *buttonFactory = [ButtonFactory factory];
    UIButton *rightBtn = [buttonFactory createButtonWithType:HuEasyButtonTypeRefresh];
    [rightBtn addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem release];
    
    [self.table registerNib:[UINib nibWithNibName:CommentBodyCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CommentBodyCell];
    [self.table registerNib:[UINib nibWithNibName:CommentBottomCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CommentBottomCell];
    
    self.table.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderInfo[@"wareList"] count] * 2 + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 50.0f;
    }else if (indexPath.row %2 == 0){
        return 95.0f;
    }else{
        return 90.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.row ==0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
        if (cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"]autorelease];
            
            
            UILabel *orderNumberLabel=[[[UILabel alloc]initWithFrame:CGRectMake(12, 4, 260, 25)]autorelease];
            orderNumberLabel.backgroundColor = [UIColor clearColor];
            orderNumberLabel.textColor = [UIColor colorWithRed:68/255.0 green:73/255.0 blue:78/255.0 alpha:1.0];
            orderNumberLabel.tag=1;
            UILabel *transActionLabel=[[[UILabel alloc]initWithFrame:CGRectMake(12, 25, 200, 25)]autorelease];
            transActionLabel.backgroundColor = [UIColor clearColor];
            transActionLabel.tag=2;
            [orderNumberLabel setFont:[UIFont systemFontOfSize:13]];
            [transActionLabel setFont:[UIFont systemFontOfSize:12]];
            [transActionLabel setTextColor:[Util rgbColor:"b7b7b7"]];
            [cell.contentView addSubview:orderNumberLabel];
            [cell.contentView addSubview:transActionLabel];
            
        }
        ((UILabel*)[cell.contentView viewWithTag:1]).text=[NSString stringWithFormat:@"%@%@",@"订单编号：",self.orderInfo[@"orderId"]];
        ((UILabel*)[cell.contentView viewWithTag:2]).text=[NSString stringWithFormat:@"%@%@",@"成交时间：",self.orderInfo[@"orderTime"]];
    }else if (indexPath.row %2 == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:CommentBottomCell forIndexPath:indexPath];
        
        NSArray *buttons = [[cell.contentView.subviews objectAtIndex:4] subviews];
        
        [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[UIButton class]])
                [obj addTarget:self action:@selector(onTouchStar:) forControlEvents:UIControlEventTouchUpInside];
        }];
        
        NSDictionary *cellData = self.orderInfo;

        ((UILabel *)[cell.contentView.subviews objectAtIndex:2]).text=[NSString stringWithFormat:@"%@%.2f",@"￥：",[cellData[@"payment"] floatValue]];
        ((UILabel *)[cell.contentView.subviews objectAtIndex:3]).text=[NSString stringWithFormat:@"（含邮费：%@元）",cellData[@"deliveryPay"]];
        ((UITextField *)[cell.contentView.subviews objectAtIndex:0]).tag = indexPath.row;
        ((UITextField *)[cell.contentView.subviews objectAtIndex:0]).delegate = self;
        ((UITextField *)[cell.contentView.subviews objectAtIndex:0]).returnKeyType = UIReturnKeyDone;
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CommentBodyCell forIndexPath:indexPath];
        
        NSDictionary *cellData = self.orderInfo[@"wareList"][(indexPath.row - 1)/2];
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        [Util UIImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,cellData[@"mediaPath"]]] withImageBlock:^(UIImage *image) {
            imageView.image = image;
        } errorBlock:^{
            NSLog(@"载入图片失败");
        }];
        
        UILabel *description = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *attribute = (UILabel *)[cell.contentView viewWithTag:5];
        UILabel *price = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *quantity = (UILabel *)[cell.contentView viewWithTag:4];
        
        description.text = [NSString stringWithFormat:@"%@", cellData[@"prodName"]];
        attribute.text = [NSString stringWithFormat:@"%@", cellData[@"description"]];
        price.text = [NSString stringWithFormat:@"￥%@", cellData[@"salePrice"]];
        quantity.text = [NSString stringWithFormat:@"x%@", cellData[@"quantity"]];
    }
    
    return cell;
}
- (void)dealloc {
    [_table release];
    [super dealloc];
}

- (void)onTouchStar:(UIButton *)sender
{
    for(int i=1; i<sender.tag + 1; i++){
        UIButton *btn = (UIButton *)[sender.superview.subviews objectAtIndex:i-1];
        if([btn isKindOfClass:[UIButton class]]){
            [btn setImage:[UIImage imageNamed:@"4-07evaluation_Rating_push"] forState:UIControlStateNormal];
        }
    }
    
    ((UILabel *)[sender.superview.subviews objectAtIndex:5]).text = [NSString stringWithFormat:@"%d",sender.tag];
    
    if(sender.tag < 5){
        for(int i=sender.tag+1; i<6; i++){
            UIButton *btn = (UIButton *)[sender.superview.subviews objectAtIndex:i-1];
            if([btn isKindOfClass:[UIButton class]]){
                [btn setImage:[UIImage imageNamed:@"4-07evaluation_Rating_normal"] forState:UIControlStateNormal];
            }
        }
    }

}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)onRefresh:(UIButton *)sender
{
    
}

- (void)requestAddComment:(NSString *)content
                    score:(NSInteger)score
            transactionId:(NSString *)transactionId
               forProduct:(NSDictionary *)product
                   sucess: (void(^)())successBlock
                  failure:(void(^)())failureBlock{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:[NUSD objectForKey:kCurrentUserName] forKey:@"subscriberName"];
    
    [param setObject:product[@"specificationId"] forKey:@"specificationId"];
    [param setObject:product[@"speciesId"] forKey:@"speciesId"];
    [param setObject:product[@"sku"] forKey:@"sku"];
    [param setObject:transactionId forKey:@"itemId"];
    [param setObject:content forKey:@"content"];
    [param setObject:[NSNumber numberWithInteger:score] forKey:@"score"];
    
    [RemoteManager Posts:kSAVE_DISCUSS_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                NSLog(@"商品评价成功");
                if(successBlock != nil){
                    successBlock();
                }
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                if(failureBlock != nil){
                    failureBlock();
                }
            }
        }else{
            NSLog(@"network error :%@",error);
            if(failureBlock != nil){
                failureBlock();
            }
        }
    }];
    
    
    
//    discussList =     (
//                       {
//                           action = "<null>";
//                           chk = "<null>";
//                           content = "<null>";
//                           createtime = "<null>";
//                           createtimeDate = "<null>";
//                           export = 0;
//                           exportSize = 10000;
//                           id = "<null>";
//                           itemId = 14050619501117400001;
//                           mediaPath = "/SRMC/Merchant/13080815193235900001/Ware/S5F13228/Unit/20140219/unit_1545317345679_middle.jpg";
//                           orderTime = "2014-05-06 19:50:11";
//                           orderTimeDate = 1399377011000;
//                           pageIndex = 1;
//                           pageSize = 15;
//                           prodName = gdfgfd;
//                           score = "<null>";
//                           skipSize = 0;
//                           sku = gdfgfd0001;
//                           speciesId = W60D87B5;
//                           specificationId = S5F13228;
//                           subscriberName = "<null>";
//                           userKo = "<null>";
//                       },

    
    [param release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSInteger row = textField.tag;
    
    NSInteger score = [[[textField.superview.subviews[4] subviews][5] text] integerValue];
    NSString *transactionId = self.orderInfo[@"transactionId"];
    NSDictionary *product = self.orderInfo[@"wareList"][(row - 1)/2];
    
    [self requestAddComment:textField.text score:score transactionId:transactionId forProduct:product sucess:^{
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0f type:0 text:@"评价已提交" duration:1.0];
    } failure:^{
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0f type:0 text:@"评价失败" duration:1.0];
    }];
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(!self.isFirstResponder){
        [self becomeFirstResponder];
    }
}
@end
