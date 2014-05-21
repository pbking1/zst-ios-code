//
//  LogisticsViewController.m
//  huyihui
//
//  Created by zaczh on 14-4-21.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "LogisticsViewController.h"

@interface LogisticsViewController ()
@property (copy, nonatomic) NSDictionary *orderInfo;
@end

@implementation LogisticsViewController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1.0];
    self.title = @"查看物流";
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView new] autorelease];
    [table registerNib:[UINib nibWithNibName:@"OrderDetailCellItem" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:table];
    [table release];
}

- (id)initWithOrder:(NSDictionary *)orderInfo{
    self = [super init];
    if(self){
        self.orderInfo = orderInfo;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 65.0f;
    }else if(indexPath.row == 1){
        return 90.0f;
    }else{
        //TODO:根据物流情况计算cell高度
        return 200.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderInfo[@"wareList"] count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if(indexPath.row == 0){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        
        UILabel *orderInfo = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, SCREEN_WIDTH - 20, 15)];
        orderInfo.backgroundColor = [UIColor clearColor];
        orderInfo.textColor = [UIColor lightGrayColor];
        orderInfo.font = [UIFont systemFontOfSize:13];
        orderInfo.text = [NSString stringWithFormat:@"订单编号：%@", self.orderInfo[@"orderId"]];
        [cell.contentView addSubview:orderInfo];
        [orderInfo release];
        
        UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(12, 24, SCREEN_WIDTH - 20, 15)];
        orderTime.backgroundColor = [UIColor clearColor];
        orderTime.font = [UIFont systemFontOfSize:13];
        orderTime.textColor = [UIColor lightGrayColor];
        orderTime.text = [NSString stringWithFormat:@"成交时间：%@", self.orderInfo[@"orderTime"]];
        [cell.contentView addSubview:orderTime];
        [orderTime release];
        
        UILabel *grossLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 42, 240, 15)];
        grossLabel.backgroundColor = [UIColor clearColor];
        grossLabel.font = [UIFont systemFontOfSize:13];
        grossLabel.textColor = [UIColor lightGrayColor];
        grossLabel.text = [NSString stringWithFormat:@"总价：¥%@（含邮费：%@元）",self.orderInfo[@"payment"],self.orderInfo[@"deliveryPay"]];
        [cell.contentView addSubview:grossLabel];
        [grossLabel release];
    }else if (indexPath.row < [tableView numberOfRowsInSection:0] - 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        UIImageView *itemImage = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *itemTitle = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *itemPrice = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *itemQuantity = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *itemAttribute = (UILabel *)[cell.contentView viewWithTag:5];
        
        [Util UIImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,self.orderInfo[@"wareList"][indexPath.row - 1][@"mediaPath"]]] withImageBlock:^(UIImage *image) {
            itemImage.image = image;
        } errorBlock:^{
            NSLog(@"载入图片失败");
        }];
        
        itemTitle.text = [NSString stringWithFormat:@"%@", self.orderInfo[@"wareList"][indexPath.row - 1][@"prodName"]];
        itemPrice.text = [NSString stringWithFormat:@"￥%@", self.orderInfo[@"wareList"][indexPath.row - 1][@"salePrice"]];
        itemQuantity.text = [NSString stringWithFormat:@"x%@", self.orderInfo[@"wareList"][indexPath.row - 1][@"quantity"]];
        itemAttribute.text = [NSString stringWithFormat:@"%@", self.orderInfo[@"wareList"][indexPath.row - 1][@"description"]];
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel *logisticCompay = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 240, 16)];
        logisticCompay.backgroundColor = [UIColor clearColor];
        logisticCompay.font = [UIFont systemFontOfSize:13];
        logisticCompay.text = @"物流公司：圆通快递";
        logisticCompay.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
        [cell.contentView addSubview:logisticCompay];
        [logisticCompay release];
        
        UILabel *orderInfo = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 240, 16)];
        orderInfo.backgroundColor = [UIColor clearColor];
        orderInfo.font = [UIFont systemFontOfSize:13];
        orderInfo.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
        orderInfo.text = [NSString stringWithFormat:@"快递单号: %@", self.orderInfo[@"orderId"]];
        [cell.contentView addSubview:orderInfo];
        [orderInfo release];
        
        UILabel *logisticInfo0 = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, 296, 16)];
        logisticInfo0.backgroundColor = [UIColor clearColor];
        logisticInfo0.font = [UIFont systemFontOfSize:13];
        logisticInfo0.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
        logisticInfo0.text = [NSString stringWithFormat:@"2014-09-12 14:12 订单被发送至圆通速递"];
        [cell.contentView addSubview:logisticInfo0];
        [logisticInfo0 release];
        
        UILabel *logisticInfo1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 70, 296, 16)];
        logisticInfo1.backgroundColor = [UIColor clearColor];
        logisticInfo1.font = [UIFont systemFontOfSize:13];
        logisticInfo1.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
        logisticInfo1.text = [NSString stringWithFormat:@"2014-09-12 16:12 订单被快递公司接收"];
        [cell.contentView addSubview:logisticInfo1];
        [logisticInfo1 release];
        
        UILabel *logisticInfo2 = [[UILabel alloc] initWithFrame:CGRectMake(12, 90, 296, 16)];
        logisticInfo2.backgroundColor = [UIColor clearColor];
        logisticInfo2.font = [UIFont systemFontOfSize:13];
        logisticInfo2.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
        logisticInfo2.text = [NSString stringWithFormat:@"2014-09-13 05:12 订单被发往广州分拣中心"];
        [cell.contentView addSubview:logisticInfo2];
        [logisticInfo2 release];
        
        UILabel *logisticInfo3 = [[UILabel alloc] initWithFrame:CGRectMake(12, 110, 296, 16)];
        logisticInfo3.backgroundColor = [UIColor clearColor];
        logisticInfo3.font = [UIFont systemFontOfSize:13];
        logisticInfo3.textColor = [UIColor colorWithWhite:155/255.0 alpha:1.0];
        logisticInfo3.text = [NSString stringWithFormat:@"2014-09-13 09:12 已安排人员配送"];
        [cell.contentView addSubview:logisticInfo3];
        [logisticInfo3 release];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
