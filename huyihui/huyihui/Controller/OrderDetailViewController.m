//
//  OrderDetailViewController.m
//  huyihui
//
//  Created by zhangmeifu on 20/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()
{
    UIButton  *settleBtn;
    UILabel *totalPriceLabel;
    
    UIView *settleView;
}
@property (copy, nonatomic) NSDictionary *orderTransaction;    //订单交易对象
@property (copy, nonatomic) NSDictionary *orderBilling;	//订单发票对象
@property (copy, nonatomic) NSDictionary *orderWareBillObject;	//订单商品清单 包括订单商品列表及商品信息
@property (copy, nonatomic) NSString *orderId;
@end

@implementation OrderDetailViewController
@synthesize orderDetailTable=_orderDetailTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithOrderId:(NSString *)orderId
{
    self = [super init];
    if(self){
        _orderId = [orderId copy];
    }
    return self;
}

static NSString *addressCell = @"addressCell";
static NSString *itemCell = @"itemCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"订单详情";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:242/255.0 blue:241/255.0 alpha:1.0];
    _orderDetailTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _orderDetailTable.translatesAutoresizingMaskIntoConstraints = NO;
    _orderDetailTable.delegate=self;
    _orderDetailTable.dataSource=self;
//    _orderDetailTable.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
    _orderDetailTable.backgroundColor = [UIColor clearColor];
    
    _orderDetailTable.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] autorelease];
    
    [_orderDetailTable registerNib:[UINib nibWithNibName:@"OrderDetailCellAddress" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:addressCell];
    [_orderDetailTable registerNib:[UINib nibWithNibName:@"OrderDetailCellItem" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:itemCell];
    
    [self.view addSubview:_orderDetailTable];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_orderDetailTable attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_orderDetailTable attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_orderDetailTable attribute:NSLayoutAttributeTop multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_orderDetailTable attribute:NSLayoutAttributeBottom multiplier:1.0 constant:44.0]
                                ]];
    
    settleView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, 44)];
    [settleView setBackgroundColor:[UIColor lightTextColor]];
    settleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    settleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [settleBtn setFrame:CGRectMake(SCREEN_WIDTH-80, 7, 60, 30)];
    [settleBtn setTitle:@"结算" forState:UIControlStateNormal];
    [settleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settleBtn.layer.cornerRadius=10;
    [settleBtn setBackgroundColor:[UIColor redColor]];
    [settleBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [settleBtn addTarget:self action:@selector(onCheckOut:) forControlEvents:UIControlEventTouchUpInside];
    
    totalPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 30)];
    totalPriceLabel.text=@"合计：0.00元（含邮费：10元）";
    [totalPriceLabel setFont:[UIFont systemFontOfSize:13]];
    [totalPriceLabel setBackgroundColor:[UIColor clearColor]];
    [totalPriceLabel setTextColor:[UIColor redColor]];
    
    
    [settleView addSubview:totalPriceLabel];
    [settleView addSubview:settleBtn];
    
    [self.view addSubview:settleView];
    [self.view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:settleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:settleView attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:settleView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0]
                               ]];
    [settleView addConstraint:[NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:.0 constant:44.0]];
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestOrderDetail];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.orderId = nil;
    self.orderDetailTable=nil;
    [super dealloc];
}

- (void)updateView{
    totalPriceLabel.text = [NSString stringWithFormat:@"合计：%.2f元（含邮费：%d元）",[self.orderWareBillObject[@"wareMoneyTotal"] floatValue],[self.orderWareBillObject[@"deliveryPayTotal"] integerValue]];
    [_orderDetailTable reloadData];
}

#pragma mark tableview dateSource
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    else
    {
        return @"订单状态";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return nil;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 100, 15)];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.textColor = [UIColor colorWithRed:112/255.0 green:114/255.0 blue:116/255.0 alpha:1.0];
    keyLabel.font = [UIFont systemFontOfSize:15];
    keyLabel.text = @"订单状态";
    [view addSubview:keyLabel];
    [keyLabel release];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 8, 80, 15)];
    valueLabel.textColor = [UIColor colorWithRed:228/255.0 green:91/255.0 blue:94/255.0 alpha:1.0];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *orderStatusDict = @{@1:@"待付款", @2:@"待发货", @4:@"待收货", @5:@"已完成"};
    valueLabel.text = orderStatusDict[self.orderWareBillObject[@"status"]];
    [view addSubview:valueLabel];
    [valueLabel release];
    
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 10.0f;
    else
        return 30.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return [self.orderWareBillObject[@"wareList"] count] + 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *cells=[[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:nil];
//    return [[cells objectAtIndex:indexPath.section]bounds].size.height;
    if(indexPath.section == 0){
        return 78.0f;
    }else{
        if(indexPath.row < [self.orderWareBillObject[@"wareList"] count]){
            return 89.0f;
        }else{
            return 44.0f;
        }
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *cells=[[NSBundle mainBundle] loadNibNamed:@"OrderDetailCell" owner:self options:nil];
//    return [cells objectAtIndex:indexPath.section];
    UITableViewCell *cell = nil;
    if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:addressCell forIndexPath:indexPath];
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *mobileLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UITextView *addressLabel = (UITextView *)[cell.contentView viewWithTag:3];
        
        nameLabel.text = self.orderTransaction[@"deliveryName"];
        mobileLabel.text = self.orderTransaction[@"deliveryMobile"];
        addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",self.orderTransaction[@"deliveryAddress"]];
        
    }else{
        if(indexPath.row < [self.orderWareBillObject[@"wareList"] count]){
            cell = [tableView dequeueReusableCellWithIdentifier:itemCell forIndexPath:indexPath];
            
            UIImageView *itemImage = (UIImageView *)[cell.contentView viewWithTag:1];
            UILabel *itemTitle = (UILabel *)[cell.contentView viewWithTag:2];
            UILabel *itemPrice = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *itemQuantity = (UILabel *)[cell.contentView viewWithTag:4];
            UILabel *itemAttribute = (UILabel *)[cell.contentView viewWithTag:5];
            
            //取图质量//0：2G/3G(标清图),1：wifi（高清图）
            NSString *urlStr = @"";
            
            if (APP_DELEGATE.userPreferredImageQuality_Value == 0)
            {
                urlStr = [NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,self.orderWareBillObject[@"wareList"][indexPath.row][@"mediaPath"]];
            }
            else if (APP_DELEGATE.userPreferredImageQuality_Value == 1)
            {
                urlStr = [NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,self.orderWareBillObject[@"wareList"][indexPath.row][@"mediaPath2G3G"]];
            }
            else if (APP_DELEGATE.userPreferredImageQuality_Value == 2)
            {
                urlStr = [NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,self.orderWareBillObject[@"wareList"][indexPath.row][@"mediaPathWifi"]];
            }
            
            [Util UIImageFromURL:[NSURL URLWithString:urlStr] withImageBlock:^(UIImage *image) {
                itemImage.image = image;
            } errorBlock:^{
                NSLog(@"载入图片失败");
            }];
            
            itemTitle.text = [NSString stringWithFormat:@"%@", self.orderWareBillObject[@"wareList"][indexPath.row][@"name"]];
            itemPrice.text = [NSString stringWithFormat:@"￥%@", self.orderWareBillObject[@"wareList"][indexPath.row][@"promotion"]];
            itemQuantity.text = [NSString stringWithFormat:@"x%@", self.orderWareBillObject[@"wareList"][indexPath.row][@"quantity"]];
            itemAttribute.text = [NSString stringWithFormat:@"%@", self.orderWareBillObject[@"wareList"][indexPath.row][@"remark"]];
            
        }else{// if(indexPath.row == [self.orderWareBillObject[@"wareList"] count]){//最后一行
            static NSString *orderCell = @"orderCell";
            cell = [tableView dequeueReusableCellWithIdentifier:orderCell];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCell] autorelease];
                UILabel *orderInfo = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, SCREEN_WIDTH - 20, 15)];
                orderInfo.tag = 1;
                orderInfo.backgroundColor = [UIColor clearColor];
                orderInfo.textColor = [UIColor lightGrayColor];
                orderInfo.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:orderInfo];
                [orderInfo release];
                
                UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(12, 24, SCREEN_WIDTH - 20, 15)];
                orderTime.tag = 2;
                orderTime.backgroundColor = [UIColor clearColor];
                orderTime.font = [UIFont systemFontOfSize:13];
                orderTime.textColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:orderTime];
                [orderTime release];
            }
            
            [(UILabel *)[cell.contentView viewWithTag:1] setText:[NSString stringWithFormat:@"订单编号：%@",self.orderTransaction[@"orderId"]]];
            [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"成交时间：%@",self.orderTransaction[@"transactionTimeStr"]]];
        }
    }
    
    return cell;
}

- (void)requestOrderDetail
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:self.orderId forKey:@"orderId"];
    
    [RemoteManager Posts:kGET_MY_ORDER_DETAIL Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            [CustomBezelActivityView removeViewAnimated:YES];
            if([json[@"state"] integerValue] == 1){
                self.orderBilling = json[@"orderBilling"];
                self.orderTransaction = json[@"orderTransaction"];
                self.orderWareBillObject = json[@"orderWareBillObject"];
                [self updateView];
                
                if([self.orderWareBillObject[@"status"] integerValue]!= 1){
                    [settleView removeFromSuperview];
                    [settleView release];settleView = nil;
                }
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

- (void)onCheckOut:(id)sender{
    [self doAlipayCompletion:^(NSError *error) {
        if(error){
            ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"支付失败" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:nil otherBlock:nil];
            [alert show];
            [alert release];
        }
    }];
}

- (void)doAlipayCompletion:(void(^)(NSError *error))completionBlock
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"正在准备支付页面，请稍候..."];
    
    //调用支付宝支付
    
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
//	Product *product = [_products objectAtIndex:indexPath.row];
	
	/*
	 *商户的唯一的parnter和seller。
	 *本demo将parnter和seller信息存于（AlixPayDemo-Info.plist）中,外部商户可以考虑存于服务端或本地其他地方。
	 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
	 */
	//如果partner和seller数据存于其他位置,请改写下面两行代码
	NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AlipayPartnerId"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AlipaySellerId"];
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，本demo中的公私钥存放在AlixPayDemo-Info.plist中,外部商户可以存放在服务端或本地其他地方。
	 */
	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = self.orderId; //订单ID（由商家自行制定）
	order.productName = [NSString stringWithFormat:@"%@等%d件商品",self.orderWareBillObject[@"wareList"][0][@"name"],[self.orderWareBillObject[@"wareNumberTotal"] integerValue]]; //商品标题
	order.productDescription = @""; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",[self.orderWareBillObject[@"wareMoneyTotal"] floatValue]]; //商品价格
	order.notifyURL =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AlipayNotifyURL"]; //回调URL
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于快捷支付成功后重新唤起商户应用
	NSString *appScheme = @"AlixPayCDCScheme";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"AlipayRSAPrivateKey"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
    
	if (signedString != nil) {
        
        [CustomBezelActivityView removeViewAnimated:YES];
        
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
        return;
	}
    
    [CustomBezelActivityView removeViewAnimated:YES];
}
@end