//
//  GroupBuyItemDetailViewController.m
//  huyihui
//
//  Created by zaczh on 14-3-5.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "GroupBuyItemDetailViewController.h"
#import "BuyProductViewController.h"
#import "ZacAlertView.h"
#import "LoginViewController.h"

#define PAGE_COMMENTS_COUNT 4 //每页显示评论数量

@interface GroupBuyItemDetailViewController ()
{
    NSDictionary *productInfo;//普通商品和团秒商品共用
    
    NSDictionary *tuanProductInfo;
    
    NSArray *ordinaryProdcutComments;//普通商品需要显示评论
    NSArray *ordinaryProductAttributes;//普通商品参数信息
    NSInteger commentPage;
    
    NSArray *cells;

    NSMutableIndexSet *expandStatus;//cell展开状态

    NSInteger sellingState;//表示销售状态,0：尚未开始，1:正在进行；2:已经结束

    NSInteger saleType;//表示促销类型,0为最惠团,1为限时抢购(秒杀)
    
    BOOL productHasDifferentTypes;//商品是否存在个体差异，如果没有，可以直接购买，否则需要在下一个页面选择某个个体；
    
    /*以下信息调用接口时用到*/
    NSString *supplierId;//商家ID
    NSString *categoryId;//商品类别ID
    NSString *productId;//商品ID
    NSString *sku;
    NSString *digestId;//团购秒杀方案ID
    
    BOOL _isCollection; //是否已收藏该商品
    NSString *_myItemId;
}
@end

@implementation GroupBuyItemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _productType = HuEasyProductTypeGroupBuy;
    }
    return self;
}

- (id)initWithProductType:(HuEasyProductType)type
{
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
        productId = [[info objectForKey:@"speciesId"] retain];
        categoryId = [[info objectForKey:@"specificationId"] retain];
        supplierId = [[NUSD objectForKey:kMerchantId] retain];
        digestId = [[info objectForKey:@"digestId"] retain];
        
        if(type != HuEasyProductTypeOrdinary){
            saleType = [[info objectForKey:@"type"] integerValue];
            [self getGroupOrFlashBuyProductInfo];
        }else{
            [self getOrdinaryProductInfo];
        }
    }
    
    return self;
}

static NSString *attrCell = @"OrdinaryProductAttrCell";
static NSString *imageDetailCell = @"OrdinaryProductImageDetailCell";
static NSString *commentCell = @"OrdinaryProductCommentCell";
static NSString *commentExpandCell = @"OrdinaryProductCommentExpandCell";


- (void)viewWillAppear:(BOOL)animated
{
    if (APP_DELEGATE.isLoggedIn)
    {
        [self requestWetherAddToDisire];
    }
    else
    {
        _isCollection = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"商品详情";
    commentPage = 1;
    expandStatus = [NSMutableIndexSet new];
    
    if(_productType == HuEasyProductTypeOrdinary){//普通商品
        cells = [[[NSBundle mainBundle] loadNibNamed:@"OrdinaryProductDetailCell" owner:self options:nil] retain];
        self.bottomView1.hidden = NO;//立即购买和加入购物车两个按钮
        UIButton *buyBtn = (UIButton *)[self.bottomView1 viewWithTag:1];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];//原来的标题是"立即参团",需要更改
        
        [self.table registerNib:[UINib nibWithNibName:attrCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:attrCell];
        [self.table registerNib:[UINib nibWithNibName:imageDetailCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:imageDetailCell];
        [self.table registerNib:[UINib nibWithNibName:commentCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentCell];
        [self.table registerNib:[UINib nibWithNibName:commentExpandCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentExpandCell];
        
    }else{//团购或者秒杀商品
        cells = [[[NSBundle mainBundle] loadNibNamed:@"GroupBuyItemDetailCell" owner:self options:nil] retain];
    }
    
    if (_isCollection)
    {
        [_addToFavouriteBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        [_addToFavouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-20, 15, 0, 0)];
    }
    else
    {
        [_addToFavouriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_addToFavouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
    }
    //TODO:configure the nib files
//#warning Just for test, please remove these later on.
//    self.productId = @"W60E4B02";
//    self.categoryId = @"S5F5E101";
//    self.supplierId = @"13040811180531200001";
//    self.sku = @"";

    
//    NSLog(@"%@",self.cells);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [productInfo release];
    [supplierId release];
    [categoryId release];
    [productId release];
    [sku release];
    [digestId release];
    [expandStatus release];
    [cells release];
    
    [_table release];
    [_bottomView0 release];
    [_bottomView1 release];
    [_bottomView2 release];
    [_prodcutCommentsCountLabel release];
    [_addToFavouriteBtn release];
    [super dealloc];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([expandStatus containsIndex:section]){
        if(_productType != HuEasyProductTypeOrdinary){
            return 1;
        }else if(section == 1){//普通商品需要显示商品参数信息
            if(ordinaryProductAttributes.count == 0)
            {
                return 1;
            }else{
                return ordinaryProductAttributes.count;
            }
        }else if(section == 3){//普通商品需要显示评论
            if(ordinaryProdcutComments.count == 0)
            {
                return 1;
            }
            else
            {
                return ordinaryProdcutComments.count + 1;
            }
        }else{
            return 1;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ((UITableViewCell *)cells[section]).bounds.size.height;
}

static CGFloat commentFontSize = 14;
static CGFloat commentViewWidth = 300;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_productType != HuEasyProductTypeOrdinary){
        return [(UITableViewCell *)cells[indexPath.section + 3] bounds].size.height ;
    }else{
        if(indexPath.section == 1){
            if(ordinaryProductAttributes.count == 0){
                return 40;
            }else{
                return 48;
            }
        }else if (indexPath.section == 2){
            return 100;
        }else{
            if(ordinaryProdcutComments.count == 0){
                return 40;
            }
            else if(indexPath.row < ordinaryProdcutComments.count){
                CGSize contentSize = [ordinaryProdcutComments[indexPath.row][@"content"] sizeWithFont:[UIFont systemFontOfSize:commentFontSize] constrainedToSize:CGSizeMake(commentViewWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                return contentSize.height + 40;
            }else{//“查看更多评论”
                return 40;
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *header = cells[section];
//    if(section == 0){
//        if(self.productType == HuEasyProductTypeOrdinary){
//            UIImageView *bigImageView = (UIImageView *)header.subviews[0];
//            UILabel *descriptionLabel = (UILabel *)header.subviews[1];
//            UILabel *discountLabel = (UILabel *)header.subviews[2];
//            UILabel *oldPriceLabel = (UILabel *)header.subviews[3];
//            UILabel *currentPriceLabel = (UILabel *)header.subviews[4];
//            UIButton *favouriteButton = (UIButton *)header.subviews[5];
//        
//            NSString *urlStr = [NSString stringWithFormat:@"%@ %@", kIMAGE_FILE_SERVER, productInfo[@"mediaPath"]];
//            [Util UIImageFromURL:[NSURL URLWithString:urlStr] withImageBlock:^(UIImage *image) {
//                bigImageView.image = image;
//            } errorBlock:nil];
//            
//            descriptionLabel.text = [NSString stringWithFormat:@"%@%@", productInfo[@"prodName"], productInfo[@"description"]];
//            
//            discountLabel.text = [NSString stringWithFormat:@"%.1f折", [productInfo[@"minSalePrice"] floatValue]/[productInfo[@"minRetailPrice"] floatValue]];
//            
//
//            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", productInfo[@"minRetailPrice"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1.0], NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
//            oldPriceLabel.attributedText = attrStr;
//            [attrStr release];
//            
//            currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", productInfo[@"minSalePrice"]];
//            
//        }else{
//            UIImageView *bigImageView = (UIImageView *)header.subviews[0];
//            UILabel *descriptionLabel = (UILabel *)header.subviews[1];
//            UILabel *timerLabel = (UILabel *)header.subviews[2];
//            UILabel *discountLabel = (UILabel *)header.subviews[4];
//            UILabel *groupBuyInfoLabel = (UILabel *)header.subviews[5];
//            UILabel *oldPriceLabel = (UILabel *)header.subviews[6];
//            UILabel *currentPriceLabel = (UILabel *)header.subviews[8];
//            UIButton *favouriteButton = (UIButton *)header.subviews[9];
//            
//            
//            
//        }
//    }
    return cells[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.productType != HuEasyProductTypeOrdinary){
        return cells[indexPath.section + 3];
    }else{
        UITableViewCell *cell = nil;
        if(indexPath.section == 1){//参数信息
            if(ordinaryProductAttributes.count == 0 ){
                //没有参数信息时要显示提示
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
                
                UILabel *info = [UILabel new];
                info.font = [UIFont systemFontOfSize:14];
                info.textColor = [UIColor colorWithRed:61.0/255 green:66.0/255 blue:69.0/255 alpha:1.0];
                info.text = @"没有参数信息";
                info.backgroundColor = [UIColor clearColor];
                info.translatesAutoresizingMaskIntoConstraints = NO;
                info.preferredMaxLayoutWidth = 300;
                [info setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                [info setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [cell.contentView addSubview:info];
                [info release];
                
                [cell.contentView addConstraints:@[
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
                                                   
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0],
                                                   
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10],
                                                   
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]
                                                   
                                                   ]];
                
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:attrCell];
                
                UILabel *key = (UILabel *)[cell.contentView viewWithTag:21];
                UILabel *value = (UILabel *)[cell.contentView viewWithTag:22];
                
                key.text = ordinaryProductAttributes[indexPath.row][@"display"];
                value.text = ordinaryProductAttributes[indexPath.row][@"attrContent"];
            }
        }else if (indexPath.section == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:imageDetailCell];
//            NSLog(@"image detail: %@",productInfo[@"htmlPath"]);
        }else if (indexPath.section == 3){
            if(ordinaryProdcutComments.count == 0){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
                
                UILabel *info = [UILabel new];
                info.font = [UIFont systemFontOfSize:14];
                info.textColor = [UIColor colorWithRed:61.0/255 green:66.0/255 blue:69.0/255 alpha:1.0];
                info.text = @"暂无评论";
                info.backgroundColor = [UIColor clearColor];
                info.translatesAutoresizingMaskIntoConstraints = NO;
                info.preferredMaxLayoutWidth = 300;
                [info setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                [info setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [cell.contentView addSubview:info];
                [info release];
                
                [cell.contentView addConstraints:@[
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
                                                   
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0],
                                                   
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10],
                                                   
                                                   [NSLayoutConstraint constraintWithItem:info attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]

                ]];
            }else{
                if(indexPath.row < ordinaryProdcutComments.count){
                    cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
                    
                    UILabel *name = (UILabel *)[cell.contentView viewWithTag:1];
                    UIView *score = (UIView *)[cell.contentView viewWithTag:2];
                    UILabel *content = (UILabel *)[cell.contentView viewWithTag:3];
                    
                    name.text = ordinaryProdcutComments[indexPath.row][@"subscriberName"];
                    content.text = ordinaryProdcutComments[indexPath.row][@"content"];
                    
                    int star = [ordinaryProdcutComments[indexPath.row][@"score"] intValue];
                    NSArray *constraints = score.constraints;
                    [constraints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
                        if(constraint.firstItem == score && constraint.firstAttribute == NSLayoutAttributeWidth){
                            constraint.constant = 20.0f*star;
                            *stop = YES;
                        }
                    }];
                    
                }else{
                    cell = [tableView dequeueReusableCellWithIdentifier:commentExpandCell];
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3 &&
       ordinaryProdcutComments.count > 0 &&
       indexPath.row == ordinaryProdcutComments.count){
        [self loadMoreComments];
    }
}

- (void)loadMoreComments{
    [self requestMoreComments];
}

- (IBAction)sectionExpand:(UIButton *)sender{
    UIView *cell = (UITableViewCell *)sender.superview;
    NSInteger index = [cells indexOfObject:cell];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:index];
    if([expandStatus containsIndex:index]){
        [expandStatus removeIndex:index];
        [sender setImage:[UIImage imageNamed:@"list_more_normal"] forState:UIControlStateNormal];
        if(self.productType != HuEasyProductTypeOrdinary){
            [self.table deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{

            [self.table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else{
        [expandStatus addIndex:index];
        [sender setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateNormal];
        if(self.productType != HuEasyProductTypeOrdinary){
            [self.table insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{

            if(indexpath.section == 1){
                if(ordinaryProductAttributes.count == 0){
                    [self.table insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    return;
                }
            }
            else if(indexpath.section == 3){
                if(ordinaryProdcutComments.count == 0){
                    [self.table insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    return;
                }
            }
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

//        [self.table reloadData];
//        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
//    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
//    [self.table reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];

}


- (void)reloadDataAndLayoutView{
    UIView *header0 = cells[0];
    
    UIImageView *headerImage = (UIImageView *)[header0 viewWithTag:1];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[productInfo objectForKey:@"mediaPath"]];
    [Util UIImageFromURL:[NSURL URLWithString:urlStr] withImageBlock:^(UIImage *image) {
        if(image){
        headerImage.image = image;
        }
    } errorBlock:nil];
    
//#ifdef DEBUG
//    headerImage.image = [UIImage imageNamed:@"2-04Public Const LangProducts_Material picture of the top"];
//#endif
    
    UILabel *desc = (UILabel *)[header0 viewWithTag:2];
    desc.text = [productInfo objectForKey:@"prodName"];
    
    double currentPrice = .0f, oldPrice = .0f;
    CGSize fitSize = CGSizeZero;
    if(_productType != HuEasyProductTypeOrdinary){
        currentPrice =[tuanProductInfo[@"teamPrice"] doubleValue];
        oldPrice =[tuanProductInfo[@"retailPrice"] doubleValue];
        
        TimerLabel *timerLabel = (TimerLabel *)[header0 viewWithTag:5];
        double startTime = [[tuanProductInfo objectForKey:@"startDate"] doubleValue];
        double endTime = [[tuanProductInfo objectForKey:@"endDate"] doubleValue];
        long beginInterval = startTime - [[NSDate date] timeIntervalSince1970]*1000;
        long endInterval = endTime - [[NSDate date] timeIntervalSince1970]*1000;
        [timerLabel setBeginTime:startTime];
        [timerLabel setEndTime:endTime];
        if(beginInterval > 0){//尚未开始
            sellingState = 0;
        }else if(endInterval > 0){//正在进行中
            sellingState = 1;
        }else{//已经结束
            sellingState = 2;
        }
        
        [self updateViewBySellingState];
        
        
        UILabel *stock = (UILabel *)[header0 viewWithTag:10];
        stock.text = [NSString stringWithFormat:@"剩余%lld件，每个ID限购%lld件",
                      [tuanProductInfo[@"stockTotal"] longLongValue],
                      [tuanProductInfo[@"limitNum"] longLongValue]];

        UITableViewCell *cell = cells[4];
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:21];
        label.text = [NSString stringWithFormat:@"%@", tuanProductInfo[@"shopTip"]];
        //    label.text = @"大众汽车集团近日公布2013财年收入情况，当年实现销售收入1，970亿欧元，营业利润实现创纪录的117亿欧元，其中在华两家合资企业全年销售327万辆，营业利润上升至43亿欧元，同比增长16%。掐指一算，大众在华利润占到全球的36.75%！营业利润实现创纪录的营业利润实现创纪录的";
        fitSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, INT_MAX) lineBreakMode:label.lineBreakMode];
        cell.frame = CGRectMake(0, 0, fitSize.width, fitSize.height + 32);
        
        UITableViewCell *productDetailDescCell = cells[5];
        UIView *containerView = productDetailDescCell.contentView;
        
        CGFloat height = .0f;
        UILabel *productLabel0 = [UILabel new];
        productLabel0.backgroundColor = [UIColor clearColor];
        productLabel0.numberOfLines = 0;
        productLabel0.lineBreakMode = NSLineBreakByWordWrapping;
        productLabel0.translatesAutoresizingMaskIntoConstraints = NO;
        productLabel0.font = [UIFont systemFontOfSize:14];
        productLabel0.text = tuanProductInfo[@"groupDetail"];
//        productLabel0.text = @"1-02最惠团 搜索1-02最惠团 搜索1-02最惠团 搜索1-02最惠团 搜索1-02最惠团 搜索1-02最惠团 搜索1-02最惠团 搜索";
        fitSize = [productLabel0.text sizeWithFont:productLabel0.font constrainedToSize:CGSizeMake(300, INT_MAX) lineBreakMode:productLabel0.lineBreakMode];
        productLabel0.preferredMaxLayoutWidth = 300;
        [productLabel0 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [productLabel0 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [containerView addSubview:productLabel0];
        height += fitSize.height;//after test using xib i found that
        //a label with 14 point font size has a natural height of 17
        [containerView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:productLabel0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
                                        [NSLayoutConstraint constraintWithItem:productLabel0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0],
                                        [NSLayoutConstraint constraintWithItem:productLabel0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]
                                        ]];
#if 0
        UIImage *image0 = [UIImage imageNamed:@"1-02最惠团 搜索"];
        UIImageView *productImage0 = [[UIImageView alloc] initWithImage:image0];
        if(image0.size.height>0){
            height += 10 + image0.size.height;
        }
        productImage0.backgroundColor = [UIColor greenColor];
        productImage0.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:productImage0];
        [containerView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:productImage0 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
                                        [NSLayoutConstraint constraintWithItem:productImage0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:productLabel0 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0],
                                        [NSLayoutConstraint constraintWithItem:productImage0 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]
                                        ]];
        
        
        UIImage *image1 = [UIImage imageNamed:@"1-02最惠团单品页详细内容"];
        UIImageView *productImage1 = [[UIImageView alloc] initWithImage:image1];
        if(image1.size.height > 0){
            height += 10 + image1.size.height;
        }
        productImage1.backgroundColor = [UIColor greenColor];
        productImage1.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:productImage1];
        [containerView addConstraints:@[
                                        [NSLayoutConstraint constraintWithItem:productImage1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
                                        [NSLayoutConstraint constraintWithItem:productImage1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:productImage0 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0],
                                        [NSLayoutConstraint constraintWithItem:productImage1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10.0]
                                        ]];
        
        [productImage0 release];
        [productImage1 release];

#endif
        height += 16;
        productDetailDescCell.frame = CGRectMake(0, 0, productDetailDescCell.frame.size.width, height);
        
        [productLabel0 release];
        
    }else{
        currentPrice = [productInfo[@"minSalePrice"] doubleValue];
        oldPrice = [productInfo[@"minRetailPrice"] doubleValue];
        [self.table reloadData];
    }
    

    UILabel *price = (UILabel *)[header0 viewWithTag:6];
    price.text = [NSString stringWithFormat:@"￥%.1f",currentPrice];
    
    UILabel *oldPriceLabel = (UILabel *)[header0 viewWithTag:8];
    oldPriceLabel.text = [NSString stringWithFormat:@"￥%.1f",oldPrice];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.1f",oldPrice] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1.0], NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    oldPriceLabel.attributedText = attrStr;
    [attrStr release];
    
    UILabel *discount = (UILabel *)[header0 viewWithTag:9];
    discount.text = [NSString stringWithFormat:@"%.1f折",currentPrice * 10.0/oldPrice];
}

#pragma mark - 接口调用
//获取团购秒杀商品详情
- (void)getGroupOrFlashBuyProductInfo{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:supplierId forKey:@"merchantId"];
    [param setObject:categoryId forKey:@"specificationId"];
    [param setObject:productId forKey:@"speciesId"];
    [param setObject:digestId forKey:@"digestId"];
    [param setObject:[NSNumber numberWithInteger:saleType] forKey:@"type"];
    
//    NSLog(@"request %@:\n parmeters: %@",kGET_PRODUCT_INFO,param);
    
    [RemoteManager Posts:kGET_TUAN_MIAO_PRODUCT_INFO
              Parameters:param
               WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
//                NSLog(@"ok, productInfo: %@",json);
                productInfo = [[json objectForKey:@"speciesBase"] retain];
                productHasDifferentTypes = [json[@"speciesBase"][@"unitMark"] boolValue];
                
                [self requestAddViewHistory];
                
                [self updateBottomViewByTypeDifference];
                tuanProductInfo = [json[@"tuanWare"] retain];
                [self performSelectorOnMainThread:@selector(reloadDataAndLayoutView) withObject:nil waitUntilDone:NO];
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

//获取普通商品详情
- (void)getOrdinaryProductInfo{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:supplierId forKey:@"merchantId"];
    [param setObject:categoryId forKey:@"specificationId"];
    [param setObject:productId forKey:@"speciesId"];
    //    NSLog(@"request %@:\n parmeters: %@",kGET_PRODUCT_INFO,param);
    [RemoteManager Posts:kGET_PRODUCT_INFO
              Parameters:param
               WithBlock:^(id json, NSError *error) {
                   [CustomBezelActivityView removeViewAnimated:YES];
                   if(error == nil){
                       if([[json objectForKey:@"state"] integerValue] == 1){
                            //                NSLog(@"ok, productInfo: %@",json);
                            productInfo = [[json objectForKey:@"speciesBase"] retain];
                            productHasDifferentTypes = [json[@"unitMark"] boolValue];
                           
                           int count = [[json[@"speciesBase"] objectForKey:@"discussCount"] integerValue];
                           _prodcutCommentsCountLabel.text = [NSString stringWithFormat:@"累加评价（%i）", count];

                            [self requestAddViewHistory];
                           
//                            [self updateBottomViewByTypeDifference];
                            [self performSelectorOnMainThread:@selector(reloadDataAndLayoutView) withObject:nil waitUntilDone:NO];
                       }else{
                           NSLog(@"server error");
                           NSLog(@"reason: %@",[json objectForKey:@"message"]);
                       }
                   }else{
                       NSLog(@"network error 0:%@",error);
                   }
               }];
    
    //查询商品参数
    [RemoteManager Posts:kGET_ATTRIBUTE_INFO
              Parameters:param
               WithBlock:^(id json, NSError *error) {
                   [CustomBezelActivityView removeViewAnimated:YES];
                   if(error == nil){
                       if([[json objectForKey:@"state"] integerValue] == 1){
                           //                NSLog(@"ok, productInfo: %@",json);
                           ordinaryProductAttributes = [json[@"baseColumnList"][0][@"baseAttributes"] retain];
//                           [self.table reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
                       }else{
                           NSLog(@"server error");
                           NSLog(@"reason: %@",[json objectForKey:@"message"]);
                       }
                   }else{
                       NSLog(@"network error 0:%@",error);
                   }
               }];
    
    [self requestMoreComments];

    
    [param release];
}

- (void)requestMoreComments{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"正在加载..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:supplierId forKey:@"merchantId"];
    [param setObject:categoryId forKey:@"specificationId"];
    [param setObject:productId forKey:@"speciesId"];
    //查询评价
    [param setObject:@PAGE_COMMENTS_COUNT forKey:@"num"];
    [param setObject:[NSNumber numberWithInteger:commentPage++] forKey:@"pageIndex"];
    [RemoteManager Posts:kGET_DISCUSS_INFO
              Parameters:param
               WithBlock:^(id json, NSError *error) {
                   [CustomBezelActivityView removeViewAnimated:YES];
                   if(error == nil){
                       if([[json objectForKey:@"state"] integerValue] == 1){
                           //                NSLog(@"ok, productInfo: %@",json);
                           if(ordinaryProdcutComments.count>0){
                               NSMutableArray *moreComments = [NSMutableArray new];
                               [moreComments addObjectsFromArray:ordinaryProdcutComments];
                               [moreComments addObjectsFromArray:json[@"discussList"]];
                               
                               NSMutableArray *arr = [NSMutableArray array]; 
                               for(int i=ordinaryProdcutComments.count; i<moreComments.count;i++){
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:3];
                                   [arr addObject:indexPath];
                               }
                               
                               [ordinaryProdcutComments release];
                               ordinaryProdcutComments = [moreComments copy];
                               
                               [self.table beginUpdates];
                               [self.table insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationBottom];
                               [self.table endUpdates];
//                               commentPage++;
                           }else{
                               ordinaryProdcutComments = [json[@"discussList"] copy];
                               [self.table reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                           }
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

- (void)requestAddViewHistory{
    if(!APP_DELEGATE.isLoggedIn){
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:supplierId forKey:@"merchantId"];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:categoryId forKey:@"specificationId"];
    [param setObject:productId forKey:@"speciesId"];
    [param setObject:productInfo[@"plu"] forKey:@"plu"];
    [param setObject:productInfo[@"prodName"] forKey:@"prodName"];
//    [param setObject:productInfo[@"salePrice"] forKey:@"salePrice"];
    [param setObject:productInfo[@"mediaPath"] forKey:@"picturePath"];
    
    if(_productType != HuEasyProductTypeOrdinary)
    {
        [param setObject:productInfo[@"teamPrice"] forKey:@"salePrice"];
    }
    else
    {
        [param setObject:productInfo[@"minSalePrice"] forKey:@"salePrice"];
    }
    
    [RemoteManager PostAsync:kADD_BROWSER_WARE
              Parameters:param
               WithBlock:^(id json, NSError *error) {
                   if(error == nil){
                       if([[json objectForKey:@"state"] integerValue] == 1){
                           NSLog(@"Add view history succeded");
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

- (void)requestWetherAddToDisire{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:categoryId forKey:@"specificationId"];
    [param setObject:productId forKey:@"speciesId"];
    [RemoteManager PostAsync:kWETHER_ADD_TO_DISIRE
                  Parameters:param
                   WithBlock:^(id json, NSError *error) {
                       if(error == nil){
                           if([[json objectForKey:@"state"] integerValue] == 1){
                               NSLog(@"未收藏");
                               _isCollection = NO;
                               _myItemId = @"";
                           }else if([[json objectForKey:@"state"] integerValue] == 0){
                               NSLog(@"已收藏");
                               _isCollection = YES;
                               _myItemId = [[json objectForKey:@"myItemId"] retain];
                           }else{
                               NSLog(@"server error");
                               NSLog(@"reason: %@",[json objectForKey:@"message"]);
                           }
                           if (_isCollection)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [_addToFavouriteBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
                                   [_addToFavouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-20, 15, 0, 0)];
                               });
                               
                           }
                           else
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [_addToFavouriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
                                   [_addToFavouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
                               });
                           }
                       }else{
                           NSLog(@"network error 0:%@",error);
                       }
                   }];
    [param release];
}

- (void)updateBottomViewByTypeDifference{
//    UIButton *buyBtn =(UIButton *)[self.bottomView1 viewWithTag:1];
//    UIButton *addToCartBtn =(UIButton *)[self.bottomView1 viewWithTag:2];
//    if(productHasDifferentTypes){
//        buyBtn.enabled = YES;
//        [buyBtn setBackgroundImage:[UIImage imageNamed:@"tab_button2_normal"] forState:UIControlStateNormal];
//        addToCartBtn.enabled = NO;
//        [addToCartBtn setBackgroundImage:[UIImage imageNamed:@"tab_button1_normal"] forState:UIControlStateNormal];
//    }else{
//        addToCartBtn.enabled = YES;
//        [addToCartBtn setBackgroundImage:[UIImage imageNamed:@"tab_button2_normal"] forState:UIControlStateNormal];
//        buyBtn.enabled = NO;
//#ifdef DEBUG
//        buyBtn.enabled = YES;
//#endif
//        [buyBtn setBackgroundImage:[UIImage imageNamed:@"tab_button1_normal"] forState:UIControlStateNormal];
//    }
}

- (void)requestAddToFavourite{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
//    [param setValue:productInfo[@"sku"] forKey:@"sku"];
    [param setObject:productInfo[@"specificationId"] forKey:@"specificationId"];
    [param setObject:productInfo[@"speciesId"] forKey:@"speciesId"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    
    NSLog(@"%@", productInfo[@"product"][0][@"prodNum"]);
    NSString *skuStr = [NSString stringWithFormat:@"%@", productInfo[@"product"][0][@"prodNum"]];
    
    [param setObject:skuStr forKey:@"sku"];
    
    NSLog(@"request %@:\n parmeters: %@",kGET_PRODUCT_INFO,param);
    
    [RemoteManager Posts:kADD_TO_DISIRE
              Parameters:param
               WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                //                NSLog(@"ok: %@",json);
                ZacAlertView *alert = [[ZacAlertView alloc]
                                       initWithTitle:@"收藏夹"
                                       message:@"成功添加商品至搜藏夹！"
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitle:nil
                                       cancelBlock:nil
                                       otherBlock:nil];
                [alert show];
                [alert release];
                _myItemId = [[json objectForKey:@"myItemId"] retain];
            }else{
                
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
                
                ZacAlertView *alert = [[ZacAlertView alloc]
                                       initWithTitle:@"收藏夹"
                                       message:@"该商品已收藏，无需重复操作"
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitle:nil
                                       cancelBlock:nil
                                       otherBlock:nil];
                [alert show];
                [alert release];
            }
        }else{
            NSLog(@"network error 0:%@",error);
        }
    }];
    
    [param release];
}

- (void)requestDeleteFavourite
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候..."];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:_myItemId forKey:@"myItemId"];
    
    [RemoteManager Posts:kDELETE_COLLECTION_INFO
              Parameters:param
               WithBlock:^(id json, NSError *error) {
                   [CustomBezelActivityView removeViewAnimated:YES];
                   if(error == nil){
                       if([[json objectForKey:@"state"] integerValue] == 1){
                           //                NSLog(@"ok: %@",json);
                           ZacAlertView *alert = [[ZacAlertView alloc]
                                                  initWithTitle:@"收藏夹"
                                                  message:@"成功取消收藏"
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitle:nil
                                                  cancelBlock:nil
                                                  otherBlock:nil];
                           [alert show];
                           [alert release];
                       }else{
                           
                           NSLog(@"server error");
                           NSLog(@"reason: %@",[json objectForKey:@"message"]);
                           
                           ZacAlertView *alert = [[ZacAlertView alloc]
                                                  initWithTitle:@"收藏夹"
                                                  message:@"取消收藏失败"
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitle:nil
                                                  cancelBlock:nil
                                                  otherBlock:nil];
                           [alert show];
                           [alert release];
                       }
                   }else{
                       NSLog(@"network error 0:%@",error);
                   }
               }];
    
    [param release];
}

- (void)updateViewBySellingState{
    if(sellingState == 0){
        self.bottomView0.hidden = NO;
    }else if(sellingState == 1){
        self.bottomView1.hidden = NO;
    }else{
        self.bottomView2.hidden = NO;
    }
}

#pragma mark - carouselView
- (NSInteger)numOfItemsInCarouselView:(CarouselView*)carouselView{
    return 1;
}
- (NSURL *)carouselView:(CarouselView *)carouselView imageUrlForItemAtIndex:(NSInteger)index{
    NSURL *url = [NSURL URLWithString:@""];
    return url;
}

- (IBAction)onJoinGroupBuy:(id)sender {
    BuyProductViewController *buyView = [[BuyProductViewController alloc] initWithProductInfo:productInfo andType:_productType];
//    [APP_DELEGATE.tempParam removeAllObjects];
//    [APP_DELEGATE.tempParam addEntriesFromDictionary:productInfo];
    buyView.buyNow=YES;     //zmf    2014-0508
    [self.navigationController pushViewController:buyView animated:YES];
    [buyView release];
}

- (IBAction)onAddtoShoppingCart:(id)sender {
    
    BuyProductViewController *buyView = [[BuyProductViewController alloc] initWithProductInfo:productInfo andType:_productType];
    //    [APP_DELEGATE.tempParam removeAllObjects];
    //    [APP_DELEGATE.tempParam addEntriesFromDictionary:productInfo];
    buyView.buyNow=NO;     //zmf    2014-0508
    [self.navigationController pushViewController:buyView animated:YES];
    [buyView release];
    
}

- (IBAction)onAddToFavourite:(id)sender{
    if(!APP_DELEGATE.isLoggedIn){
        ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"该功能需要先登录，是否登录？" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" cancelBlock:nil otherBlock:^{
            LoginViewController *login = [[LoginViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:navi animated:YES completion:nil];
            [login release];
            [navi release];
        }];
        [alert show];
        [alert release];
    }else{
        if (_isCollection)
        {
            [_addToFavouriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [_addToFavouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
            [self requestDeleteFavourite];
            _isCollection = NO;
            _myItemId = @"";
        }
        else
        {
            
            [_addToFavouriteBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
            [_addToFavouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(-20, 15, 0, 0)];
            [self requestAddToFavourite];
            _isCollection = YES;
        }
    }
}

- (IBAction)onAskForSupport:(id)sender{
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//{
//    NSLog(@"%f",scrollView.contentOffset.y);
//}

@end

