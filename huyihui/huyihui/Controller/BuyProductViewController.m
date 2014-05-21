//
//  BuyProductViewController.m
//  huyihui
//
//  Created by zaczh on 14-3-10.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BuyProductViewController.h"
#import "CheckOutCenterViewController.h"

@interface BuyProductViewController ()

@property (copy, nonatomic) NSDictionary *productInfo;

@property (copy, nonatomic) NSArray *productAttributes;//商品属性

@property (retain,nonatomic) NSMutableDictionary *speciesBaseDic;

@property (copy, nonatomic) NSDictionary *individualAttributes;//个体属性

@property (assign, nonatomic) NSInteger quantity;//购买数量

@property (assign, nonatomic) NSInteger stock;//库存数量

@end

@implementation BuyProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _quantity = 1;
    }
    return self;
}

- (id)initWithProductType:(HuEasyProductType)type{
    self = [super init];
    if(self){
        _productType = type;
    }
    return self;
}

- (id)initWithProductInfo:(NSDictionary *)info andType:(HuEasyProductType)type
{
    self = [super init];
    if(self){
        _productType = type;
        _productInfo = [info copy];
    }
    return self;
}

static NSString *collectionCellIdentifier = @"collectionCell";
static NSString *collectionCellHeader0 = @"collectionCellHeader0";
static NSString *collectionCellHeader1 = @"collectionCellHeader1";
static NSString *collectionCellHeader2 = @"collectionCellHeader2";
static NSString *collectionCellFooter = @"collectionCellFooter";
//static NSString *collectionCellSeperator = @"collectionCellSeperator";
//static NSString *collectionLastCell= @"collectionLastCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.productInfo = APP_DELEGATE.tempParam;
//    self.productAttributes = self.productInfo[@"product"][0][@"attributes"];
//    self.productId = self.productInfo[@"speciesId"];
//    self.categoryId = self.productInfo[@"specificationId"];
//    self.supplierId = APP_DELEGATE.merchantId;
    //        self.productId = @"W60E4B02";
    //        self.categoryId = @"S5F5E101";
    //        self.supplierId = @"13040811180531200001";
//    [APP_DELEGATE.tempParam removeAllObjects];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
//    [self.collectionView addGestureRecognizer:tap];
//    tap.cancelsTouchesInView = NO;
//    [tap release];
    
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
    if (_buyNow)
    {
        [_addToCartOrBuyNow setTitle:@"确认购买" forState:UIControlStateNormal];
    }
    else
    {
        [_addToCartOrBuyNow setTitle:@"加入购物车" forState:UIControlStateNormal];
        
    }
    
    self.collectionView.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BuyProductViewAttributeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:collectionCellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BuyProductCollectionViewHeader0" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellHeader0];

    [self.collectionView registerNib:[UINib nibWithNibName:@"BuyProductCollectionViewHeader1" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellHeader1];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BuyProductCollectionViewHeader2" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionCellHeader2];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BuyProductCollectionViewFooter" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collectionCellFooter];
    
    [self getProductInfoAndShow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.collectionView = nil;
    [_addToCartOrBuyNow release];
    [super dealloc];
}

#pragma mark - collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //增加一个头和一个尾
    return self.productAttributes.count + 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0 || section == self.productAttributes.count + 1){
        return 0;
    }else{
        return [[self.productAttributes[section - 1] objectForKey:@"attributes"] count];
//        return self.productAttributes.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = nil;
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0){
            cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionCellHeader0 forIndexPath:indexPath];
            
            UIImageView *productImage = (UIImageView *)[cell viewWithTag:1];
            UILabel *title = (UILabel *)[cell viewWithTag:2];
            UILabel *price  = (UILabel *)[cell viewWithTag:5];
            
            
//            NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSERVER,self.productInfo[@"imgUrl"]];
            if (self.speciesBaseDic[@"product"]&&![self.speciesBaseDic[@"product"]isEqual:[NSNull null]])
            {
                if ([self.speciesBaseDic[@"product"]count]>0)
                {
                    if (self.speciesBaseDic[@"product"][0][@"speciesMedia"])
                    {
                        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,self.speciesBaseDic[@"product"][0][@"speciesMedia"][0][@"mediaPath"]];
                        NSLog(@"mediaPath is :%@",urlStr);
                        NSURL *url = [NSURL URLWithString:urlStr];
                        [Util UIImageFromURL:url withImageBlock:^(UIImage *image) {
                            if (image)
                            {
                                productImage.image = image;
                            }
                            else
                            {
                                productImage.image=[UIImage imageNamed:@"4-01defaultImage"];
                            }
                            
                        } errorBlock:nil];
                    }
                    else
                    {
                        productImage.image=[UIImage imageNamed:@"4-01defaultImage"];
                        
                    }
                    
                    
                    price.text = [NSString stringWithFormat:@"%@", self.speciesBaseDic[@"product"][0][@"salePrice"]];
                }
               
            }
            else
            {
                 price.text =@"0";
                
            }
           
            
   //         title.text = self.productInfo[@"description"];
//            
//            price.text = [NSString stringWithFormat:@"%@", self.productInfo[@"minSalePrice"]];
            title.text = self.speciesBaseDic[@"prodName"];
            
            
            
            
        }else if(indexPath.section == self.productAttributes.count + 1){
            cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionCellHeader2 forIndexPath:indexPath];
            
            if(self.stock>0){
                [cell.subviews[4] setHidden:YES];
            }else{
                [cell.subviews[4] setHidden:NO];
            }
            
            UITextField *textField = (UITextField *)[cell viewWithTag:3];
            textField.delegate = self;
            
            UILabel *numberLabel=(UILabel *)[cell viewWithTag:6];
            
            numberLabel.text=[NSString stringWithFormat:@"库存：%d件",self.stock];
        }else{
            cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionCellHeader1 forIndexPath:indexPath];
            
            UILabel *label = (UILabel *)[cell viewWithTag:123];
            label.text = [self.productAttributes[indexPath.section - 1] objectForKey:@"display"];
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionCellFooter forIndexPath:indexPath];
    }
    return cell;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];

    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = [UIImage imageNamed:@"2-05purchasing choice_ style normal"];
    cell.backgroundView = backView;
    [backView release];
    
    UIImageView *selectedBackView = [[UIImageView alloc] init];
    selectedBackView.image = [UIImage imageNamed:@"2-05purchasing choice_ style push"];
    cell.selectedBackgroundView = selectedBackView;
    [selectedBackView release];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
//    UILabel *label = [UILabel new];
//    label.font = [UIFont systemFontOfSize:14];
//    label.textAlignment = NSTextAlignmentCenter;
    label.text = [[[self.productAttributes[indexPath.section - 1] objectForKey:@"attributes"] objectAtIndex:indexPath.row] objectForKey:@"value"];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    [cell.contentView addSubview:label];
//    
//    [cell.contentView addConstraints:@[
//        [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
//        [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0],
//        [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
//        [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
//    ]];
//    
//    
//    [label release];

    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //allow only one cell of a secion to be selected at the same time
    
    NSArray *selectedIndexes = [collectionView indexPathsForSelectedItems];
    [selectedIndexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([(NSIndexPath *)obj section] == indexPath.section){
            [collectionView deselectItemAtIndexPath:obj animated:NO];
            *stop = YES;
            
        }
    }];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:selectedIndexes];
    for (int i=0; i<[arr count]; i++)
    {
        if ([[arr objectAtIndex:i] section] == indexPath.section)
        {
            [arr replaceObjectAtIndex:i withObject:indexPath];
        }
    }
    
    [self updateProductInfoAndShow:arr];
    [arr release];
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGSizeMake(SCREEN_WIDTH, 121);
    }else if (section == self.productAttributes.count + 1)
    {
        return CGSizeMake(SCREEN_WIDTH, 69);
    }
    else{
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if(section == 0 || section == self.productAttributes.count + 1){
        return CGSizeZero;
    }else{
        return CGSizeMake(SCREEN_WIDTH, 16);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[[self.productAttributes[indexPath.section - 1] objectForKey:@"attributes"] objectAtIndex:indexPath.row] objectForKey:@"value"];
    if(indexPath.section > 0 && indexPath.section < self.productAttributes.count + 1){
//        NSLog(@"%@",text);
    }
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(INT_MAX, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    size.width += 16;
    size.height += 16;
    return size;
}

- (void)selectDefault{
    for(int section = 1; section < self.productAttributes.count + 1; section++){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - keyboard relates

//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//
//- (void)onTap:(UIGestureRecognizer *)gesture{
//    [self becomeFirstResponder];
//}


#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    ZacFloatInputView *floatView = [[ZacFloatInputView alloc] initWithTitle:@"请输入数量："
//                                                               initialValue:textField.text
//                                                                   maxValue:@"10000"
//                                                                 completion:^(NSString *text){
//        textField.text = text;
//    }];
//    [floatView show];
//    [floatView release];
    ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"修改数量" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"完成" cancelBlock:nil otherBlock:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    alert.otherBlock = ^{
        NSInteger count = [[[alert textFieldAtIndex:0] text] integerValue];
        if(count < 1){
            count = 1;
        }
        if(count>self.stock){
            [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:@"修改商品数量失败，超出库存上限" duration:1.5];
            return;
        }
        textField.text = [NSString stringWithFormat:@"%d",count];
        self.quantity = count;
    };
    [alert show];
    [alert release];
    
    return NO;
}

#pragma mark - 接口调用
- (void)getProductInfoAndShow{
    [self requestFilterProductByAttributes:nil completion:^(NSDictionary *json){
        self.productAttributes = json[@"unitAllColumnList"];
        self.speciesBaseDic=json[@"speciesBase"];
        if(_productType != HuEasyProductTypeOrdinary){
            self.stock = [json[@"speciesBase"][@"product"][0][@"stockTotal"] integerValue];
        }else{
            self.stock = [json[@"speciesBase"][@"product"][0][@"amount"] integerValue];
        }
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        [self selectDefault];
    }];
}

// 20140507-yangyy 新增更新库存和价格
- (void) updateProductInfoAndShow : (NSArray *)selectedIndexes
{
    NSMutableString *attrs = [NSMutableString new];
    NSMutableArray *attrArr = [NSMutableArray new];
    //for(NSIndexPath *indexpath in self.collectionView.indexPathsForSelectedItems){
    for(NSIndexPath *indexpath in selectedIndexes){
        NSString *attrName = self.productAttributes[indexpath.section - 1][@"columnName"];
        NSString *selectedValue = self.productAttributes[indexpath.section - 1][@"attributes"][indexpath.row][@"value"];
        [attrs appendString:[NSString stringWithFormat:@"%@_zh:%@,",attrName,selectedValue]];
        [attrArr addObject:selectedValue];
    }
    
    [self requestFilterProductByAttributes:attrs completion:^(NSDictionary *json){
        self.speciesBaseDic=[json[@"speciesBase"]copy];
        self.productAttributes = json[@"unitAllColumnList"];
        if(_productType != HuEasyProductTypeOrdinary){
            if (json[@"speciesBase"][@"product"]&&![json[@"speciesBase"][@"product"]isEqual:[NSNull null]])
            {
                self.stock = [json[@"speciesBase"][@"product"][0][@"stockTotal"] integerValue];
            }
            else{
                self.stock=0;
            }
            
        }else{
            if (json[@"speciesBase"][@"product"]&&![json[@"speciesBase"][@"product"]isEqual:[NSNull null]])
            {
            self.stock = [json[@"speciesBase"][@"product"][0][@"amount"] integerValue];
            }
            else{
                self.stock=0;
            }
            
        }
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        for (int i=0; i<[selectedIndexes count]; i++)
        {
            NSIndexPath *index = [selectedIndexes objectAtIndex:i];
            
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index.row inSection:index.section] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }];
}

- (void)requestFilterProductByAttributes:(NSString *) attr completion:(void (^)(NSDictionary *))completionBlock
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:self.productInfo[@"specificationId"] forKey:@"specificationId"];
    [param setObject:self.productInfo[@"speciesId"]forKey:@"speciesId"];
    [param setValue:attr forKey:@"conditions"];//can be nil
    
    [RemoteManager Posts:kGET_PRODUCT_DETAIL_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                if(completionBlock != NULL){
                    completionBlock(json);
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


- (void)onIncreaseQuantity:(UIButton *)sender{
    UITextField *textField = (UITextField *)[sender.superview viewWithTag:3];
    UIButton *decBtn = (UIButton *)[sender.superview viewWithTag:2];
    NSInteger quantity = [textField.text integerValue] + 1;
    
    if(quantity>self.stock){
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:@"修改商品数量失败，超出库存上限" duration:1.5];
        return;
    }
    
    textField.text = [NSString stringWithFormat:@"%ld",(long)quantity];
    if(!decBtn.enabled){
        decBtn.enabled = YES;
    }
    self.quantity = quantity;
}

- (void)onDecreaseQuantity:(UIButton *)sender{
    UITextField *textField = (UITextField *)[sender.superview viewWithTag:3];

    NSInteger quantity = [textField.text integerValue];
    quantity = quantity>2?quantity-1:1;
    if(quantity == 1){
        sender.enabled = NO;
    }
    textField.text = [NSString stringWithFormat:@"%ld",(long)quantity];
    self.quantity = quantity;
}

- (IBAction)onAddProductToCart:(UIButton *)sender{
    
    
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
    
    if(self.stock == 0){
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:@"添加失败，商品已无库存" duration:1.0];
        return;
    }
    
    //选择个体
    NSMutableString *attrs = [NSMutableString new];
    NSMutableArray *attrArr = [NSMutableArray new];
    for(NSIndexPath *indexpath in self.collectionView.indexPathsForSelectedItems){
        NSString *attrName = self.productAttributes[indexpath.section - 1][@"columnName"];
        NSString *selectedValue = self.productAttributes[indexpath.section - 1][@"attributes"][indexpath.row][@"value"];
        [attrs appendString:[NSString stringWithFormat:@"%@_zh:%@,",attrName,selectedValue]];
        [attrArr addObject:selectedValue];
    }
//    NSLog(@"%@",attrs);
    [self requestFilterProductByAttributes:attrs completion:^(NSDictionary *json){
        self.productAttributes = json[@"unitAllColumnList"];
    }];
  // self.individualAttributes = self.productInfo[@"product"][0];
//    NSLog(@"filtered product info: %@", self.individualAttributes);
    self.individualAttributes = self.speciesBaseDic[@"product"][0];
    
    NSDictionary *cartWareInfoList = @{
                           @"specificationId":self.productInfo[@"specificationId"],
                           @"speciesId":self.productInfo[@"speciesId"],
                           @"sku":self.individualAttributes[@"prodNum"],
                           @"prodName":self.productInfo[@"prodName"],
                           @"prodSpec":[attrArr componentsJoinedByString:@","],
                           @"prodNumber" :[NSNumber numberWithInteger:self.quantity],
                           @"retailPrice":self.individualAttributes[@"retailPrice"],
                           @"specialPrice" :self.individualAttributes[@"salePrice"],
                           //TODO:等待服务器修复此bug
                           //@"point" :self.productInfo[@"score"],
                           @"point" :[NSNumber numberWithInt:0],
                           @"picturePath" :self.productInfo[@"mediaPath"],
                           @"picturePathWifi" :self.productInfo[@"mediaPathWifi"],
                           @"plu" :self.productInfo[@"plu"],
//                           @"userKo" :[NUSD objectForKey:kCurrentUserId],
                           @"weight" :self.productInfo[@"weight"],
                           @"limitNum" :self.individualAttributes[@"limitNum"],
                           @"teamFlag" :[NSString stringWithFormat:@"%d",_productType]
                           };
   
    if (_buyNow)  //立即购买
    {
        [CustomBezelActivityView activityViewForView:self.view withLabel:nil];
        [[HuEasyShoppingCart sharedInstance] addItem:cartWareInfoList success:^{
            [CustomBezelActivityView removeViewAnimated:NO];
            if (APP_DELEGATE.isLoggedIn)
            {
                NSArray *productArr=[[HuEasyShoppingCart sharedInstance]mutableItems];
                for (NSDictionary *dic in productArr)
                {
                    NSLog(@"prodNum is:%@",self.speciesBaseDic[@"product"][0][@"prodNum"]);
                    if([dic[@"speciesId"]isEqualToString:self.productInfo[@"speciesId"]]
                       &&[dic[@"sku"]isEqualToString:self.speciesBaseDic[@"product"][0][@"prodNum"]])
                    {
                        NSArray *arr=[NSArray arrayWithObject:dic];
                        CheckOutCenterViewController *checkOutCenter=[[CheckOutCenterViewController alloc]initWithProducts:arr];
                        
                        
                        checkOutCenter.hidesBottomBarWhenPushed=YES;
                        checkOutCenter.title=@"结算中心";
                        [self.navigationController pushViewController:checkOutCenter animated:YES];
                        [checkOutCenter release];
                        
                    }
                }
                
            }
            else
            {
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"用户没有登陆，请登陆后再购买" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelBlock:^{
                    //                [self.navigationController popViewControllerAnimated:YES];
                } otherBlock:^{
                    LoginViewController *loginViewCtrl=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                    loginViewCtrl.successBlock = ^{
                        // [self refreshView];
                    };
                    
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginViewCtrl];
                    
                    
                    [self presentViewController:nav animated:YES completion:nil];
                    [loginViewCtrl release];
                    [nav release];
                    
                }];
                [alert show];
                [alert release];
                
                
            }

        } failure:^{
            [CustomBezelActivityView removeViewAnimated:NO];
//            [ZacNoticeView showAtYPosition:SCREEN_HEIGHT - 100 type:1 text:@"添加商品到购物车失败" duration:1.0];
        }];
        
    }
    else      //加入购物车
    {

    
    [CustomBezelActivityView activityViewForView:self.view withLabel:nil];
    [[HuEasyShoppingCart sharedInstance] addItem:cartWareInfoList success:^{
        [CustomBezelActivityView removeViewAnimated:NO];
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"商品已成功添加到购物车" cancelButtonTitle:@"继续购物" otherButtonTitle:@"查看购物车" cancelBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } otherBlock:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            APP_DELEGATE.tabs.selectedIndex = 2;
        }];
        [alert show];
        [alert release];
    } failure:^{
        [CustomBezelActivityView removeViewAnimated:NO];
        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT - 100 type:1 text:@"添加商品到购物车失败" duration:1.0];
    }];
  
    }
    [attrArr release];
    [attrs release];
    
    
}
@end
