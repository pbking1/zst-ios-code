//
//  OrderListController.m
//  huyihui
//
//  Created by zhangmeifu on 11/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "OrderListController.h"
#import "OrderDetailViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface OrderListController ()
{
    //    NSArray *cellsArr;
    NSInteger orderStatus;
    NSArray *dataSource;

    NSArray *completedOrdersCommented;//已完成已评价订单
    NSArray *completedOrdersUncommented;//已完成未评价订单
    
}
@end

@implementation OrderListController
@synthesize orderStatus;

static const CGFloat tableHeaderHeight = 32.0f;
static const NSInteger rowLabelTag = 1001;
static const NSInteger sectonLabelTag = 1002;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        cellsArr=[[[NSBundle mainBundle]loadNibNamed:@"OrderCellView" owner:self options:nil]retain];
       
    }
    return self;
}

- (id)initWithOrderStatus:(NSInteger)status{
    self = [super init];
    if(self){
        orderStatus = status;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *orderStatusDict = @{@1:@"待付款", @2:@"待发货", @4:@"待收货", @5:@"已完成"};
    self.title = [orderStatusDict[[NSNumber numberWithInteger:orderStatus]] stringByAppendingString:@"订单"];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        _orderListTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStyleGrouped];
    }else{
        _orderListTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    }
    [_orderListTable setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000]];
    _orderListTable.tableHeaderView=nil;
    _orderListTable.delegate=self;
    _orderListTable.dataSource=self;
    
    UITableViewController *tableController = [[UITableViewController alloc] init];
    tableController.tableView = _orderListTable;
    tableController.refreshControl = [[[UIRefreshControl alloc] init] autorelease];
    [self addChildViewController:tableController];
    [self.view addSubview:tableController.tableView];
    
    _orderListTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_orderListTable attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_orderListTable attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_orderListTable attribute:NSLayoutAttributeTop multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_orderListTable attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0]
                               ]];
                               
    
    [tableController release];

    [_orderListTable registerNib:[UINib nibWithNibName:@"OrderCellView" bundle:nil]forCellReuseIdentifier:@"orderListCell"];
    
//    [self.view addSubview:_orderListTable];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_orderListTable release];
    [super dealloc];
}

#pragma mark - tableView dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.orderStatus == 5){//已完成订单
        return 2;
    }else{
        return dataSource.count == 0?1:dataSource.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.orderStatus != 5){
        if(dataSource.count != 0){
            return nil;
        }
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableHeaderHeight)];
        backView.backgroundColor = [UIColor colorWithRed:253/255.0f green:251/255.0f blue:236/255.0f alpha:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, (tableHeaderHeight - 16)/2, 300, 16)];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:202/255.0f green:144/255.0f blue:94/255.0f alpha:1.0];
        label.text = @"您无此类相关订单";
        [backView addSubview:label];
        [label release];
        return [backView autorelease];
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableHeaderHeight)];
    if(section == 0){
        backView.backgroundColor = [UIColor colorWithRed:253/255.0f green:251/255.0f blue:236/255.0f alpha:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, (tableHeaderHeight - 16)/2, 300, 16)];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:202/255.0f green:144/255.0f blue:94/255.0f alpha:1.0];
        label.text = @"您还有以下订单没有进行评价";
        [backView addSubview:label];
        [label release];
    }else{
        backView.backgroundColor = [UIColor colorWithRed:253/255.0f green:251/255.0f blue:236/255.0f alpha:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, (tableHeaderHeight - 16)/2, 300, 16)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:202/255.0f green:144/255.0f blue:94/255.0f alpha:1.0];
        label.text = @"历史评价";
        [backView addSubview:label];
        [label release];
    }
    return [backView autorelease];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.orderStatus == 5){//已完成订单
        if(section == 0){
            NSInteger __block count = 0;
            [completedOrdersUncommented enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                count += [obj[@"wareList"] count] + 2;
            }];
            return count==0?1:count;
        }else{
            NSInteger __block count = 0;
            [completedOrdersCommented enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                count += [obj[@"wareList"] count] + 2;
            }];
            return count==0?1:count;
        }
    }else{
        if(dataSource.count == 0){
            return 0;
        }
        return [dataSource[section][@"wareList"] count] + 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(self.orderStatus != 5){
    UITableViewCell *cell=nil;
    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"footerCell"];
        
        
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footerCell"]autorelease];
            
            UILabel *zongjiaLabel=[[[UILabel alloc]initWithFrame:CGRectMake(12, 3, 60, 25)]autorelease];
            zongjiaLabel.backgroundColor = [UIColor clearColor];
            zongjiaLabel.textColor = [UIColor lightGrayColor];
            zongjiaLabel.tag=1;
            UILabel *totalPriceLabel=[[[UILabel alloc]initWithFrame:CGRectMake(68, 3, 100, 25)]autorelease];
            totalPriceLabel.backgroundColor = [UIColor clearColor];
            totalPriceLabel.tag=2;
            UILabel *fareLabel=[[[UILabel alloc]initWithFrame:CGRectMake(60, 28, 120, 12)]autorelease];
            fareLabel.backgroundColor = [UIColor clearColor];
            fareLabel.tag=3;
            [zongjiaLabel setFont:[UIFont systemFontOfSize:13]];
            [totalPriceLabel setTextColor:[UIColor redColor]];
            [totalPriceLabel setFont:[UIFont systemFontOfSize:13]];
            [fareLabel setFont:[UIFont systemFontOfSize:12]];
            fareLabel.textColor = [UIColor lightGrayColor];
            
            UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.tag=indexPath.section;
            [shareBtn setFrame:CGRectMake(240, 50, 70, 30)];
            [shareBtn setBackgroundColor:[UIColor clearColor]];
            [shareBtn setBackgroundImage:[UIImage imageNamed:@"4-05Order List_share button_normal"] forState:UIControlStateNormal];
            [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            
            UIButton *commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            commentBtn.tag=indexPath.section;
            [commentBtn setFrame:CGRectMake(160, 50, 70, 30)];
            [commentBtn setBackgroundColor:[UIColor clearColor]];
            [commentBtn setBackgroundImage:[UIImage imageNamed:@"4-05Order List_share button_normal"] forState:UIControlStateNormal];
            [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentBtn setTitle:@"物流查询" forState:UIControlStateNormal];
            [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            
            
            UIButton *trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            trackBtn.tag = indexPath.section;
            [trackBtn setFrame:CGRectMake(80, 50, 70, 30)];
            [trackBtn setBackgroundColor:[UIColor clearColor]];
            [trackBtn setBackgroundImage:[UIImage imageNamed:@"4-05Order List_share button_normal"] forState:UIControlStateNormal];
            [trackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [trackBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [trackBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            
            [cell.contentView addSubview:zongjiaLabel];
            [cell.contentView addSubview:totalPriceLabel];
            [cell.contentView addSubview:fareLabel];
            [cell.contentView addSubview:trackBtn];//3
            [cell.contentView addSubview:commentBtn];//4
            [cell.contentView addSubview:shareBtn];//5
        }else{//重新设置其下三个按钮的tag为正确的section
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] setTag:indexPath.section];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setTag:indexPath.section];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setTag:indexPath.section];
        }
        
        NSDictionary *data = nil;
        if(self.orderStatus != 5){
            data = dataSource[indexPath.section];
        }else{
            data = indexPath.section == 0?completedOrdersUncommented[indexPath.row]:completedOrdersCommented[indexPath.row];
        }
        
        UILabel *zongjiaLabel=(UILabel *)[cell.contentView.subviews objectAtIndex:0];
        UILabel *totalPriceLabel=(UILabel *)[cell.contentView .subviews objectAtIndex:1];
        UILabel *fareLabel=(UILabel *)[cell.contentView.subviews objectAtIndex:2];
//        UIButton *shareBtn=(UIButton *)[cell.contentView viewWithTag:4];
        
        zongjiaLabel.text=@"总价：";
        totalPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",@"￥",[data[@"payment"] floatValue]];
//        fareLabel.text=@"（含邮费：10元）";
        fareLabel.text=[NSString stringWithFormat:@"（含邮费：%@元）",data[@"deliveryPay"]];
        
        [(UIButton *)[cell.contentView.subviews objectAtIndex:3] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
        
//        if(dataSource[])
        if(self.orderStatus == 1){//待付款
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setTitle:@"去付款" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] addTarget:self action:@selector(onCheckout:) forControlEvents:UIControlEventTouchUpInside];
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setTitle:@"分享" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] setHidden:YES];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setHidden:NO];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setHidden:NO];
        }else if(self.orderStatus == 5){//已完成
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setTitle:@"评价" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setTitle:@"分享" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] setHidden:YES];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setHidden:NO];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setHidden:NO];
        }else if (self.orderStatus == 4){//待收货
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] setTitle:@"确认收货" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] addTarget:self action:@selector(onDelivered:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setTitle:@"物流查询" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] addTarget:self action:@selector(onTrack:) forControlEvents:UIControlEventTouchUpInside];
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setTitle:@"分享" forState:UIControlStateNormal];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setHidden:NO];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setHidden:NO];
        }else{//待发货
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:3] setHidden:YES];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setHidden:YES];
            [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setHidden:NO];
        }
    }
    else if(indexPath.row==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
            

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
        NSDictionary *data = nil;
        if(self.orderStatus != 5){
            data = dataSource[indexPath.section];
        }else{
            data = indexPath.section == 0?completedOrdersUncommented[indexPath.row]:completedOrdersCommented[indexPath.row];
        }
//        ((UILabel*)[cell.contentView viewWithTag:1]).text=@"订单编号：5037688576636821";
        ((UILabel*)[cell.contentView viewWithTag:1]).text=[NSString stringWithFormat:@"%@%@",@"订单编号：",data[@"orderId"]];
        ((UILabel*)[cell.contentView viewWithTag:2]).text=[NSString stringWithFormat:@"%@%@",@"成交时间：",data[@"orderTime"]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
        
        NSDictionary *data = nil;
        if(self.orderStatus != 5){
            data = dataSource[indexPath.section];
        }else{
            data = indexPath.section == 0?completedOrdersUncommented[indexPath.row]:completedOrdersCommented[indexPath.row];
        }
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        [Util UIImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,data[@"wareList"][indexPath.row - 1][@"mediaPath"]]] withImageBlock:^(UIImage *image) {
            imageView.image = image;
        } errorBlock:^{
            NSLog(@"载入图片失败");
        }];
        
        UILabel *description = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *attribute = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *price = (UILabel *)[cell.contentView viewWithTag:5];
        UILabel *quantity = (UILabel *)[cell.contentView viewWithTag:6];
        
        description.text = [NSString stringWithFormat:@"%@", data[@"wareList"][indexPath.row - 1][@"prodName"]];
        attribute.text = [NSString stringWithFormat:@"%@", data[@"wareList"][indexPath.row - 1][@"description"]];
        price.text = [NSString stringWithFormat:@"￥%@", data[@"wareList"][indexPath.row - 1][@"salePrice"]];
        quantity.text = [NSString stringWithFormat:@"X%@", data[@"wareList"][indexPath.row - 1][@"quantity"]];
    }
        return cell;
    }else{
        UITableViewCell *cell = nil;
        
        if([tableView numberOfRowsInSection:indexPath.section] == 1){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
            
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.text = @"没有此类订单";
            cell.textLabel.textColor = [UIColor colorWithRed:68/255.0 green:73/255.0 blue:78/255.0 alpha:1.0];
            return cell;
        }
        
        NSInteger rowType = -1;//cell类型 0:头 1：中间 2：尾
        NSInteger rowIndex = -1;//row在数据源中的相对位置
        NSDictionary *data = nil;
        if(indexPath.section == 1){
            NSInteger count = 0;
            for(int i=0; i<completedOrdersCommented.count; i++){
                if(indexPath.row >= count &&
                   indexPath.row < count + [completedOrdersCommented[i][@"wareList"] count] + 2){
                    //数据源在此处
                    if(indexPath.row == count){
                        rowType = 0;
                    }else if(indexPath.row == count + [completedOrdersCommented[i][@"wareList"] count] + 1){
                        rowType = 2;
                    }else{
                        rowType = 1;
                        rowIndex = indexPath.row - count - 1;
                    }
                    data = completedOrdersCommented[i];
                    break;
                }
                count += [completedOrdersCommented[i][@"wareList"] count] + 2;
            }
        }else{
            NSInteger count = 0;
            for(int i=0; i<completedOrdersUncommented.count; i++){
                if(indexPath.row >= count &&
                   indexPath.row < count + [completedOrdersUncommented[i][@"wareList"] count] + 2){
                    //数据源在此处
                    if(indexPath.row == count){
                        rowType = 0;
                    }else if(indexPath.row == count + [completedOrdersUncommented[i][@"wareList"] count] + 1){
                        rowType = 2;
                    }else{
                        rowType = 1;
                        rowIndex = indexPath.row - count - 1;
                    }
                    data = completedOrdersUncommented[i];
                    break;
                }
                count += [completedOrdersUncommented[i][@"wareList"] count] + 2;
            }
        }
        
        if(rowType == 1){
                cell= [tableView dequeueReusableCellWithIdentifier:@"orderListCell"];
                
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
                [Util UIImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,data[@"wareList"][rowIndex][@"mediaPath"]]] withImageBlock:^(UIImage *image) {
                    imageView.image = image;
                } errorBlock:^{
                    NSLog(@"载入图片失败");
                }];
                
                UILabel *description = (UILabel *)[cell.contentView viewWithTag:2];
                UILabel *attribute = (UILabel *)[cell.contentView viewWithTag:3];
                UILabel *price = (UILabel *)[cell.contentView viewWithTag:5];
                UILabel *quantity = (UILabel *)[cell.contentView viewWithTag:6];
                
                description.text = [NSString stringWithFormat:@"%@", data[@"wareList"][rowIndex][@"prodName"]];
                attribute.text = [NSString stringWithFormat:@"%@", data[@"wareList"][rowIndex][@"description"]];
                price.text = [NSString stringWithFormat:@"￥%@", data[@"wareList"][rowIndex][@"salePrice"]];
                quantity.text = [NSString stringWithFormat:@"X%@", data[@"wareList"][rowIndex][@"quantity"]];
            }else if (rowType == 0){
                cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell==nil)
                {
                    cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
                    
                    
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
                ((UILabel*)[cell.contentView viewWithTag:1]).text=[NSString stringWithFormat:@"%@%@",@"订单编号：",data[@"orderId"]];
                ((UILabel*)[cell.contentView viewWithTag:2]).text=[NSString stringWithFormat:@"%@%@",@"成交时间：",data[@"orderTime"]];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell=[tableView dequeueReusableCellWithIdentifier:@"footerCell"];
                
                if(cell==nil)
                {
                    cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footerCell"]autorelease];
                    
                    UILabel *zongjiaLabel=[[[UILabel alloc]initWithFrame:CGRectMake(12, 3, 60, 25)]autorelease];
                    zongjiaLabel.backgroundColor = [UIColor clearColor];
                    zongjiaLabel.textColor = [UIColor lightGrayColor];
                    zongjiaLabel.tag=1;
                    UILabel *totalPriceLabel=[[[UILabel alloc]initWithFrame:CGRectMake(68, 3, 100, 25)]autorelease];
                    totalPriceLabel.backgroundColor = [UIColor clearColor];
                    totalPriceLabel.tag=2;
                    UILabel *fareLabel=[[[UILabel alloc]initWithFrame:CGRectMake(60, 28, 120, 12)]autorelease];
                    fareLabel.backgroundColor = [UIColor clearColor];
                    fareLabel.tag=3;
                    [zongjiaLabel setFont:[UIFont systemFontOfSize:13]];
                    [totalPriceLabel setTextColor:[UIColor redColor]];
                    [totalPriceLabel setFont:[UIFont systemFontOfSize:13]];
                    [fareLabel setFont:[UIFont systemFontOfSize:12]];
                    fareLabel.textColor = [UIColor lightGrayColor];
                    
                    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    shareBtn.tag=indexPath.row;
                    [shareBtn setFrame:CGRectMake(240, 50, 70, 30)];
                    [shareBtn setBackgroundColor:[UIColor clearColor]];
                    [shareBtn setBackgroundImage:[UIImage imageNamed:@"4-05Order List_share button_normal"] forState:UIControlStateNormal];
                    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
                    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    
                    UIButton *commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    commentBtn.tag=indexPath.row;
                    [commentBtn setFrame:CGRectMake(160, 50, 70, 30)];
                    [commentBtn setBackgroundColor:[UIColor clearColor]];
                    [commentBtn setBackgroundImage:[UIImage imageNamed:@"4-05Order List_share button_normal"] forState:UIControlStateNormal];
                    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [commentBtn setTitle:@"物流查询" forState:UIControlStateNormal];
                    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    
                    
                    UIButton *trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    trackBtn.tag = indexPath.section;
                    [trackBtn setFrame:CGRectMake(80, 50, 70, 30)];
                    [trackBtn setBackgroundColor:[UIColor clearColor]];
                    [trackBtn setBackgroundImage:[UIImage imageNamed:@"4-05Order List_share button_normal"] forState:UIControlStateNormal];
                    [trackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [trackBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [trackBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                    
                    UILabel *sectionLabel = [[[UILabel alloc] init] autorelease];
                    sectionLabel.text = [NSString stringWithFormat:@"%d", indexPath.section];
                    sectionLabel.tag = sectonLabelTag;
                    sectionLabel.hidden = YES;
                    UILabel *rowLabel = [[[UILabel alloc] init] autorelease];
                    rowLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
                    rowLabel.tag = rowLabelTag;
                    rowLabel.hidden = YES;
                    
                    [cell.contentView addSubview:zongjiaLabel];
                    [cell.contentView addSubview:totalPriceLabel];
                    [cell.contentView addSubview:fareLabel];
                    [cell.contentView addSubview:trackBtn];//3
                    [cell.contentView addSubview:commentBtn];//4
                    [cell.contentView addSubview:shareBtn];//5
                    [cell.contentView addSubview:sectionLabel];
                    [cell.contentView addSubview:rowLabel];
                }
                
                UILabel *zongjiaLabel=(UILabel *)[cell.contentView.subviews objectAtIndex:0];
                UILabel *totalPriceLabel=(UILabel *)[cell.contentView .subviews objectAtIndex:1];
                UILabel *fareLabel=(UILabel *)[cell.contentView.subviews objectAtIndex:2];
                //        UIButton *shareBtn=(UIButton *)[cell.contentView viewWithTag:4];
                
                zongjiaLabel.text=@"总价：";
                totalPriceLabel.text=[NSString stringWithFormat:@"%@%.2f",@"￥",[data[@"payment"] floatValue]];
                fareLabel.text=[NSString stringWithFormat:@"（含邮费：%@元）",data[@"deliveryPay"]];
                
                [(UIButton *)[cell.contentView.subviews objectAtIndex:3] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
                
                [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setTitle:@"评价" forState:UIControlStateNormal];
                [(UIButton *)[cell.contentView .subviews objectAtIndex:4] addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
                
                [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setTitle:@"分享" forState:UIControlStateNormal];
                [(UIButton *)[cell.contentView .subviews objectAtIndex:5] addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
                
                [(UIButton *)[cell.contentView .subviews objectAtIndex:3] setHidden:YES];
                [(UIButton *)[cell.contentView .subviews objectAtIndex:4] setHidden:NO];
                [(UIButton *)[cell.contentView .subviews objectAtIndex:5] setHidden:NO];
                
            }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.orderStatus != 5){
        if(dataSource.count == 0){
            return tableHeaderHeight;
        }
        return 10.0f;
    }else{
        return tableHeaderHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.orderStatus != 5){
    if (indexPath.row==0){
        return 50.0f;
    }else if(indexPath.row == [dataSource[indexPath.section][@"wareList"] count] + 1){
//         return [[cellsArr objectAtIndex:0]bounds].size.height;
        return 90.0f;
    }
    else
    {
        return 88.0f;
    }
    }else{
        
        NSInteger count = 0;
        NSInteger rowType = -1;
        NSArray *arr = indexPath.section == 0?completedOrdersUncommented:completedOrdersCommented;
        for(int i=0; i<arr.count; i++){
            if(indexPath.row >= count &&
               indexPath.row < count + [arr[i][@"wareList"] count] + 2){
                //数据源在此处
                if(indexPath.row == count){
                    rowType = 0;
                }else if(indexPath.row == count + [arr[i][@"wareList"] count] + 1){
                    rowType = 2;
                }else{
                    rowType = 1;
                }
                break;
            }
            count += [arr[i][@"wareList"] count] + 2;
        }
        
        if(rowType == 0){
            return 50.0f;
        }else if (rowType == 1){
            return 88.0f;
        }else if(rowType == 2){
            return 90.0f;
        }else{//显示“没有此类订单”
            return 50.0;
        }
    }
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 50;
//    
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    
//    UIView *headView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)]autorelease];
//    UILabel *orderNumberLabel=[[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 200, 25)]autorelease];
//     UILabel *transActionLabel=[[[UILabel alloc]initWithFrame:CGRectMake(5, 25, 200, 25)]autorelease];
//    orderNumberLabel.text=@"订单编号：5037688576636821";
//    transActionLabel.text=@"成交时间：2014-01-06 16：52";
//    [orderNumberLabel setFont:[UIFont systemFontOfSize:13]];
//    [transActionLabel setFont:[UIFont systemFontOfSize:12]];
//    [transActionLabel setTextColor:[Util rgbColor:"b7b7b7"]];
//    [headView addSubview:orderNumberLabel];
//    [headView addSubview:transActionLabel];
//    return  headView;
//
//    
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//    UIView *footerView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]autorelease];
//    UILabel *zongjiaLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 25)]autorelease];
//    UILabel *totalPriceLabel=[[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 25)]autorelease];
//    UILabel *fareLabel=[[[UILabel alloc]initWithFrame:CGRectMake(60, 25, 100, 25)]autorelease];
//    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [shareBtn setFrame:CGRectMake(SCREEN_WIDTH-100, 5, 60, 30)];
//    [shareBtn setBackgroundColor:[UIColor redColor]];
//    
//    zongjiaLabel.text=@"总价";
//    totalPriceLabel.text=@"￥90.06";
//    fareLabel.text=@"（含邮费：10元）";
//    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    [zongjiaLabel setFont:[UIFont systemFontOfSize:13]];
//    [totalPriceLabel setTextColor:[UIColor redColor]];
//    [totalPriceLabel setFont:[UIFont systemFontOfSize:13]];
//    [fareLabel setFont:[UIFont systemFontOfSize:13]];
//    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    
//    [footerView addSubview:zongjiaLabel];
//    [footerView addSubview:totalPriceLabel];
//    [footerView addSubview:fareLabel];
//    [footerView addSubview:shareBtn];
//
//    
//    return footerView;
//
//
//
//    
//}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 42;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.orderStatus != 5){
    if(indexPath.row == 0){
    OrderDetailViewController *orderDetail=[[OrderDetailViewController alloc]initWithOrderId:dataSource[indexPath.section][@"orderId"]];
    [self.navigationController pushViewController:orderDetail animated:YES];
    orderDetail.title=@"订单详情";
    [orderDetail release];
    }
    }else{
        NSInteger count = 0;
        NSInteger rowType = -1;
        NSInteger rowIndex = -1;
        NSArray *arr = indexPath.section == 0?completedOrdersUncommented:completedOrdersCommented;
        for(int i=0; i<arr.count; i++){
            if(indexPath.row >= count &&
               indexPath.row < count + [arr[i][@"wareList"] count] + 2){
                //数据源在此处
                if(indexPath.row == count){
                    rowType = 0;
                    rowIndex = i;
                }else if(indexPath.row == count + [arr[i][@"wareList"] count] + 1){
                    rowType = 2;
                }else{
                    rowType = 1;
                }
                break;
            }
            count += [arr[i][@"wareList"] count] + 2;
        }
        if(rowType == 0){
            OrderDetailViewController *orderDetail=[[OrderDetailViewController alloc]initWithOrderId:arr[rowIndex][@"orderId"]];
            orderDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderDetail animated:YES];
            [orderDetail release];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)requestData{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:[NSNumber numberWithInteger:orderStatus] forKey:@"orderStatus"];
    [param setObject:@10 forKey:@"num"];
    [param setObject:@1 forKey:@"pageIndex"];
    
    NSMutableArray *arr0 = [NSMutableArray array];
    NSMutableArray *arr1 = [NSMutableArray array];
    
    [RemoteManager Posts:kGET_MY_ORDER Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                if([json[@"myOrderList"] count] > 0){
                    if(dataSource){
                        [dataSource release];
                    }
                    dataSource = [json[@"myOrderList"] copy];
                    
                    [json[@"myOrderList"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        BOOL __block allItemsCommented = YES;
                        [obj[@"wareList"] enumerateObjectsUsingBlock:^(id childObj, NSUInteger childIdx, BOOL *childStop) {
                            if([childObj[@"discussStatus"] integerValue] != 1){
                                allItemsCommented = NO;
                                *childStop = YES;
                            }
                        }];
                        
                        if(allItemsCommented){
                            [arr0 addObject:obj];
                        }else{
                            [arr1 addObject:obj];
                        }
                    }];
                    
                    completedOrdersCommented = [arr0 copy];
                    completedOrdersUncommented = [arr1 copy];
                    
                    [self.orderListTable reloadData];
                }
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error :%@",error);
        }
    }];
    
    
    
    [param release];
}

- (void)onShare2:(UIButton *)sender
{
    NSDictionary *localData = nil;
    NSString *productName = nil;
    NSString *productDesc = nil;
    if(self.orderStatus != 5){
        NSInteger section = sender.tag;
//        ShareViewController *share = [[ShareViewController alloc] initWithProductInfo:dataSource[section]];
//        share.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:share animated:YES];
//        [share release];
        localData = dataSource[section];
        NSMutableArray *names = [NSMutableArray new];
        NSMutableArray *descs = [NSMutableArray new];
        for(NSDictionary *item in localData[@"wareList"]){
            [names addObject:item[@"prodName"]];
            [descs addObject:item[@"description"]];
        }
        productName = [names componentsJoinedByString:@","];
        productDesc = [descs componentsJoinedByString:@" "];
        [names release];
        [descs release];
    }else{//已完成订单
        NSInteger section = [((UILabel *)[sender.superview viewWithTag:sectonLabelTag]).text integerValue];
        NSInteger row = [((UILabel *)[sender.superview viewWithTag:rowLabelTag]).text integerValue];
        
        NSInteger count = 0;
        NSArray *arr = section == 0?completedOrdersUncommented:completedOrdersCommented;
        for(int i=0; i<arr.count; i++){
            if(row >= count &&
               row < count + [arr[i][@"wareList"] count] + 2){
                //数据源在此处
                localData = arr[i];
                break;
            }
            count += [arr[i][@"wareList"] count] + 2;
        }
        NSMutableArray *names = [NSMutableArray new];
        NSMutableArray *descs = [NSMutableArray new];
        for(NSDictionary *item in localData[@"wareList"]){
            [names addObject:item[@"prodName"]];
            [descs addObject:item[@"description"]];
        }
        productName = [names componentsJoinedByString:@","];
        productDesc = [descs componentsJoinedByString:@" "];
        [names release];
        [descs release];
    }
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ [来自：%@]", productDesc, [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleNameKey]]
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:[NSString stringWithFormat:@"[分享]%@", productName]
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)onComment:(UIButton *)sender
{
//    NSLog(@"click comment button: %@",dataSource[section]);
    if(self.orderStatus != 5){
        NSInteger section = sender.tag;
        CommentViewController *commentVC = [[CommentViewController alloc] initWithOrder:dataSource[section]];
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
        [commentVC release];
    }else{
        NSInteger section = [((UILabel *)[sender.superview viewWithTag:sectonLabelTag]).text integerValue];
        NSInteger row = [((UILabel *)[sender.superview viewWithTag:rowLabelTag]).text integerValue];
        
        NSInteger count = 0;
        NSDictionary *data = nil;
        NSArray *arr = section == 0?completedOrdersUncommented:completedOrdersCommented;
        for(int i=0; i<arr.count; i++){
            if(row >= count &&
               row < count + [arr[i][@"wareList"] count] + 2){
                //数据源在此处
                data = arr[i];
                break;
            }
            count += [arr[i][@"wareList"] count] + 2;
        }
        CommentViewController *commentVC = [[CommentViewController alloc] initWithOrder:data];
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
        [commentVC release];
    }
}

- (void)requestOrderDelivered:(NSDictionary *)order
{
//    NSLog(@"%@",order);
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:order[@"orderId"] forKey:@"orderId"];
    
    [RemoteManager Posts:kCONFIRM_ORDER Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            [CustomBezelActivityView removeViewAnimated:YES];
            if([json[@"state"] integerValue] == 1){
                [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:0 text:@"操作成功" duration:1.5];
            }else{
                NSLog(NSLocalizedString(@"请求参数错误", @""));
                NSLog(@"reason: %@",json[@"message"]);
                NSLog(@"params: %@", param);
            }
        }else{
            [CustomBezelActivityView removeViewAnimated:YES];
            NSLog(NSLocalizedString(@"网络故障", @""));
        }
    }];
    
    [param release];
}

- (void)onDelivered:(UIButton *)sender
{
    ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"确认收货" message:@"请仅在收货后再进行此操作，以免造成损失" cancelButtonTitle:@"取消操作" otherButtonTitle:@"我已确认" cancelBlock:nil otherBlock:^{
        NSInteger section = sender.tag;
        [self requestOrderDelivered:dataSource[section]];
    }];
    [alert show];
    [alert release];
}

- (void)onTrack:(UIButton *)sender
{
    NSInteger section = sender.tag;
    LogisticsViewController *logistics = [[LogisticsViewController alloc] initWithOrder:dataSource[section]];
    logistics.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:logistics animated:YES];
    [logistics release];
}

- (void)onCheckout:(UIButton *)sender
{
    NSDictionary *localData = nil;
    if(self.orderStatus != 5){
        NSInteger section = sender.tag;
        //        ShareViewController *share = [[ShareViewController alloc] initWithProductInfo:dataSource[section]];
        //        share.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:share animated:YES];
        //        [share release];
        localData = dataSource[section];
    }else{
        NSInteger section = [((UILabel *)[sender.superview viewWithTag:sectonLabelTag]).text integerValue];
        NSInteger row = [((UILabel *)[sender.superview viewWithTag:rowLabelTag]).text integerValue];
        
        NSInteger count = 0;
        NSArray *arr = section == 0?completedOrdersUncommented:completedOrdersCommented;
        for(int i=0; i<arr.count; i++){
            if(row >= count &&
               row < count + [arr[i][@"wareList"] count] + 2){
                //数据源在此处
                localData = arr[i];
                break;
            }
            count += [arr[i][@"wareList"] count] + 2;
        }
    }
    
    NSLog(@"check out order: %@",localData[@"orderId"]);
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithOrderId:localData[@"orderId"]];
    orderDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetail animated:YES];
    [orderDetail release];
}
//
#pragma mark - ButtonHandler
/**
 *	@brief	分享全部
 *
 *	@param 	sender 	事件对象
 */
- (void)onShare:(UIButton *)sender
{
    //
    NSDictionary *localData = nil;
    NSString *productName = nil;
    NSString *productDesc = nil;
    NSString *productImage=nil;//展示图片，默认只加载第一个图片
    if(self.orderStatus != 5){
        NSInteger section = sender.tag;
        //        ShareViewController *share = [[ShareViewController alloc] initWithProductInfo:dataSource[section]];
        //        share.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:share animated:YES];
        //        [share release];
        localData = dataSource[section];
        NSMutableArray *names = [NSMutableArray new];
        NSMutableArray *descs = [NSMutableArray new];
        for(NSDictionary *item in localData[@"wareList"]){
            [names addObject:item[@"prodName"]];
            [descs addObject:item[@"description"]];
        }
        productName = [names componentsJoinedByString:@","];
        productDesc = [descs componentsJoinedByString:@" "];
        [names release];
        [descs release];
    }else{//已完成订单
        NSInteger section = [((UILabel *)[sender.superview viewWithTag:sectonLabelTag]).text integerValue];
        NSInteger row = [((UILabel *)[sender.superview viewWithTag:rowLabelTag]).text integerValue];
        
        NSInteger count = 0;
        NSArray *arr = section == 0?completedOrdersUncommented:completedOrdersCommented;
        for(int i=0; i<arr.count; i++){
            if(row >= count &&
               row < count + [arr[i][@"wareList"] count] + 2){
                //数据源在此处
                localData = arr[i];
                break;
            }
            count += [arr[i][@"wareList"] count] + 2;
        }
        NSMutableArray *names = [NSMutableArray new];
        NSMutableArray *descs = [NSMutableArray new];
        for(NSDictionary *item in localData[@"wareList"]){
            [names addObject:item[@"prodName"]];
            [descs addObject:item[@"description"]];
        }
        productName = [names componentsJoinedByString:@","];
        productDesc = [descs componentsJoinedByString:@" "];
        [names release];
        [descs release];
    }
    //图片路径
    //NSString *subImg=[NSString stringWithFormat:@"%@",localData[@"wareList"][0][@"mediaPath"]]
    productImage = [NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,localData[@"wareList"][0][@"mediaPath"]];
    //信息字段汇集
    NSData *imgd=[NSData dataWithContentsOfURL:[NSURL URLWithString:productImage]];
    id<ISSCAttachment> image_ISSCAttachment0=[ShareSDK imageWithData:imgd fileName:nil mimeType:@"image/jpeg"];//[ShareSDK imageWithUrl:@"http://192.168.200.92:8080/SRMC/Merchant/13080815193235900001/Ware/S5F13228/Unit/20130815/unit_1447166657655.jpg"];//@"http://list.image.baidu.com/t/yingshi.jpg"]
    id<ISSCAttachment> image_ISSCAttachment1=[ShareSDK jpegImageWithImage:[UIImage imageWithData:imgd] quality:1.0];
    id<ISSCAttachment> image_ISSCAttachment=[ShareSDK imageWithUrl:productImage];//内网图片新浪分享失败,很奇怪易信能用且必须用
    //
    NSString *title=[NSString stringWithFormat:@"[分享]%@", productName];
    NSString *description=[NSString stringWithFormat:@"%@ [来自：%@]", productDesc,
                           [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"]
                           //[[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleNameKey]
                           ];
    NSString *url=@"http://www.cndatacom.com";
    //////
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"LOGO"  ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ [来自：%@]", productDesc,
                                                       [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"]
                                                       //[[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleNameKey]
                                                       ]
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:image_ISSCAttachment1
                                     //image:[ShareSDK imageWithUrl:@"http://list.image.baidu.com/t/yingshi.jpg"]//productImage]
                                     //image:[ShareSDK imageWithUrl:productImage]
                                     //image:[ShareSDK imageWithPath:imagePath]
                                                title:[NSString stringWithFormat:@"[分享]%@", productName]
                                                  url:@"http://www.cndatacom.com"
                                          description:[NSString stringWithFormat:@"%@ [来自：%@]", productDesc, [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"]]//NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    ///////////////////////
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制腾讯微博信息
    [publishContent addTencentWeiboUnitWithContent:[NSString stringWithFormat:@"%@\n%@\n%@", title, description, url]
                                             image:INHERIT_VALUE//image_ISSCAttachment
                                locationCoordinate:nil];
    //定制新浪微博信息
    [publishContent addSinaWeiboUnitWithContent: [NSString stringWithFormat:@"%@\n%@\n%@", title, description, url]
                                          image:INHERIT_VALUE//image_ISSCAttachment
                             locationCoordinate:nil];

    //定制人人网信息
    [publishContent addRenRenUnitWithName:NSLocalizedString(@"TEXT_HELLO_RENREN", @"Hello 人人网")
                              description:INHERIT_VALUE
                                      url:INHERIT_VALUE
                                  message:INHERIT_VALUE
                                    image:INHERIT_VALUE
                                  caption:nil];
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:INHERIT_VALUE//NSLocalizedString(@"TEXT_HELLO_QZONE", @"Hello QQ空间")
                                        url:INHERIT_VALUE
                                       site:nil
                                    fromUrl:nil
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE//image_ISSCAttachment//[ShareSDK imageWithUrl:@"http://list.image.baidu.com/t/yingshi.jpg"]//[ShareSDK imageWithUrl:productImage]
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:nil];
    
//    //定制微信好友信息
//    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                         content:INHERIT_VALUE
//                                           title:NSLocalizedString(@"TEXT_HELLO_WECHAT_SESSION", @"Hello 微信好友!")
//                                             url:INHERIT_VALUE
//                                      thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                           image:INHERIT_VALUE
//                                    musicFileUrl:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil];
//    
//    //定制微信朋友圈信息
//    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
//                                          content:INHERIT_VALUE
//                                            title:NSLocalizedString(@"TEXT_HELLO_WECHAT_TIMELINE", @"Hello 微信朋友圈!")
//                                              url:@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4BDA0E4B88DE698AFE79C9FE6ADA3E79A84E5BFABE4B990222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696332342E74632E71712E636F6D2F586B303051563558484A645574315070536F4B7458796931667443755A68646C2F316F5A4465637734356375386355672B474B304964794E6A3770633447524A574C48795333383D2F3634363232332E6D34613F7569643D32333230303738313038266469723D423226663D312663743D3026636869643D222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31382E71716D757369632E71712E636F6D2F33303634363232332E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E5889BE980A0EFBC9AE5B08FE5B7A8E89B8B444E414C495645EFBC81E6BC94E594B1E4BC9AE5889BE7BAAAE5BD95E99FB3222C22736F6E675F4944223A3634363232332C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E4BA94E69C88E5A4A9222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D31354C5569396961495674593739786D436534456B5275696879366A702F674B65356E4D6E684178494C73484D6C6A307849634A454B394568572F4E3978464B316368316F37636848323568413D3D2F33303634363232332E6D70333F7569643D32333230303738313038266469723D423226663D302663743D3026636869643D2673747265616D5F706F733D38227D"
//                                       thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                            image:INHERIT_VALUE
//                                     musicFileUrl:@"http://mp3.mwap8.com/destdir/Music/2009/20090601/ZuiXuanMinZuFeng20090601119.mp3"
//                                          extInfo:nil
//                                         fileData:nil
//                                     emoticonData:nil];
//    
//    //定制微信收藏信息
//    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
//                                     content:INHERIT_VALUE
//                                       title:NSLocalizedString(@"TEXT_HELLO_WECHAT_FAV", @"Hello 微信收藏!")
//                                         url:INHERIT_VALUE
//                                  thumbImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
//                                       image:INHERIT_VALUE
//                                musicFileUrl:nil
//                                     extInfo:nil
//                                    fileData:nil
//                                emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:INHERIT_VALUE
                                title:INHERIT_VALUE//@"Hello QQ!"
                                  url:INHERIT_VALUE
                                image:INHERIT_VALUE];
    
    //定制邮件信息
    [publishContent addMailUnitWithSubject:INHERIT_VALUE//@"Hello Mail"
                                   content:INHERIT_VALUE
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@\n%@\n%@", title, description, url]];//INHERIT_VALUE];//@"Hello SMS"];
    
    //定制有道云笔记信息
    [publishContent addYouDaoNoteUnitWithContent:INHERIT_VALUE
                                           title:NSLocalizedString(@"TEXT_HELLO_YOUDAO_NOTE", @"Hello 有道云笔记")
                                          author:@"ShareSDK"
                                          source:nil
                                     attachments:INHERIT_VALUE];
    
    //定制Instapaper信息
    [publishContent addInstapaperContentWithUrl:INHERIT_VALUE
                                          title:@"Hello Instapaper"
                                    description:INHERIT_VALUE];
    
    //定制搜狐随身看信息
    [publishContent addSohuKanUnitWithUrl:INHERIT_VALUE];
    
    //定制Pinterest信息
    [publishContent addPinterestUnitWithImage:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                          url:INHERIT_VALUE
                                  description:INHERIT_VALUE];
    
    //定制易信好友信息
    [publishContent addYiXinSessionUnitWithType:INHERIT_VALUE
                                        content:INHERIT_VALUE
                                          title:INHERIT_VALUE
                                            url:INHERIT_VALUE
                                     thumbImage:image_ISSCAttachment//[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                          image:INHERIT_VALUE
                                   musicFileUrl:INHERIT_VALUE
                                        extInfo:INHERIT_VALUE
                                       fileData:INHERIT_VALUE];
    //定义易信朋友圈信息
    [publishContent addYiXinTimelineUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:image_ISSCAttachment//[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]
                                           image:INHERIT_VALUE
                                    musicFileUrl:INHERIT_VALUE
                                         extInfo:INHERIT_VALUE
                                        fileData:INHERIT_VALUE];
    
    //结束定制信息
    ////////////////////////
     
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil//_appDelegate.viewDelegate////授权视图上的顶部导航
                                               authManagerViewDelegate:APP_DELEGATE.viewDelegate//_appDelegate.viewDelegate];
                                      ];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"//NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:APP_DELEGATE.viewDelegate//_appDelegate.viewDelegate
                                                          friendsViewDelegate:nil//_appDelegate.viewDelegate
                                                        picViewerViewDelegate:nil];
    //定义菜单分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSMS,
                          ShareTypeMail,
                          ShareTypeAirPrint,
                          ShareTypeCopy,
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeQQ,
                          ShareTypeQQSpace,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeWeixiFav,
                          ShareTypeYiXinSession,
                          ShareTypeYiXinTimeline,
                          ShareTypeYiXinFav,
                          //
                          ShareType163Weibo,ShareTypeDouBan,ShareTypeDropbox,
                          ShareTypeEvernote,ShareTypeFacebook,ShareTypeFlickr,
                          ShareTypeFoursquare,ShareTypeGooglePlus,ShareTypeInstagram,
                          ShareTypeInstapaper,ShareTypeKaixin,ShareTypeLinkedIn,
                          ShareTypePengyou,ShareTypePinterest,ShareTypePocket,
                          ShareTypeRenren,ShareTypeSohuKan,ShareTypeSohuWeibo,
                          ShareTypeTumblr,ShareTypeTwitter,ShareTypeVKontakte,
                          ShareTypeYouDaoNote,ShareTypeAny,
                          //SHARE_TYPE_NUMBER(ShareTypeSMS),
                          //SHARE_TYPE_NUMBER(ShareTypeQQ),
                          //SHARE_TYPE_NUMBER(ShareTypeMail),
                          //SHARE_TYPE_NUMBER(ShareTypeAirPrint),
                          //SHARE_TYPE_NUMBER(ShareTypeCopy),
                          nil];
    //创建自定义分享列表
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          //sinaItem,
//                          SHARE_TYPE_NUMBER(ShareTypeSMS),
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
//                          SHARE_TYPE_NUMBER(ShareTypeQQ),
//                          SHARE_TYPE_NUMBER(ShareTypeMail),
//                          SHARE_TYPE_NUMBER(ShareTypeAirPrint),
//                          SHARE_TYPE_NUMBER(ShareTypeCopy),
//                          nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

//
@end
