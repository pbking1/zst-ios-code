//
//  FlashSaleViewController.m
//  huyihui
//
//  Created by zaczh on 1/Users/zjh/Desktop/workspace/TestAll/TestViewController.m4-2-25.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "FlashSaleViewController.h"

#define STR(x) [NSString stringWithFormat:@"%@",x]

@interface FlashSaleViewController ()
@property (copy, nonatomic) NSArray *dataSource;
@property (retain, nonatomic) NSArray *sortList;
@property (retain, nonatomic) NSArray *topCategory;
@property (retain, nonatomic) NSArray *subCategorySource;
@property (retain, nonatomic) NSDictionary *subCategory;

//当前排序方式
@property (copy, nonatomic) NSString *currentSortId;

//当前显示类别
@property (copy, nonatomic) NSString *currentCategoryId;
@end

static NSString *cellIdentifier = @"cellIdentifier";

@implementation FlashSaleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSaleType:(NSInteger)saleType{
    self = [super init];
    if(self){
        _saleType = saleType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_saleType == 0){
        self.title = @"最惠团";
        [self.table registerNib:[UINib nibWithNibName:@"GroupBuyCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
        self.placeholderHintLabel.text = @"暂无此类团购商品";
    }else{
        self.title = @"限时抢购";
        [self.table registerNib:[UINib nibWithNibName:@"FlashSaleItemCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:cellIdentifier];
        self.placeholderHintLabel.text = @"暂无此类限时抢购商品";
    }
    
    self.sortTable.tableFooterView = [[[UIView alloc] init] autorelease];
    self.categoryTable.tableFooterView = [[[UIView alloc] init] autorelease];
    self.subCategoryTable.tableFooterView = [[[UIView alloc] init] autorelease];
    
    /*
     排序方式 ：00,上架新品降序; 01,上架新品升序;10,销售量降序; 11,销售量升序;20,价格降序;21,价格升序
     */
    self.sortList = @[
                      @{@"description":@"默认排序",@"id":@"00"},
                      @{@"description":@"上架新品降序",@"id":@"00"},
                      @{@"description":@"上架新品升序",@"id":@"01"},
                      @{@"description":@"销售量降序",@"id":@"10"},
                      @{@"description":@"销售量升序",@"id":@"11"},
                      @{@"description":@"价格降序",@"id":@"20"},
                      @{@"description":@"价格升序",@"id":@"21"}];
    self.currentSortId = @"0";
    [self requestCategories];
    [self requestDataByOrderType:0 andWareTypeId:nil];
    
//    self.topCategory = @[
//                         @{@"title":@"全部分类",@"count":@"30"},
//                         @{@"title":@"生活服务",@"count":@"30"},
//                         @{@"title":@"餐饮美食",@"count":@"42"},
//                         //                          @{@"title":@"电影演出",@"count":@"38"},
//                         //                          @{@"title":@"休闲娱乐",@"count":@"16"},
//                         //                          @{@"title":@"摄影写真",@"count":@"45"},
//                         @{@"title":@"旅游度假",@"count":@"72"}];
//    self.subCategory = @{
//                         @"餐饮美食":@[
//                                 @{@"title":@"火锅",@"count":@"30"},
//                                 @{@"title":@"自助餐",@"count":@"430"},
//                                 @{@"title":@"川菜",@"count":@"42"}
//                                 ],
//                         @"生活服务":@[
//                                 @{@"title":@"电影",@"count":@"320"},
//                                 @{@"title":@"KTV",@"count":@"3150"},
//                                 @{@"title":@"演唱会",@"count":@"452"}
//                                 ]
//                         };
}

- (void)viewWillAppear:(BOOL)animated{
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:NO];
    
    [super viewWillAppear:animated];
}

- (void)requestCategories
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    
    [RemoteManager Posts:kGET_TUAN_KILL_CATALOGUE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@{@"id":@"",@"description":@"全部分类"}, nil];
                [arr addObjectsFromArray:[json objectForKey:@"tuanKillCatalogueList"]];
//                self.topCategory = [json objectForKey:@"tuanKillCatalogueList"];
                self.topCategory = [[arr copy] autorelease];
                [arr release];
                self.currentCategoryId = nil;//默认分类
                [self.categoryTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error: %@",error);
        }
    }];
    [param release];
}

- (void)requestDataByOrderType:(NSString *)orderType andWareTypeId:(NSString *)wareTypeId{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NSNumber numberWithInteger:10] forKey:@"num"];
    [param setObject:[NSNumber numberWithInteger:1] forKey:@"pageIndex"];
    [param setObject:[NSNumber numberWithInteger:self.saleType] forKey:@"tuanKillFlag"];//0，最惠团、团购内容页；1，限时抢购、抢购内容页
    [param setObject:[NSNumber numberWithInteger:[orderType integerValue]] forKey:@"orderModel"];
    [param setValue:wareTypeId forKey:@"wareTypeId"];//can be nil
    
//    NSLog(@"params:\n%@",param);
    [RemoteManager Posts:kGET_TUAN_KILL_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                //                NSLog(@"ok:%@",json);
                self.dataSource = nil;
                self.dataSource = [json objectForKey:@"tuanKillList"];
                [self.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }else{
                NSLog(@"server error");
                NSLog(@"reason: %@",[json objectForKey:@"message"]);
            }
        }else{
            NSLog(@"network error: %@",error);
        }
    }];
    [param release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.table){
        NSUInteger count = self.dataSource.count;
        if(count == 0){
            self.tablePlaceholder.hidden = NO;
        }else{
            self.tablePlaceholder.hidden = YES;
        }
        return count;
    }else if(tableView == self.sortTable){
        return self.sortList.count;
    }else if(tableView == self.categoryTable){
        return self.topCategory.count;
    }else if(tableView == self.subCategoryTable){
        return self.subCategorySource.count;
    }else{
        return 0;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == self.table){
//    return 116.0f;
//    }else{
//        return 39.0f;
//    }
//}

//- (void)setEventTimeLabel:(UILabel *)label startTime:(NSString *)str
//{
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *sortIdentifier = @"sort";
    static NSString *categoryIdentifier = @"sort";
    

    
    if(tableView == self.table){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if(self.saleType == 1){//限时秒杀
    //        NSLog(@"dataSource of row: %@",self.dataSource[indexPath.row]);
            
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
            TimerLabel *timeLabel = (TimerLabel *)[cell.contentView viewWithTag:2];
            UILabel *itemDesc = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *nowPrice = (UILabel *)[cell.contentView viewWithTag:4];
            UILabel *oldPrice = (UILabel *)[cell.contentView viewWithTag:5];
            UILabel *stockDetail = (UILabel *)[cell.contentView viewWithTag:6];
            UIButton *saleStatus = (UIButton *)[cell.contentView viewWithTag:7];
            //TEST
    //        timeLabel.beginTime = ([[NSDate date] timeIntervalSince1970] + 1000) * 1000;
    //        timeLabel.endTime = ([[NSDate date] timeIntervalSince1970] + 2000) * 1000;

            timeLabel.beginTime = [[self.dataSource[indexPath.row] objectForKey:@"startDate"] doubleValue];
            timeLabel.endTime = [[self.dataSource[indexPath.row] objectForKey:@"endDate"] doubleValue];
    //        NSLog(@"TIME:%f",timeLabel.beginTime);

            itemDesc.text = [NSString stringWithFormat:@"%@[每个ID限购%@件]", [self.dataSource[indexPath.row] objectForKey:@"nameZh"], [self.dataSource[indexPath.row] objectForKey:@"limitNum"]];
            
            NSDictionary *nowPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"c80000"],NSFontAttributeName:[UIFont systemFontOfSize:13]};
            NSDictionary *oldPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"b7b7b7"],NSFontAttributeName:[UIFont systemFontOfSize:12],NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            
            nowPrice.attributedText = [[[NSAttributedString alloc]
                                        initWithString:[NSString stringWithFormat:@"￥%@",([self.dataSource[indexPath.row] objectForKey:@"teamPrice"])]
                                        attributes:nowPriceAttr] autorelease];
            oldPrice.attributedText = [[[NSAttributedString alloc]
                                        initWithString:[NSString stringWithFormat:@"￥%@",([self.dataSource[indexPath.row] objectForKey:@"retailPrice"])]
                                        attributes:oldPriceAttr] autorelease];
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[self.dataSource[indexPath.row] objectForKey:@"imgUrl"]]];
            
            [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
                imageView.image = image;
            } errorBlock:nil];
            
            long long stockTotal = [[self.dataSource[indexPath.row] objectForKey:@"stockTotal"] longLongValue];
            long long stockSold = [[self.dataSource[indexPath.row] objectForKey:@"stockSold"] longLongValue];
            
            if(stockSold >= stockTotal){
                saleStatus.hidden = NO;
                [saleStatus setTitle:@"已售罄" forState:UIControlStateNormal];
//                saleStatus.backgroundColor = [UIColor grayColor];
                [saleStatus setBackgroundImage:[UIImage imageNamed:@"1-02group-buying_list_sold out background"] forState:UIControlStateNormal];
            }else{
                if([[self.dataSource[indexPath.row] objectForKey:@"startDate"] longLongValue] >
                   [[NSDate date] timeIntervalSince1970] * 1000){
                    saleStatus.hidden = NO;
                    [saleStatus setTitle:@"即将开始" forState:UIControlStateNormal];
//                    saleStatus.backgroundColor = [UIColor greenColor];
                    [saleStatus setBackgroundImage:[UIImage imageNamed:@"1-02group-buying_list_About to begin background"] forState:UIControlStateNormal];
                }else{
                    saleStatus.hidden = NO;
                    [saleStatus setTitle:@"正在抢购" forState:UIControlStateNormal];
                    [saleStatus setBackgroundImage:[UIImage imageNamed:@"1-02group-buying_list_people involved background"] forState:UIControlStateNormal];
                }
                NSMutableAttributedString *attrStrM = [NSMutableAttributedString new];
                NSAttributedString *attr1 = [[NSAttributedString alloc]
                                             initWithString:[NSString stringWithFormat:@"已售完%lld%%，还剩", stockSold/stockTotal]
                                                attributes:nil];
                [attrStrM appendAttributedString:attr1];
                [attr1 release];
                
                NSAttributedString *attr2 = [[NSAttributedString alloc]
                                             initWithString:[NSString stringWithFormat:@"%lld",stockTotal - stockSold]
                                                 attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
                [attrStrM appendAttributedString:attr2];
                [attr2 release];

                NSAttributedString *attr3 = [[NSAttributedString alloc]
                                             initWithString:@"件"
                                             attributes:nil];
                [attrStrM appendAttributedString:attr3];
                [attr3 release];
                
                stockDetail.attributedText = attrStrM;
                [attrStrM release];
            }
        }else if (self.saleType == 0){//最惠团
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
            UILabel *itemDesc = (UILabel *)[cell.contentView viewWithTag:2];
            UILabel *nowPrice = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *oldPrice = (UILabel *)[cell.contentView viewWithTag:4];
            UILabel *discount = (UILabel *)[cell.contentView viewWithTag:5];
            UILabel *soldCount = (UILabel *)[cell.contentView viewWithTag:6];
            UIButton *saleStatus = (UIButton *)[cell.contentView viewWithTag:7];
            
//            NSLog(@"%@",self.dataSource[indexPath.row]);
            
            double startTime = [[self.dataSource[indexPath.row] objectForKey:@"startDate"] doubleValue];
            double endTime = [[self.dataSource[indexPath.row] objectForKey:@"endDate"] doubleValue];
            long beginInterval = startTime - [[NSDate date] timeIntervalSince1970]*1000;
            long endInterval = endTime - [[NSDate date] timeIntervalSince1970]*1000;
            if(beginInterval > 0){//尚未开始
                soldCount.text = [NSString stringWithFormat:@"%@人已购买",[self.dataSource[indexPath.row] objectForKey:@"stockSold"]];
                saleStatus.hidden = YES;
            }else if(endInterval > 0){//正在进行中
                soldCount.text = [NSString stringWithFormat:@"%@人已购买",[self.dataSource[indexPath.row] objectForKey:@"stockSold"]];
                saleStatus.hidden = NO;
                [saleStatus setTitle:@"正在抢购" forState:UIControlStateNormal];
                [saleStatus setBackgroundImage:[UIImage imageNamed:@"1-02group-buying_list_people involved background"] forState:UIControlStateNormal];
            }else{//已经结束
                soldCount.text = [NSString stringWithFormat:@"%@人已购买",[self.dataSource[indexPath.row] objectForKey:@"stockSold"]];
                saleStatus.hidden = NO;
                [saleStatus setTitle:@"已经结束" forState:UIControlStateNormal];
                [saleStatus setBackgroundImage:[UIImage imageNamed:@"1-02group-buying_list_sold out background"] forState:UIControlStateNormal];
            }
            
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[self.dataSource[indexPath.row] objectForKey:@"imgUrl"]]];
            
            [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
                imageView.image = image;
            } errorBlock:nil];
            
//            NSString *desc = [self.dataSource[indexPath.row] objectForKey:@"description"];
            NSString *desc = [self.dataSource[indexPath.row] objectForKey:@"nameZh"];
            if(![desc isEqual:[NSNull null]]){
                itemDesc.text = desc;
            }else{
                itemDesc.text = @"商品介绍";
            }
            
            NSDictionary *nowPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"c80000"],
                                           NSFontAttributeName:[UIFont systemFontOfSize:13]};
            NSDictionary *oldPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"b7b7b7"],
                                           NSFontAttributeName:[UIFont systemFontOfSize:12],
                                           NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            double nowP = [[self.dataSource[indexPath.row] objectForKey:@"teamPrice"] doubleValue];
            double oldP = [[self.dataSource[indexPath.row] objectForKey:@"retailPrice"] doubleValue];
            nowPrice.attributedText = [[[NSAttributedString alloc]
                                        initWithString:[NSString stringWithFormat:@"￥%.1f",nowP]
                                        attributes:nowPriceAttr] autorelease];
            oldPrice.attributedText = [[[NSAttributedString alloc]
                                        initWithString:[NSString stringWithFormat:@"￥%.1f",oldP]
                                        attributes:oldPriceAttr] autorelease];
            discount.text = [NSString stringWithFormat:@"%.1f折", 10 * nowP/oldP];
        }
        return cell;
    }else if (tableView == self.sortTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sortIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortIdentifier] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 39)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [Util rgbColor:"3d4245"];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            [label release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        ((UILabel *)(cell.contentView.subviews[0])) .text = [[self.sortList objectAtIndex:indexPath.row] objectForKey:@"description"];
        return cell;
    }else if(tableView == self.categoryTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryIdentifier] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 39)];
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            [label release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        ((UILabel *)(cell.contentView.subviews[0])).text = [self.topCategory[indexPath.row] objectForKey:@"description"];
        
        return cell;
    }else if (tableView == self.subCategoryTable){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryIdentifier] autorelease];
            cell.backgroundColor = [Util rgbColor:"dddddd"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        //TODO:
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",
                               [self.subCategorySource[indexPath.row] objectForKey:@"title"],
                               [self.subCategorySource[indexPath.row] objectForKey:@"count"]];
        
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.sortTable){
        self.currentSortId = self.sortList[indexPath.row][@"id"];
        [UIView animateWithDuration:.25f animations:^{
            self.sortView.alpha = .0f;
            [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_normal"]];
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.sortTypeBtn setTitle:self.sortList[indexPath.row][@"description"] forState:UIControlStateNormal];
        [self requestDataByOrderType:self.currentSortId andWareTypeId:self.currentCategoryId];
    }else if(tableView == self.table){
        if(self.saleType == 0){
            GroupBuyItemDetailViewController *gbidvc = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:self.dataSource[indexPath.row] andType:HuEasyProductTypeGroupBuy];
//            [APP_DELEGATE.tempParam addEntriesFromDictionary:self.dataSource[indexPath.row]];
            [self.navigationController pushViewController:gbidvc animated:YES];
            [gbidvc release];
        }else if (self.saleType == 1){
            //TODO:跳转到限时抢购
            GroupBuyItemDetailViewController *gbidvc = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:self.dataSource[indexPath.row] andType:HuEasyProductTypeFlashBuy];
//            [APP_DELEGATE.tempParam addEntriesFromDictionary:self.dataSource[indexPath.row]];
            [self.navigationController pushViewController:gbidvc animated:YES];
            [gbidvc release];
        }
    }else if (tableView == self.categoryTable){
        self.currentCategoryId = self.topCategory[indexPath.row][@"id"];
        [UIView animateWithDuration:.25f animations:^{
            self.categoryView.alpha = .0;
        }];
        [self.categoryBtn setTitle:self.topCategory[indexPath.row][@"description"] forState:UIControlStateNormal];
        [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_normal"]];
        [self requestDataByOrderType:self.currentSortId andWareTypeId:self.currentCategoryId];
    }else if(tableView == self.subCategoryTable){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIView animateWithDuration:.25f animations:^{
            self.categoryView.alpha = .0;
        }];
        [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_normal"]];

        self.subCategorySource = nil;
        [self.subCategoryTable reloadData];
        
        NSIndexPath *indexPath = [self.categoryTable indexPathForSelectedRow];
        [self.categoryTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}
//#pragma mark - search thing
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;
//{
//    [self updateSearchResultsBySearchString:searchString];
//    return YES;
//}
//
//- (void)updateSearchResultsBySearchString:(NSString *)searchString
//{
//    NSLog(@"%s",__func__);
//}

- (IBAction)clickSortBtn:(UIButton *)sender{
    //    BOOL hidden = !self.sortView.hidden;
    CGFloat alpha = self.sortView.alpha;
    //    self.sortView.hidden = hidden;
    
    if(alpha < .1f){
        //        self.categoryView.hidden = YES;
        [UIView animateWithDuration:.25f animations:^{
            self.sortView.alpha = 1.0f;
            self.categoryView.alpha = .0f;
//            [self.categoryBtn setBackgroundColor:[UIColor clearColor]];
//            [sender setBackgroundColor:[UIColor whiteColor]];
            [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_right highlight"]];
        }];
    }else{
        [UIView animateWithDuration:.25f animations:^{
            self.sortView.alpha = .0f;
//            [sender setBackgroundColor:[UIColor clearColor]];
            [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_normal"]];
        }];
        
    }
}

-(IBAction)clickCategoryBtn:(id)sender{
    CGFloat alpha = self.categoryView.alpha;
    //    BOOL hidden = !self.categoryView.hidden;
    //    self.categoryView.hidden = hidden;
    //    self.subCategoryTable.hidden = hidden;
    
    if(alpha < .1f){
        [UIView animateWithDuration:.25f animations:^{
            self.sortView.alpha = .0f;
            self.categoryView.alpha = 1.0f;
            //        self.sortView.hidden = YES;
//            [self.sortTypeBtn setBackgroundColor:[UIColor clearColor]];
//            [sender setBackgroundColor:[UIColor whiteColor]];
            [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_left highlight"]];
        }];
    }else{
        [UIView animateWithDuration:.25f animations:^{
            self.categoryView.alpha = .0f;
            //            [sender setBackgroundColor:[UIColor clearColor]];
            [self.headerBgIV setImage:[UIImage imageNamed:@"1-02group-buying_filter bar_normal"]];
        }];
    }
}

- (void)dealloc {
    [_headerBgIV release];
    [_tablePlaceholder release];
    [_placeholderHintLabel release];
    [super dealloc];
}
@end
