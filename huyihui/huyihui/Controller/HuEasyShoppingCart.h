//
//  HuEasyShoppingCart.h
//  huyihui
//
//  Created by zaczh on 14-3-27.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    购物车对象
    用户登录前，购物车只保存在本地；
    用户登录后，所有操作均同步到服务器
 */

/*
 1.1.17	CartWareInfo对象
 
 参数名称	类型	说明
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

@interface HuEasyShoppingCart : NSObject

+(instancetype)sharedInstance;

@property (readonly, nonatomic) NSArray *items;
@property (readonly, nonatomic) NSArray *mutableItems;

- (void)addItem:(NSDictionary *)item success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;

- (void)addItems:(NSArray *)items completion:(void (^)(NSError *error))completionBlock;

- (void)removeItemBySpeciesId:(NSString *)speciesId
                       andSku:(NSString *)sku
                      success:(void (^)())successBlock
                      failure:(void (^)())failureBlock;

- (void)removeItems:(NSArray *)items completion:(void (^)(NSError *error))completionBlock;

//- (void)removeAllItems;

- (void)updateQuantityOfSpeciesId:(NSString *)speciesId
                           andSku:(NSString *)sku
                         quantity:(NSInteger)quantity
                          success:(void (^)())successBlock
                          failure:(void (^)())failureBlock;

//同步购物车，登录时调用 合并服务器和本地的购物车
- (void)syncCompletion:(void(^)())completionBlock;

//清空购物车，退出登录时调用
- (void)clearAfterLogoutCompletion:(void(^)())completionBlock;

//提交订单后，从服务器获取购物车物品
- (void)pullCompletion:(void(^)())completionBlock;
@end
