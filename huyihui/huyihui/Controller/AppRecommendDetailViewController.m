//
//  AppRecommendDetailViewController.m
//  huyihui
//
//  Created by pengzhizhong on 14-4-25.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "AppRecommendDetailViewController.h"

@interface AppRecommendDetailViewController ()
{
//1
//@property (retain, nonatomic) NSMutableArray *hsImageList;//广告图片地址数组
//@property (retain, nonatomic) HorizontalScrollImageShow *hsImageShow;//对象
//2
NSArray *ordinaryProductAttributes;//普通商品参数信息//3
NSArray *ordinaryProdcutComments;//普通商品需要显示评论//4
NSInteger commentPage;

NSArray *cells;
NSMutableIndexSet *expandStatus;//cell展开状态
}
@end

@implementation AppRecommendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithAppInfo:(NSDictionary *)appInfo
{
    self = [super init];
    if(self){
        _appInfo = appInfo;
        //saleType = [[info objectForKey:@"type"] integerValue];
        //[self getGroupOrFlashBuyProductInfo];
    }
    return self;
}
static NSString *attrCell = @"OrdinaryProductAttrCell";
static NSString *imageDetailCell = @"OrdinaryProductImageDetailCell";
static NSString *commentCell = @"OrdinaryProductCommentCell";
static NSString *commentExpandCell = @"OrdinaryProductCommentExpandCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
    self.navigationItem.leftBarButtonItem = nil;
    self.hsImageList=[[NSMutableArray new]autorelease];
    //
    ordinaryProductAttributes=[[NSArray new]autorelease];
    ordinaryProdcutComments=[[NSArray new]autorelease];
    //
    /*if(_productType == HuEasyProductTypeOrdinary){//普通商品
        cells = [[[NSBundle mainBundle] loadNibNamed:@"OrdinaryProductDetailCell" owner:self options:nil] retain];
        self.bottomView1.hidden = NO;//立即购买和加入购物车两个按钮
        UIButton *buyBtn = (UIButton *)[self.bottomView1 viewWithTag:1];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];//原来的标题是"立即参团",需要更改
        
        [self.table registerNib:[UINib nibWithNibName:attrCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:attrCell];
        [self.table registerNib:[UINib nibWithNibName:imageDetailCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:imageDetailCell];
        [self.table registerNib:[UINib nibWithNibName:commentCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentCell];
        [self.table registerNib:[UINib nibWithNibName:commentExpandCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentExpandCell];
    }else{//团购或者秒杀商品*/
        cells = [[[NSBundle mainBundle] loadNibNamed:@"AppRecommendDetailCell" owner:self options:nil] retain];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_table release];
    [super dealloc];
}
#pragma mark - HorizontalScrollImageShow
- (NSInteger)numOfItemsInShowView:(HorizontalScrollImageShow*)showlView
{
    //
    [self.hsImageList removeAllObjects];
#ifdef DEBUG
    [self.hsImageList addObjectsFromArray:@[
                                            [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/shouyeangel.jpg"],
                                            [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/shouyemingxingouba.jpg"],
                                            [NSURL URLWithString:@"http://img0.bdstatic.com/img/image/shouye/142-142xuxiyuan.jpg"]]];
#endif
    //[self.hsImageShow reloadData];
    //
    return self.hsImageList.count;
}
- (NSURL *)HorizontalScrollImageShow:(HorizontalScrollImageShow *)showView imageUrlForItemAtIndex:(NSInteger)index
{
    //NSURL *url = [NSURL URLWithString:@""];
    //return url;
    return self.hsImageList[index];
}
- (void)HorizontalScrollImageShow:(HorizontalScrollImageShow *)showView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%i:%@",index,self.hsImageList[index]);
}

#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ((UITableViewCell *)cells[section]).bounds.size.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return cells[section];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([expandStatus containsIndex:section]){
        if(section == 3){//普通商品需要显示商品参数信息
            if(ordinaryProductAttributes.count == 0)
            {
                return 1;
            }else{
                return ordinaryProductAttributes.count;
            }
        }else if(section == 4){//普通商品需要显示评论
            if(ordinaryProdcutComments.count == 0)
            {
                return 1;
            }else{
                return ordinaryProdcutComments.count + 1;//因为有个加载更多,所以加1
            }
        }else{
            return 1;
        }
        return 1;
    }else{
        return 0;
    }
}
static CGFloat commentFontSize = 14;
static CGFloat commentViewWidth = 300;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(_productType != HuEasyProductTypeOrdinary){
    //    return [(UITableViewCell *)cells[indexPath.section + 3] bounds].size.height ;
    //}else{
        if(indexPath.section == 3){
            if(ordinaryProductAttributes.count == 0){
                return 40;
            }else{
                return 48;
            }
        }else if (indexPath.section == 4){
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
    //}

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(self.productType != HuEasyProductTypeOrdinary){
    //    return cells[indexPath.section + 3];
    //}else{
        UITableViewCell *cell = nil;
        if(indexPath.section == 3){//参数信息
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
        }else if (indexPath.section == 4){
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
  //}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3 &&
       ordinaryProdcutComments.count > 0 &&
       indexPath.row == ordinaryProdcutComments.count){
        //[self loadMoreComments];
    }
}


#pragma mark - ..
- (void)sectionExpand:(UIButton*)sender
{
    UIView *cell = (UITableViewCell *)sender.superview;
    NSInteger index = [cells indexOfObject:cell];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:index];
    if([expandStatus containsIndex:index]){//去收起
        [expandStatus removeIndex:index];
        [sender setImage:[UIImage imageNamed:@"list_more_normal"] forState:UIControlStateNormal];
        //if(self.productType != HuEasyProductTypeOrdinary){
            //[self.table deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //}else{
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        //}
    }else{//去展开
        [expandStatus addIndex:index];
        [sender setImage:[UIImage imageNamed:@"list_pull down_normal"] forState:UIControlStateNormal];
        //if(self.productType != HuEasyProductTypeOrdinary){
        //    [self.table insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //}else{
            
            if(indexpath.section == 3){
                if(ordinaryProductAttributes.count == 0){
                    [self.table insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    return;
                }
            }
            else if(indexpath.section == 4){
                if(ordinaryProdcutComments.count == 0){
                    [self.table insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    return;
                }
            }
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        //}
        
        //        [self.table reloadData];
        //        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
    //    [self.table reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
//.
@end
