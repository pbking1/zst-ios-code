//
//  huyihuiTests.m
//  huyihuiTests
//
//  Created by linyi on 14-2-19.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HuEasyShoppingCart.h"
#import "LoginViewController.h"

@interface huyihuiTests : XCTestCase

@end

@implementation huyihuiTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testLogin
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:@"lisi" forKey:@"userName"];
    [param setObject:@"lisfi" forKey:@"passWord"];
    id res = [RemoteManager PostTest:kLogin Parameters:param];
    
    XCTAssertTrue(res != nil, @"can't connect to server");
    XCTAssertTrue([res isKindOfClass:[NSDictionary class]], @"login failed, result: %@",res);

}

- (void)testShoppintCart
{
    /*
    id	String	购物车id not required
    specificationId	String	商品类别id
    speciesId	String	商品id
    sku	String	货号
    prodName	String	商品名称
    prodSpec	String	商品规格属性(每个属性之间用空格分开)
    prodNumber	String	购买数量
    retailPrice	double	市场价
    specialPrice	double	销售价
    point	int	赠送积分
    picturePath	String	商品图片
    picturePathWifi	String	商品图片（wifi） not required
    plu	String	商品编码
    userKo	String	会员id
    weight	double	商品重量
    limitNum	int	个人限购数量（仅限团购秒杀使用） not required
    teamFlag	String	是否团购商品标识（0，普通商品；1，团购，2，秒杀）
     */
}

@end
