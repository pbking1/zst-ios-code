//
//  MoreProductVC.m
//  huyihui
//
//  Created by zaczh on 14-3-24.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "MoreProductVC.h"

@interface MoreProductVC ()
@property (copy, nonatomic) NSArray *dataSource;
@property (assign, nonatomic)HomePageMoreProductType pageType;

@end

@implementation MoreProductVC
static NSString *cellIdentifier = @"cellIdentifier";

- (id)initWithType:(HomePageMoreProductType)type{
    self = [super init];
    if (self) {
        // Custom initialization
        _pageType = type;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.table registerNib:[UINib nibWithNibName:@"MoreProductCell" bundle:[NSBundle mainBundle]]forCellReuseIdentifier:cellIdentifier];
    if(_pageType == HomePageMoreProductNew){
        self.title = @"新品上市";
    }else if(_pageType == HomePageMoreProductHot){
        self.title = @"热卖推荐";
    }else{
        self.title = @"精品推荐";
    }
    [self performSelectorInBackground:@selector(requestData) withObject:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    NSIndexPath *indexPath = self.table.indexPathForSelectedRow;
    [self.table deselectRowAtIndexPath:indexPath animated:NO];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NSNumber numberWithInt:10] forKey:@"num"];
    [param setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    
    if(_pageType == HomePageMoreProductNew){
        [RemoteManager PostAsync:kGET_NEW_WARE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
            if(error == nil){
                if([[json objectForKey:@"state"] integerValue] == 1){
                    self.dataSource = [json objectForKey:@"newWareList"];
                    [self.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }else{
                    NSLog(@"server error");
                    NSLog(@"reason: %@",[json objectForKey:@"message"]);
                }
            }else{
                NSLog(@"network error 0:%@",error);
            }
        }];
    }else if(_pageType == HomePageMoreProductHot){
        [RemoteManager PostAsync:kGET_HOT_WARE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
            if(error == nil){
                if([[json objectForKey:@"state"] integerValue] == 1){
                    self.dataSource = [json objectForKey:@"hotSaleList"];
                    [self.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }else{
                    NSLog(@"server error");
                    NSLog(@"reason: %@",[json objectForKey:@"message"]);
                }
            }else{
                NSLog(@"network error 0:%@",error);
            }
        }];
    }else if(_pageType == HomePageMoreProductRecommend){
        [RemoteManager PostAsync:kGET_RECOMMEND_INFO Parameters:param WithBlock:^(id json, NSError *error) {
            if(error == nil){
                if([[json objectForKey:@"state"] integerValue] == 1){
                    self.dataSource = [json objectForKey:@"recommendList"];
                    [self.table performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }else{
                    NSLog(@"server error");
                    NSLog(@"reason: %@",[json objectForKey:@"message"]);
                }
            }else{
                NSLog(@"network error 0:%@",error);
            }
        }];
    }

    [param release];
}

- (void)dealloc {
    [_table release];
    [super dealloc];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *itemDesc = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *nowPrice = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *oldPrice = (UILabel *)[cell.contentView viewWithTag:4];
    UILabel *discount = (UILabel *)[cell.contentView viewWithTag:5];
    
    itemDesc.text = [self.dataSource[indexPath.row] objectForKey:@"speciName"];
    
    NSDictionary *nowPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"c80000"],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    NSDictionary *oldPriceAttr = @{NSForegroundColorAttributeName:[Util rgbColor:"b7b7b7"],
                                   NSFontAttributeName:[UIFont systemFontOfSize:12],
                                   NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    float oldP = [[self.dataSource[indexPath.row] objectForKey:@"minRetailPrice"] floatValue];
    float nowP = [[self.dataSource[indexPath.row] objectForKey:@"minSalePrice"] floatValue];
    
    nowPrice.attributedText = [[[NSAttributedString alloc]
                                initWithString:[NSString stringWithFormat:@"￥%d",(int)nowP]
                                attributes:nowPriceAttr] autorelease];
    oldPrice.attributedText = [[[NSAttributedString alloc]
                                initWithString:[NSString stringWithFormat:@"￥%d",(int)oldP]
                                attributes:oldPriceAttr] autorelease];
    
    discount.text = [NSString stringWithFormat:@"%.1f折",nowP/oldP * 10];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[self.dataSource[indexPath.row] objectForKey:@"mathPath"]]];
    
    [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
        imageView.image = image;
    } errorBlock:nil];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:跳转到限时抢购
    GroupBuyItemDetailViewController *gbidvc = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:self.dataSource[indexPath.row] andType:HuEasyProductTypeOrdinary];
//    [APP_DELEGATE.tempParam addEntriesFromDictionary:self.dataSource[indexPath.row]];
    [self.navigationController pushViewController:gbidvc animated:YES];
    [gbidvc release];
}
@end
