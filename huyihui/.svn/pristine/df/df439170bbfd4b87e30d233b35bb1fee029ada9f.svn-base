//
//  CheckOutCenterViewController.m
//  huyihui
//
//  Created by zhangmeifu on 6/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "CheckOutCenterViewController.h"
#import "ReceiveAddressController.h"
#import "PayStyleSelect.h"

@interface CheckOutCenterViewController ()
{
    
    NSArray *cellTitleArr;
    UIButton *settleBtn;
    UILabel *totalPriceLabel;
    
//    NSMutableDictionary *orderDetails;//订单信息字典
    
    //默认地址信息
    NSDictionary *defaultAddressInfo;
    
    NSArray *orderList;//订单中的商品
    
    NSString *promDes;
    
    CGFloat couponMoney;//优惠券金额
    
    CGFloat promotionDiscount;//打折促销折扣
    
    CGFloat promotionMoney;//满减促销金额
    
    
////    //以下为接口需要用到的字段
//    NSString *deliveryId;
//    NSString *deliveryCity;
//    NSString *deliveryAddress;
//    NSInteger payMethod;//0 支付宝 1 翼支付
//    NSString *deliveryName;
//    NSString *deliveryMobile;
//    NSNumber *selectProvince;
//    NSNumber *selectCity;
//    NSNumber *selectArea;
//    NSString *selectProvinceStr;
//    NSString *selectCityStr;
//    NSString *selectAreaStr;
////    NSMutableDictionary *order;
//    NSString *isBilling;//	String	是否需要发票 0--否 1--是
//    NSString *billingTitle;//	String	发票抬头（可为空）
//    NSString *deliveryOption;//	String	配送方式 1--快递 2--EMS
//    NSString *deliveryTime;//	String	配送时间 1:只工作日送货(双休日、假日不用送)2:只双休日,假日送货(工作日不用送)  3: 工作日、双休日与假日均可送货)
//    NSString *remark;//买家留言
//    NSString *couponId;
}

//@property (assign, nonatomic) NSInteger payMethod;
//@property (copy, nonatomic) NSString *isBilling;
//@property (copy, nonatomic) NSString *billingTitle;
//@property (copy, nonatomic) NSString *deliveryOption;
//@property (copy, nonatomic) NSString *deliveryTime;
//@property (copy, nonatomic) NSString *remark;
//@property (copy, nonatomic) NSString *couponId;

@property (retain, nonatomic) HuEasyOrder *order;

@end

@implementation CheckOutCenterViewController

//@synthesize payMethod,isBilling,billingTitle,deliveryOption,deliveryTime,remark,couponId;
@synthesize order;
//@synthesize checkOutTable=_checkOutTable;
//@synthesize cells=_cells;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //格式：@"标题"：@[@"第一行左边文字",@"第一行右边文字"],@[@"第二行左边文字",@"第二行右边文字"], ...
        cellTitleArr=[@[
                        @[@"",@""],
                        @[@"配送方式及送货时间",@[@"配送方式",@"快递：包邮"],@[@"送货时间",@"工作日、双休日与假日均可送货"]],
                        @[@"",@[@"发票信息",@"不开发票"]],
                        @[@"",@[@"选择支付方式",@""]],
                        @[@"",@[@"使用优惠券",@""]],
                        @[@"",@[@"促销优惠",@"无"]],
                        @[@"",@[@"给卖家留言：选填",@""]],
                        ] retain];
//        orderDetails = [NSMutableDictionary new];
//        payMethod = 0;
//        deliveryOption = @"1";//默认选择快递
//        deliveryTime = @"1";
//        isBilling = @"0";
        order = [[HuEasyOrder alloc] init];
        couponMoney = .0f;
        promotionDiscount = 10.0f;
        promotionMoney = .0f;
    }
    return self;
}

- (id)initWithProducts:(NSArray *)products{
    self = [super init];
    if(self){
        orderList = [products copy];
        promDes = [@"无" copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"结算中心";
    [self.view setBackgroundColor:[Util rgbColor:"f3f2f1"]];
    
//    NSMutableAttributedString *infoAttrStr = [NSMutableAttributedString new];
//    [infoAttrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:@"您共需要为订单支付：" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor brownColor]}] autorelease]];
//    [infoAttrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:@"￥188.00" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]}] autorelease]];
//    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
//    image.backgroundColor = [UIColor yellowColor];
//    image.userInteractionEnabled = YES;
//    
//    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 200, 20)];
//    info.backgroundColor = [UIColor clearColor];
//    info.textColor = [UIColor brownColor];
//    info.attributedText = infoAttrStr;
//    [infoAttrStr release];
//    [image addSubview:info];
//    [info release];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(240, 5, 60, 24)];
//    btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    btn.layer.cornerRadius = 3.0f;
//    [btn setTitle:@"订单详情" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(onShowOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundColor:[UIColor lightGrayColor]];
//    [image addSubview:btn];
//    [btn release];
//    
//    [self.view addSubview:image];
//    [image release];
    
    _checkOutTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _checkOutTable.translatesAutoresizingMaskIntoConstraints = NO;
    _checkOutTable.delegate=self;
    _checkOutTable.dataSource=self;
    //    [_checkOutTable registerNib:[UINib nibWithNibName:@"checkOutCell" bundle:nil] forCellReuseIdentifier:@"addressCell"];
    self.cells=[[NSBundle mainBundle]loadNibNamed:@"checkOutCell" owner:self options:nil];
    
    [self.view addSubview:_checkOutTable];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:_checkOutTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:_checkOutTable attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:_checkOutTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-44.0],
                                [NSLayoutConstraint constraintWithItem:_checkOutTable attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                                ]];
    UIView *settleView=[[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, 44)]autorelease];
    [settleView setBackgroundColor:[UIColor lightTextColor]];
    settleView.translatesAutoresizingMaskIntoConstraints = NO;

    
    
    settleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [settleBtn setFrame:CGRectMake(200, 8, 80, 30)];
    [settleBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [settleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settleBtn.layer.cornerRadius=10;
    [settleBtn setBackgroundColor:[UIColor redColor]];
    [settleBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [settleBtn addTarget:self action:@selector(confirmOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    totalPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180, 30)];
    totalPriceLabel.text=@"总计：0.00元";
    [totalPriceLabel setFont:[UIFont systemFontOfSize:13]];
    [totalPriceLabel setBackgroundColor:[UIColor clearColor]];
    [totalPriceLabel setTextColor:[UIColor redColor]];
    
    
    [settleView addSubview:totalPriceLabel];
    [settleView addSubview:settleBtn];
    
    [self.view addSubview:settleView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                                ]];

    [settleView addConstraint:[NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:.0 constant:44.0f]];
    
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
    [self requestOrderInfoSuccess:^(NSDictionary *result) {
        [CustomBezelActivityView removeViewAnimated:YES];
        promDes = [result[@"promDes"] copy];
//        order = [result[@"orderForm"] mutableCopy];
        [order loadDataFromDictionary:result[@"orderForm"]];
        
        if ([[order objectForKey:@"deliveryOption"] integerValue] == 0)
        {
            [order setObject:[NSNumber numberWithInt:1] forKey:@"deliveryOption"];
        }
        if ([[order objectForKey:@"deliveryTime"] integerValue] == 0)
        {
            [order setObject:[NSNumber numberWithInt:3] forKey:@"deliveryTime"];
        }
        
        [self recalculateGrossMoneyAndShow];
        
        [self.checkOutTable reloadData];
        
    } failure:^{
        [CustomBezelActivityView removeViewAnimated:YES];
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:@"获取订单信息失败" duration:1.0];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getDeliveryAddressFromServer];
    [_checkOutTable reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cellTitleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellTitleArr[section] count] - 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        //    NSArray *cell=[[NSBundle mainBundle]loadNibNamed:@"checkOutCell" owner:self options:nil];
        return [[self.cells objectAtIndex:0]bounds].size.height;
        //return 60;
    }
    else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section != cellTitleArr.count - 1){
        return .0001f;
    }else{
        return 88.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section != cellTitleArr.count - 1){
        return nil;
    }else{
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88.0f)];
        backView.backgroundColor = [Util rgbColor:"f3f2f1"];
        return [backView autorelease];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return .0001f;
    }else if([cellTitleArr[section][0] isEqualToString:@""]){
        return 10;
    }else{
        return 30;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return nil;
    }else if([cellTitleArr[section][0] isEqualToString:@""]){
        return nil;
    }else{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    backView.backgroundColor = [Util rgbColor:"f3f2f1"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 20)];
        label.backgroundColor = [UIColor clearColor];
    label.textColor = [Util rgbColor:"3d4245"];
    label.font = [UIFont systemFontOfSize:12];
    label.text = cellTitleArr[section][0];
    [backView addSubview:label];
    [label release];
    return [backView autorelease];
//    
//    if (section==1)
//    {
//        return @"配送方式及送货时间";
//    }
//    else if (section==2)
//    {
//        return @"发票信息";
//    }
//    else
//    {
//        return nil;
//    }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section==0)
    {
//        NSArray *myCells=[[NSBundle mainBundle]loadNibNamed:@"checkOutCell" owner:self options:nil];
        cell=[self.cells objectAtIndex:0];
        //        NSDictionary *defaultAddress = [NSKeyedUnarchiver unarchiveObjectWithData: [NUSD objectForKey:kUserDefaultAddress]];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *mobileLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:3];
        if([order objectForKey:@"deliveryName"] == nil || [[order objectForKey:@"deliveryName"] isEqual:[NSNull null]] || [[order objectForKey:@"deliveryName"] isEqualToString:@""]){
            if(defaultAddressInfo != nil){
                nameLabel.text = defaultAddressInfo[@"recivecontact"];
                mobileLabel.text = defaultAddressInfo[@"shippingmobile"];
                addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@",defaultAddressInfo[@"provinceStr"],defaultAddressInfo[@"cityStr"],defaultAddressInfo[@"regionStr"]];
                
                [order setValue:defaultAddressInfo[@"userKo"] forKey:@"deliveryId"];
                [order setValue:defaultAddressInfo[@"cityId"] forKey:@"deliveryCity"];
                [order setValue:defaultAddressInfo[@"shippingaddress"] forKey:@"deliveryAddress"];
                [order setValue:defaultAddressInfo[@"recivecontact"] forKey:@"deliveryName"];
                [order setValue:defaultAddressInfo[@"shippingmobile"] forKey:@"deliveryMobile"];
                [order setValue:defaultAddressInfo[@"provinceId"] forKey:@"selectProvince"];
                [order setValue:defaultAddressInfo[@"cityId"] forKey:@"selectCity"];
                [order setValue:defaultAddressInfo[@"shippingregion"] forKey:@"selectArea"];
                [order setValue:defaultAddressInfo[@"provinceStr"] forKey:@"selectProvinceStr"];
                [order setValue:defaultAddressInfo[@"cityStr"]  forKey:@"selectCityStr"];
                [order setValue:defaultAddressInfo[@"regionStr"]  forKey:@"selectAreaStr"];
            }
        }else{
            nameLabel.text = [order objectForKey:@"deliveryName"];
            mobileLabel.text = [order objectForKey:@"deliveryMobile"];
            addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@",[order objectForKey:@"selectProvinceStr"],[order objectForKey:@"selectCityStr"],[order objectForKey:@"selectAreaStr"]];
        }
    }
    else
    {
        cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (nil==cell)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = [Util rgbColor:"3d4245"];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [Util rgbColor:"3d4245"];
        }
        
        cell.textLabel.text = cellTitleArr[indexPath.section][indexPath.row + 1][0];
        cell.detailTextLabel.text = cellTitleArr[indexPath.section][indexPath.row + 1][1];
        
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                cell.detailTextLabel.text = [[order objectForKey:@"deliveryOption"] integerValue]==1?@"快递":@"EMS";
            }
            if (indexPath.row == 1)
            {
                if ([[order objectForKey:@"deliveryTime"] integerValue] == 1)
                {
                    cell.detailTextLabel.text = @"只工作日送货";
                }
                else if ([[order objectForKey:@"deliveryTime"] integerValue] == 2)
                {
                    cell.detailTextLabel.text = @"只双休日、假日送货";
                }
                else if ([[order objectForKey:@"deliveryTime"] integerValue] == 3)
                {
                    cell.detailTextLabel.text = @"工作日、双休日与假日均可送货";
                }
            }
        }else if (indexPath.section == 2){
            if(indexPath.row == 0){
                cell.detailTextLabel.text = [[order objectForKey:@"isBilling"] integerValue]==0?@"不开发票":[order objectForKey:@"billingTitle"];
            }
        }
        else if(indexPath.section == 3){
            cell.detailTextLabel.text = [[order objectForKey:@"payMethod"] integerValue]==0?@"支付宝":@"翼支付";
        }else if(indexPath.section == 4){
            if([order objectForKey:@"couponId"] != nil && ![[order objectForKey:@"couponId"] isEqualToString:@""]){
                cell.detailTextLabel.text = [order objectForKey:@"couponId"];
            }else{
                cell.detailTextLabel.text = @"无优惠券";
            }
        }else if(indexPath.section == 5){//促销信息
            if([order objectForKey:@"promDes"] != nil && ![[order objectForKey:@"promDes"] isEqualToString:@""]){
            cell.detailTextLabel.text = [order objectForKey:@"promDes"];
            }else{
                cell.detailTextLabel.text = @"无促销";
            }
        }else if(indexPath.section == 6){
            cell.detailTextLabel.text = [order objectForKey:@"remark"];
        }
    }
    
    
    if (indexPath.section==0 || indexPath.section == 5)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *mobileLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:3];
        ReceiveAddressController *receiveCtrl=[[ReceiveAddressController alloc]initWithNibName:@"ReceiveAddressController" bundle:nil];
        receiveCtrl.completeAddress = ^(NSDictionary *address){
            nameLabel.text = address[@"recivecontact"];
            mobileLabel.text = address[@"shippingmobile"];
            addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@",address[@"provinceStr"],address[@"cityStr"],address[@"regionStr"]];
            
            
            [order setValue:address[@"userKo"] forKey:@"deliveryId"];
            [order setValue:address[@"cityId"] forKey:@"deliveryCity"];
            [order setValue:address[@"shippingaddress"] forKey:@"deliveryAddress"];
            [order setValue:address[@"recivecontact"] forKey:@"deliveryName"];
            [order setValue:address[@"shippingmobile"] forKey:@"deliveryMobile"];
            [order setValue:address[@"provinceId"] forKey:@"selectProvince"];
            [order setValue:address[@"cityId"] forKey:@"selectCity"];
            [order setValue:address[@"shippingregion"] forKey:@"selectArea"];
            [order setValue:address[@"provinceStr"] forKey:@"selectProvinceStr"];
            [order setValue:address[@"cityStr"]  forKey:@"selectCityStr"];
            [order setValue:address[@"regionStr"]  forKey:@"selectAreaStr"];

        };
        [self.navigationController pushViewController:receiveCtrl animated:YES];
        [receiveCtrl release];
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            NSArray *options = [NSArray arrayWithObjects:@{@"display":@"快递", @"value":@1}, @{@"display":@"EMS", @"value":@2}, nil];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            ChoosePayMeansViewController *payMeansVC = [[ChoosePayMeansViewController alloc] initWithOptions:options selectedIndex:[[order objectForKey:@"deliveryOption"] integerValue] completion:^(NSDictionary *res) {
                cell.detailTextLabel.text = res[@"display"];
//                deliveryOption = [[NSString stringWithFormat:@"%@", res[@"value"]] copy];
                [order setValue:[NSString stringWithFormat:@"%@", res[@"value"]] forKey:@"deliveryOption"];
            }];
            payMeansVC.title = @"选择配送方式";
            payMeansVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payMeansVC animated:YES];
            [payMeansVC release];
        }else if(indexPath.row == 1){
            //送货时间
            //1:只工作日送货(双休日、假日不用送)
            //2:只双休日,假日送货(工作日不用送)
            //3: 工作日、双休日与假日均可送货)
            NSArray *options = [NSArray arrayWithObjects:
                                  @{@"display":@"只工作日送货", @"value":@1},
                                  @{@"display":@"只双休日、假日送货", @"value":@2},
                                  @{@"display":@"工作日、双休日与假日均可送货", @"value":@3},
                                nil];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            ChoosePayMeansViewController *payMeansVC = [[ChoosePayMeansViewController alloc] initWithOptions:options selectedIndex:[[order objectForKey:@"deliveryTime"] integerValue] completion:^(NSDictionary *res) {
                cell.detailTextLabel.text = res[@"display"];
//                deliveryTime = [[NSString stringWithFormat:@"%@", res[@"value"]] copy];
                [order setValue:res[@"value"] forKey:@"deliveryTime"];
            }];
            payMeansVC.title = @"选择送货时间";
            payMeansVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payMeansVC animated:YES];
            [payMeansVC release];
        }
    }else if(indexPath.section == 2){//发票
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ChooseReceiptType *receipt = [[ChooseReceiptType alloc] initWithSelectedIndex:[[order objectForKey:@"isBilling"] integerValue] completion:^(NSDictionary *res) {
            if([res[@"value"] integerValue] == 1){
                cell.detailTextLabel.text = res[@"receiptHeader"];
//                billingTitle = [res[@"receiptHeader"] copy];
//                isBilling = [@"1" copy];
                [order setValue:res[@"receiptHeader"] forKey:@"billingTitle"];
                [order setValue:@"1" forKey:@"isBilling"];
                
            }else{
                cell.detailTextLabel.text = @"不开发票";
//                isBilling = [@"0" copy];
                [order setValue:@"0" forKey:@"isBilling"];
            }
        }];
        receipt.receiptStr = [order objectForKey:@"billingTitle"];
        receipt.title = @"填写发票信息";
        receipt.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:receipt animated:YES];
        [receipt release];
    }else if(indexPath.section == 3){//支付方式
        NSArray *options = [NSArray arrayWithObjects:@{@"display":@"支付宝", @"value":@0}, @{@"display":@"翼支付", @"value":@1}, nil];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ChoosePayMeansViewController *payMeansVC = [[ChoosePayMeansViewController alloc] initWithOptions:options selectedIndex:[[order objectForKey:@"payMethod"] integerValue] completion:^(NSDictionary *res) {
            cell.detailTextLabel.text = res[@"display"];
//            payMethod = [res[@"value"] integerValue];
            [order setValue:res[@"value"] forKey:@"payMethod"];
        }];
        payMeansVC.title = @"选择支付方式";
        payMeansVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payMeansVC animated:YES];
        [payMeansVC release];
    }else if(indexPath.section == 4){//优惠券
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UsingCouponViewController *coupon = [[UsingCouponViewController alloc] initWithCode:cell.detailTextLabel.text];
        coupon.completionBlock = ^(NSDictionary *dict){
            if (dict != nil)
            {
                NSLog(@"coupon info :%@",dict);
                //            couponId = [dict[@"id"] copy];
                [order setValue:dict[@"id"] forKey:@"couponId"];
                cell.detailTextLabel.text = dict[@"id"];
                couponMoney = [dict[@"money"] floatValue];
                [self recalculateGrossMoneyAndShow];
            }
            else
            {
                [order setObject:@"" forKey:@"couponId"];
                cell.detailTextLabel.text = @"无优惠券";
                couponMoney = 0;
                [self recalculateGrossMoneyAndShow];
            }
        };
        coupon.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coupon animated:YES];
        [coupon release];
    }else if(indexPath.section == 5){//促销优惠
        
    }else if(indexPath.section == 6){//留言
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BuyerRemark *remarkView = [[BuyerRemark alloc] initWithText:[order objectForKey:@"remark"]];
        remarkView.completionBlock = ^(NSString *remarkContent){
            cell.detailTextLabel.text = remarkContent;
//            remark = remarkContent;
            [order setValue:remarkContent forKey:@"remark"];
        };
        remarkView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:remarkView animated:YES];
        [remarkView release];
    }
}

- (void)recalculateGrossMoneyAndShow{
    
    CGFloat orderMoney = [[order objectForKey:@"paymentTotalPrice"] floatValue];
    CGFloat deliveryFee = [[order objectForKey:@"deliveryPay"] floatValue];
    
    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];
    [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：%.2f元",orderMoney - couponMoney] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor redColor]}] autorelease]];
    
    [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(含邮费：%.0f元)",deliveryFee] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor grayColor]}] autorelease]];
    totalPriceLabel.attributedText = attrStr;
    [attrStr release];
}

-(void)confirmOrderAction:(id)sender
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
//    NSMutableString *wareInfosTuan = [NSMutableString new];
//    NSMutableString *wareInfos = [NSMutableString new];
//    __block CGFloat ordinaryProductsSum = .0f;
//    __block CGFloat tuanProductsSum = .0f;
//    __block NSMutableString *target = nil;
//    __block NSInteger productCount = 0;
//    [orderList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if([obj[@"teamFlag"] integerValue] != HuEasyProductTypeOrdinary){
//            target = wareInfosTuan;
//            tuanProductsSum += [obj[@"specialPrice"] floatValue];
//        }else{
//            target = wareInfos;
//            ordinaryProductsSum += [obj[@"specialPrice"] floatValue];
//        }
//        productCount += [obj[@"prodNumber"] integerValue];
//        [target appendFormat:@"%@&",[@[obj[@"specificationId"],
//                                       obj[@"speciesId"],
//                                       obj[@"plu"],
//                                       obj[@"isSpecialWare"]?obj[@"isSpecialWare"]:@"",
//                                       obj[@"sku"],
//                                       obj[@"prodNumber"],
//                                       obj[@"retailPrice"],
//                                       obj[@"specialPrice"],
//                                       obj[@"point"],
//                                       obj[@"prodName"],
//                                       obj[@"picturePath"],
//                                       obj[@"prodSpec"],
//                                       obj[@"wareSource"]?obj[@"wareSource"]:@"",
//                                       obj[@"batchCode"]?obj[@"batchCode"]:@"",
//                                       obj[@"teamFlag"],
//                                       obj[@"weight"]]
//                                     componentsJoinedByString:@"|"]];
//    }];
    
//    CGFloat deliveryPay = 0.0f;
//    CGFloat paymentTotalPrice = 10.0f;
//    CGFloat discountPrice = .0f;
//    [order setObject:[[wareInfos copy] autorelease] forKey:@"wareInfos"];
//    [order setObject:[[wareInfosTuan copy] autorelease] forKey:@"wareInfosTuan"];
//    order.cartWareInfos = order.wareInfos;
//    [order setObject:deliveryId forKey:@"deliveryId"];//	String	收货人信息id
//    [order setObject:[NSString stringWithFormat:@"%d",productCount] forKey:@"wareNum"];//	int	商品数量
//    [order setObject:@0 forKey:@"point"];//	int	赠送积分（默认值为0）
//    [order setObject:@.0f forKey:@"specialTrans"];//	double	满减优惠
//    [orderDetails setObject:[NSNumber numberWithFloat:deliveryPay] forKey:@"deliveryPay"];//	double	运费
//    [orderDetails setObject:[NSNumber numberWithFloat:ordinaryProductsSum] forKey:@"totalPrice"];//	double	普通商品总金额（如满减优惠等之前的商品优惠总金额）
//    [orderDetails setObject:[NSNumber numberWithFloat:tuanProductsSum] forKey:@"totalPriceTuan"];//	double	团购秒杀商品总金额
//    [orderDetails setObject:[NSNumber numberWithFloat:paymentTotalPrice] forKey:@"paymentTotalPrice"];//	double	金额总计（应支付金额总计）
//    [order setObject:[NSNumber numberWithInteger:payMethod] forKey:@"payMethod"];//	int	支付方式 1--在线支付 2--货到付款 3--积分支付)
//    [order setObject:@"ALIPAY" forKey:@"payBank"];//	String	支付银行
//    [order setObject:deliveryOption forKey:@"deliveryOption"];//	String	配送方式 1--快递 2--EMS
//    [order setObject:deliveryCity forKey:@"deliveryCity"];//	String	配送城市（使用新地址为必填）
//    [order setObject:deliveryAddress forKey:@"deliveryAddress"];//	String	配送地址（使用新地址为必填）
//    [order setObject:deliveryTime forKey:@"deliveryTime"];//	String	配送时间 1:只工作日送货(双休日、假日不用送)
//                                                    //2:只双休日,假日送货(工作日不用送)  3: 工作日、双休日与假日均可送货)
//    [order setObject:deliveryName forKey:@"deliveryName"];//	String	配送收货人（使用新地址为必填）
//    [order setObject:deliveryMobile forKey:@"deliveryMobile"];//	String	配送联系电话（使用新地址为必填）
//    [order setValue:remark forKey:@"remark"];//	String	附加说明(可为空)
//    [order setObject:isBilling forKey:@"isBilling"];//	String	是否需要发票 0--否 1--是
//    [order setValue:billingTitle forKey:@"billingTitle"];//	String	发票抬头（可为空）
//    [orderDetails setObject:@0 forKey:@"orderType"];//	int	订单类型(默认值0)
//    [orderDetails setObject:@"john@mail.abc" forKey:@"orderEmail"];//	String	用来接收订单下单、支付、发货提醒邮件，及时了解订单状态
//    [order setObject:selectProvince forKey:@"selectProvince"];//	int	收货人地址省Id（使用新地址为必填）
//    [order setObject:selectCity forKey:@"selectCity"];//	int	收货人地址市Id（使用新地址为必填）
//    [order setObject:selectArea forKey:@"selectArea"];//	int	收货人地址区县Id（使用新地址为必填）
//    [order setObject:selectProvinceStr forKey:@"selectProvinceStr"];//	String	收货人地址省名称（使用新地址为必填）
//    [order setObject:selectCityStr forKey:@"selectCityStr"];//	String	收货人地址市名称（使用新地址为必填）
//    [order setObject:selectAreaStr forKey:@"selectAreaStr"];//	String	收货人地址区县名称（使用新地址为必填）
//    [orderDetails setObject:[NSNumber numberWithFloat:discountPrice] forKey:@"discountPrice"];//	double	打折金额
//    [orderDetails setObject:@"N" forKey:@"isCurrentDiscount"];//	String	简易促销方案：是否打折 Y为是,N为否
//    [orderDetails setObject:@"Y" forKey:@"isCurrentFreeDelivery"];//	String	简易促销方案：是否免运费 Y为是,N为否
//    [orderDetails setObject:@"auto" forKey:@"groupId"];//	String	促销方案（默认值为：auto）
//    [order setValue:couponId forKey:@"couponId"];//	String	优惠劵ID（如有选择优惠券则必填）
    
    NSMutableArray *cartWareInfos = [NSMutableArray new];
    [orderList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cartWareInfos addObject:[NSString stringWithFormat:@"%@,%@",obj[@"speciesId"],obj[@"sku"]]];
    }];
    [order setObject:[cartWareInfos componentsJoinedByString:@";"] forKey:@"cartWareInfos"];
    [cartWareInfos release];
    
    [self requestSubmitOrderSuccess:^(NSDictionary *orderInfo){
        [CustomBezelActivityView removeViewAnimated:YES];
        NSLog(@"提交订单成功");
        [[HuEasyShoppingCart sharedInstance] pullCompletion:nil];
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"您已成功提交订单" cancelButtonTitle:@"查看并支付" otherButtonTitle:nil cancelBlock:^(){
            OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithOrderId:orderInfo[@"orderId"]];
            orderDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderDetail animated:YES];
            [orderDetail release];
        } otherBlock:nil];
        [alert show];
        [alert release];
    } failure:^(NSString *info){
        [CustomBezelActivityView removeViewAnimated:YES];
        NSLog(@"提交订单失败");
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT - 100
                                 image:[UIImage imageNamed:@"3-02checkout_center_04_fail"]
                                  text:[NSString stringWithFormat:@"提交订单失败:%@", info]
                              duration:1.5f];
    }];
    
}

-(void)requestOrderInfoSuccess:(void (^)(NSDictionary *result))successBlock
                  failure:(void (^)())failureBlock
{
    NSMutableString *cartWareInfos = [NSMutableString new];
    [orderList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cartWareInfos appendString:[NSString stringWithFormat:@"%@,%@,%@;",obj[@"speciesId"],obj[@"sku"],obj[@"prodNumber"]]];
    }];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [params setObject:[NUSD objectForKey:kCurrentUserEmail] forKey:@"email"];
    [params setObject:[cartWareInfos.copy autorelease] forKey:@"cartWareInfos"];
    
    [cartWareInfos release];
    
    [RemoteManager Posts:kFILL_OUT_ORDER Parameters:params WithBlock:^(id json, NSError *error) {
        if (error!=nil)
        {
            NSLog(@"%@",json);
        }else{
            if([json[@"state"] integerValue] == 1){
                if(successBlock != nil){
                    successBlock(json);
                }
            }else{
                if(failureBlock != nil){
                    failureBlock();
                }
                NSLog(@"请求参数：%@",params);
            }
        }
    }];
    
    
    [params release];
}

-(void)requestSubmitOrderSuccess:(void (^)(NSDictionary *orderInfo))successBlock
                             failure:(void (^)(NSString *info))failureBlock
{
    NSString *orderStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[order toDictionary] options:0 error:nil] encoding:NSUTF8StringEncoding];;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [params setObject:[NUSD objectForKey:kCurrentUserName] forKey:@"userName"];
    [params setObject:orderStr forKey:@"orderform"];
    
    [RemoteManager Posts:kSUBMIT_ORDER Parameters:params WithBlock:^(id json, NSError *error) {
        if (error!=nil)
        {
            NSLog(@"%@",json);
        }else{
            if([json[@"state"] integerValue] == 1){
                if(successBlock != nil){
                    successBlock(json[@"orderObject"]);
                }
            }else{
                if(failureBlock != nil){
                    failureBlock(json[@"message"]);
                }
                NSLog(@"接口名：%@ \n 请求参数：%@",kSUBMIT_ORDER, params);
            }
        }
    }];
        
    
    [params release];
    [orderStr release];
}


-(void)getDeliveryAddressFromServer
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [params setObject:[NSNumber numberWithInt:5] forKey:@"num"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    
    dispatch_group_t localGroup = dispatch_group_create();
    
    dispatch_group_enter(localGroup);
    [RemoteManager PostAsync:kGET_DELIVERY_INFO Parameters:params WithBlock:^(id json, NSError *error) {
        if (error==nil)
        {
            int latestAdd=0;
            for (int i=0;i<[json[@"deliveryInfoList"] count];i++)
            {
                NSDictionary *dic = json[@"deliveryInfoList"][i];
                if ([[dic objectForKey:@"latestAdd"]intValue]==1)
                {
                    if(defaultAddressInfo){
                        [defaultAddressInfo release];
                    }
                    defaultAddressInfo = [dic copy];
                    latestAdd=1;
                    break;
                }
                
            }
            if ((latestAdd==0) && ([json[@"deliveryInfoList"] count] != 0))
            {
                defaultAddressInfo =[ json[@"deliveryInfoList"][0] copy];
            }
            
        }
        dispatch_group_leave(localGroup);
    }];
    
    dispatch_group_notify(localGroup, dispatch_get_main_queue(),^{
        if(defaultAddressInfo == nil){
            ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"你还未设置默认收货地址" message:@"请设置默认收货地址！" cancelButtonTitle:@"取消" otherButtonTitle:@"立即设置" cancelBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } otherBlock:^{
                ReceiveAddressController *addAddress = [[ReceiveAddressController alloc] init];
                addAddress.completeAddress = ^(NSDictionary *addressInfo){
                    UITableViewCell *cell=[_checkOutTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
                    UILabel *mobileLabel = (UILabel *)[cell.contentView viewWithTag:2];
                    UILabel *addressLabel = (UILabel *)[cell.contentView viewWithTag:3];
                    nameLabel.text = addressInfo[@"recivecontact"];
                    mobileLabel.text = addressInfo[@"shippingmobile"];
                    addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@",addressInfo[@"provinceStr"],addressInfo[@"cityStr"],addressInfo[@"regionStr"]];
                    
                    [order setValue:addressInfo[@"userKo"] forKey:@"deliveryId"];
                    [order setValue:addressInfo[@"cityId"] forKey:@"deliveryCity"];
                    [order setValue:addressInfo[@"shippingaddress"] forKey:@"deliveryAddress"];
                    [order setValue:addressInfo[@"recivecontact"] forKey:@"deliveryName"];
                    [order setValue:addressInfo[@"shippingmobile"] forKey:@"deliveryMobile"];
                    [order setValue:addressInfo[@"provinceId"] forKey:@"selectProvince"];
                    [order setValue:addressInfo[@"cityId"] forKey:@"selectCity"];
                    [order setValue:addressInfo[@"shippingregion"] forKey:@"selectArea"];
                    [order setValue:addressInfo[@"provinceStr"] forKey:@"selectProvinceStr"];
                    [order setValue:addressInfo[@"cityStr"]  forKey:@"selectCityStr"];
                    [order setValue:addressInfo[@"regionStr"]  forKey:@"selectAreaStr"];
                };
                addAddress.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addAddress animated:YES];
                [addAddress release];
            }];
            [alert show];
            [alert release];
        }else{
            [_checkOutTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    });
    
    dispatch_release(localGroup);
}

//- (void)onShowOrderDetail:(id)sender
//{
//    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] initWithOrderId:@"12314124088515"];
//    orderDetail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:orderDetail animated:YES];
//    [orderDetail release];
//}
@end
