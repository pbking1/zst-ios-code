//
//  AppRecommendListViewController.m
//  huyihui
//
//  Created by pengzhizhong on 14-4-25.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "AppRecommendListViewController.h"
#import "AppRecommendDetailViewController.h"

@interface AppRecommendListViewController ()
@property (copy, nonatomic) NSArray *dataSource;
@end

@implementation AppRecommendListViewController
static NSString * cellIdentifier =@"cellIdentifier";

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
    //NSArray cells = [[[NSBundle mainBundle] loadNibNamed:@"GroupBuyItemDetailCell" owner:self options:nil] retain];
    //
    self.dataSource=[[NSArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppRecommendListViewTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    self.title=@"应用推荐";
    self.placeHolder.hidden=NO;
    //[self performSelectorInBackground:@selector(requestData) withObject:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [super viewWillAppear:animated];

}
#pragma requestData...
- (void)requestData
{
    [CustomBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"请稍侯", @"")];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:APP_DELEGATE.merchantId forKey:@"merchantId"];
    [param setObject:[NSNumber numberWithInt:10] forKey:@"num"];
    [param setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
    //没有接口,这里要换接口，临时使用这个接口
    [RemoteManager Posts:kGET_NEW_WARE_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        [CustomBezelActivityView removeViewAnimated:YES];
        if(error == nil){
            if([[json objectForKey:@"state"] integerValue] == 1){
                self.dataSource = [json objectForKey:@"newWareList"];
                //
                if(self.dataSource.count>0){
                    self.placeHolder.hidden=YES;
                    [self.tableView reloadData];
                }else{
                    self.placeHolder.hidden=NO;//没有数据
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
#pragma tableView ...start
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *mainTitle=(UILabel *)[cell.contentView viewWithTag:2];
    UILabel *subTitle=(UILabel *)[cell.contentView viewWithTag:3];
    UIButton *rightButton=(UIButton *)[cell.contentView viewWithTag:4];
    //>>
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[self.dataSource[indexPath.row] objectForKey:@"mathPath"]]];
    [imageView setBackgroundColor:[UIColor grayColor]];
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[imageView viewWithTag:999];
    if(loadingView == nil){
        loadingView = [[UIActivityIndicatorView alloc] initWithFrame :CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        loadingView.color= [UIColor blackColor];
        loadingView.tag = 999;
        [loadingView startAnimating];
        [imageView addSubview:loadingView];
        [loadingView release];
    }
    [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
        if(image){
            [imageView setImage:image];
            [imageView setBackgroundColor:[UIColor clearColor]];
            if(loadingView){
                [loadingView removeFromSuperview];
            }
        }
    } errorBlock:nil];
    //
//    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,[self.dataSource[indexPath.row] objectForKey:@"mathPath"]]];
//    
//    [Util UIImageFromURL:imageUrl withImageBlock:^(UIImage *image) {
//        imageView.image = image;
//    } errorBlock:nil];
    //<<
    mainTitle.text=[self.dataSource[indexPath.row] objectForKey:@"speciName"];
    subTitle.text=[NSString stringWithFormat:@"%@",[self.dataSource[indexPath.row] objectForKey:@"minRetailPrice"]];//minSalePrice//
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)rightButtonClicked:(UIButton*)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"indexPath is = %i",indexPath.row);
    //
    AppRecommendDetailViewController *appRecommendDetailViewController=[[AppRecommendDetailViewController alloc]initWithAppInfo:self.dataSource[indexPath.row]];
    //
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"title...test",@"title", nil];
    dic=self.dataSource[indexPath.row];
    //appRecommendDetailViewController.appInfo=dic;
    [self.navigationController pushViewController:appRecommendDetailViewController animated:YES];
    //[dic release];
    [appRecommendDetailViewController release];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath is = %i",indexPath.row);
    //
    //AppRecommendDetailViewController *appRecommendDetailViewController=[[AppRecommendDetailViewController alloc]initWithNibName:@"AppRecommendDetailViewController" bundle:nil];
    AppRecommendDetailViewController *appRecommendDetailViewController=[[AppRecommendDetailViewController alloc]initWithAppInfo:self.dataSource[indexPath.row]];
    //
    NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"title...test",@"title", nil];
    dic=self.dataSource[indexPath.row];
    //appRecommendDetailViewController.appInfo=dic;
    [self.navigationController pushViewController:appRecommendDetailViewController animated:YES];
    //[dic release];
    [appRecommendDetailViewController release];
}
#pragma tableView ...end


#pragma ...
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_placeHolder release];
    [_placeHolder_iv release];
    [_placeHolder_la release];
    //
    [_dataSource release];
    [super dealloc];
}
@end
