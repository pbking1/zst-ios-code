//
//  HuEasyOrder.h
//  huyihui
//
//  Created by John Zhang on 4/12/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuEasyOrder : NSObject

//促销信息
@property (copy, nonatomic) NSString *promDes;
    
//****************以下为接口需要用到的字段*****************

//	String	商品信息 注：普通商品拼入此对象中（参数构造方式在对象后面）
@property (copy, nonatomic) NSString *wareInfos;

//	String	商品信息 注：团购秒杀商品拼入此对象中（参数构造方式在对象后面）
@property (copy, nonatomic) NSString *wareInfosTuan;

//收货地址编号
@property (copy, nonatomic) NSString *deliveryId;

//	int	商品数量
@property (copy, nonatomic) NSNumber *wareNum;

//	int	赠送积分（默认值为0）
@property (copy, nonatomic) NSNumber *point;

//	double	满减优惠
@property (copy, nonatomic) NSNumber *specialTrans;

//	double	运费
@property (copy, nonatomic) NSNumber *deliveryPay;

//	double	普通商品总金额（如满减优惠等之前的商品优惠总金额）
@property (copy, nonatomic) NSNumber *totalPrice;

//	double	团购秒杀商品总金额
@property (copy, nonatomic) NSNumber *totalPriceTuan;

//	double	金额总计（应支付金额总计）
@property (copy, nonatomic) NSNumber *paymentTotalPrice;

//支付方式：0 支付宝 1 翼支付
@property (copy, nonatomic) NSNumber *payMethod;

//支付银行
@property (copy, nonatomic) NSString *payBank;

//	String	配送方式 1--快递 2--EMS
@property (copy, nonatomic) NSString *deliveryOption;

@property (copy, nonatomic) NSString *deliveryCity;

@property (copy, nonatomic) NSString *deliveryAddress;

//	String	配送时间
//1:只工作日送货(双休日、假日不用送)2:只双休日,假日送货(工作日不用送)
//3: 工作日、双休日与假日均可送货)
@property (copy, nonatomic) NSString *deliveryTime;

//收货人姓名
@property (copy, nonatomic) NSString *deliveryName;

//收货人联系方式
@property (copy, nonatomic) NSString *deliveryMobile;

//买家留言
@property (copy, nonatomic) NSString *remark;

//	String	是否需要发票 0--否 1--是
@property (copy, nonatomic) NSString *isBilling;

//	String	发票抬头（可为空）
@property (copy, nonatomic) NSString *billingTitle;

//	int	订单类型(默认值0)
@property (copy, nonatomic) NSNumber *orderType;

//	String	用来接收订单下单、支付、发货提醒邮件，及时了解订单状态
@property (copy, nonatomic) NSString *orderEmail;

//收货人地址省Id（使用新地址为必填）
@property (copy, nonatomic) NSNumber *selectProvince;

@property (copy, nonatomic) NSNumber *selectCity;

@property (copy, nonatomic) NSNumber *selectArea;

//收货人地址省名称（使用新地址为必填）
@property (copy, nonatomic) NSString *selectProvinceStr;

@property (copy, nonatomic) NSString *selectCityStr;

@property (copy, nonatomic) NSString *selectAreaStr;

//	double	打折金额
@property (copy, nonatomic) NSNumber *discountPrice;

//	String	简易促销方案：是否打折 Y为是,N为否
@property (copy, nonatomic) NSString *isCurrentDiscount;

//	String	简易促销方案：是否免运费 Y为是,N为否
@property (copy, nonatomic) NSString *isCurrentFreeDelivery;

//	String	促销方案（默认值为：auto）
@property (copy, nonatomic) NSString *groupId;

//使用优惠券ID
@property (copy, nonatomic) NSString *couponId;

//	String	结算商品（构造方式：商品id，货号；商品id，货号；）
@property (copy, nonatomic) NSString *cartWareInfos;

//*********以下为实例方法
//从外部数据载入参数值
- (void)loadDataFromDictionary:(NSDictionary *)dict;

//将所有参数合并为一个字典（用于网络请求）
- (NSDictionary *)toDictionary;

- (id)objectForKey:(id)key;

- (void)setObject:(id)object forKey:(id)aKey;
@end
