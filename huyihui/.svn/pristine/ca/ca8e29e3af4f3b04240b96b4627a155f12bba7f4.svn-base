//
//  CouponViewController.m
//  huyihui
//
//  Created by zaczh on 14-2-25.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "CouponViewController.h"
#import "SectionFactory.h"

@interface CouponViewController ()
@property (copy, nonatomic) NSArray *coupons;
@property (assign, nonatomic) NSInteger couponType;
@end

@implementation CouponViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static NSString *cellIdentifier= @"cellIdentifier";
//static NSString *searchCell = @"searchCell";

- (void)viewWillAppear:(BOOL)animated
{
    [self requestDataByCouponType:_couponType];
    [_table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"优惠券专区";
    
    [self.table registerNib:[UINib nibWithNibName:@"CouponCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
//    [rightBtn addTarget:self action:@selector(onActivatingCoupon:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setTitle:@"激活" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    [rightBtn release];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//    [rightBarItem release];
    
    ButtonFactory *buttonFactory = [ButtonFactory factory];
    UIButton *rightBtn = [buttonFactory createButtonWithType:ACTIVEBUTTON];
    [rightBtn addTarget:self action:@selector(onActivatingCoupon:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem release];
    _couponType = 0;
    [self requestDataByCouponType:_couponType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//优惠券状态（0：未使用，1：已使用，2：已过期，）
- (void)requestDataByCouponType:(NSInteger)type
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"请稍候", @"")];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:[NSNumber numberWithInteger:type] forKey:@"couponType"];
    
    [RemoteManager Posts:kGET_SUBSCRIBER_COUPON Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                self.coupons = [json objectForKey:@"couponList"];
                [self.table reloadData];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error 0:%@",error);
        }
    }];
    [param release];
}

#pragma mark - tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.coupons.count;
    
    self.tablePlaceholder.hidden = count == 0?NO:YES;
    
    NSMutableAttributedString *attrStrM = [NSMutableAttributedString new];
    NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString:@"亲爱的会员，您共有" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[Util rgbColor:"818181"]}];
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[Util rgbColor:"e06b6d"]}];
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"张%@优惠券", _couponType ==0?@"未用":(_couponType == 1?@"已用":@"过期")] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[Util rgbColor:"818181"]}];
    
    [attrStrM appendAttributedString:attrStr0];
    [attrStrM appendAttributedString:attrStr1];
    [attrStrM appendAttributedString:attrStr2];
    
    [attrStr0 release];
    [attrStr1 release];
    [attrStr2 release];
    self.couponSummaryLabel.attributedText = attrStrM;
    [attrStrM release];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *merchant = (UILabel *)[[cell.contentView viewWithTag:1] viewWithTag:11];
    UILabel *money = (UILabel *)[[cell.contentView viewWithTag:1] viewWithTag:2];
    UILabel *code = (UILabel *)[[cell.contentView viewWithTag:1] viewWithTag:3];
    UILabel *desc = (UILabel *)(((UIView *)(cell.contentView.subviews[2])).subviews[3]);
    UILabel *requireMinimum = (UILabel *)[[cell.contentView viewWithTag:1] viewWithTag:4];
    
    merchant.text = APP_DELEGATE.merchantInfo[@"name"];
//    UILabel *begin = (UILabel *)[[cell.contentView viewWithTag:1] viewWithTag:6];
    
//    UILabel *expire = (UILabel *)[[cell.contentView viewWithTag:1] viewWithTag:8];
    UILabel *expire = (UILabel *)([(UIView *)(cell.contentView.subviews[2]) viewWithTag:8]);

    expire.textColor = [UIColor redColor];
    money.text = [NSString stringWithFormat:@"%@",self.coupons[indexPath.row][@"money"]];
    code.text = [NSString stringWithFormat:@"%@",self.coupons[indexPath.row][@"id"]];
    desc.text = [NSString stringWithFormat:@"%@",self.coupons[indexPath.row][@"explanation"]];
    requireMinimum.text = [NSString stringWithFormat:@"订单满%@元（不包含邮费）",self.coupons[indexPath.row][@"consumption"]];
    NSDate *date = nil;
    date = [NSDate dateWithTimeIntervalSince1970:[self.coupons[indexPath.row][@"endDate"] longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    expire.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];

    
//    date = [NSDate dateWithTimeIntervalSince1970:[self.coupons[indexPath.row][@"startDate"] longLongValue]/1000];
//    begin.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    [formatter release];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)onActivatingCoupon:(UIButton *)sender
{
    ActivateCouponViewController *acvc = [ActivateCouponViewController new];
    [self.navigationController pushViewController:acvc animated:YES];
//    [self.navigationItem.backBarButtonItem setTitle:NSLocalizedString(@"返回", @"")];
    [acvc release];
}

- (void)highlightButton:(UIButton *)sender{
    for(int i=1;i<4;i++){
        UIButton *btn = (UIButton *)[sender.superview viewWithTag:i];
        if(btn.tag != sender.tag){
            [btn setBackgroundImage:[UIImage imageNamed:@"1-03discount coupon_filter bar"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"1-03discount coupon_filter bar_selected"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)onClickUnusedCoupon:(UIButton *)sender {
    [self highlightButton:sender];
    _couponType = 0;
    [self requestDataByCouponType:0];
}

- (IBAction)onClickUsedCoupon:(UIButton *)sender {
    [self highlightButton:sender];
    _couponType = 1;
    [self requestDataByCouponType:1];
}

- (IBAction)onClickOutdatedCoupon:(UIButton *)sender {
    [self highlightButton:sender];
    _couponType = 2;
    [self requestDataByCouponType:2];
}
- (void)dealloc {
//    [_priceLabel release];
//    [_couponCodeLabel release];
//    [_couponRequirementLabel release];
//    [_couponExpireDateLabel release];
//    [_couponScopeLabel release];
    [_couponSummaryLabel release];
    [_tablePlaceholder release];
    [super dealloc];
}
@end
