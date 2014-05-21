//
//  BuyProductViewController.h
//  huyihui
//
//  Created by zaczh on 14-3-10.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductConstants.h"
#import "HuEasyShoppingCart.h"
#import "ZacFloatInputView.h"
#import "ZacNoticeView.h"

@interface BuyProductViewController : BaseViewController<UICollectionViewDataSource ,UICollectionViewDelegate, UITextFieldDelegate>

@property(nonatomic, readonly) HuEasyProductType productType;//商品类别（团购商品，秒杀商品，普通商品）

@property(assign,nonatomic)BOOL buyNow;


/*以下三个信息调用接口时用到*/
//@property (copy, nonatomic) NSString *supplierId;
//@property (copy, nonatomic) NSString *categoryId;
//@property (copy, nonatomic) NSString *productId;

@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet UIButton *addToCartOrBuyNow;
//
//@property (retain, nonatomic) IBOutlet UITextField *textField;
//
//@property (retain, nonatomic) IBOutlet UIButton *incBtn;
//@property (retain, nonatomic) IBOutlet UIButton *decBtn;
- (IBAction)onAddProductToCart:(UIButton *)sender;

- (id)initWithProductType:(HuEasyProductType)type;

- (id)initWithProductInfo:(NSDictionary *)info andType:(HuEasyProductType)type;
@end
