//
//  MoreConfigure.m
//  huyihui
//
//  Created by zhangmeifu on 12/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "MoreConfigure.h"
#define TABLE_HEADER_HEIGHT 26.0f
#define TABLE_CELL_HEIGHT 44.0f

@interface MoreConfigure (){
//    NSInteger imageQuality;
//    NSInteger noticeType;
}

@end

@implementation MoreConfigure


@synthesize configureDic=_configureDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _configureDic=[[NSMutableDictionary alloc]init];
        [_configureDic setObject:@[@"智能模式",@"高质量（合适wifi环境）",@"普通（合适2G/3G环境）"] forKey:@"graphicQuarity"];
        [_configureDic setObject:@[@"接收通知",@"声音提醒",@"震动提醒"] forKey:@"remindStyle"];
        [_configureDic setObject:@[@"意见反馈",@"检查更新",@"应用推荐"] forKey:@"other"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.moreConfigureTable.backgroundColor=[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000];
    self.moreConfigureTable.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*3);
//    imageQuality = [[NUSD objectForKey:kUserPreferredImageQuality] integerValue];
//    noticeType = [[NUSD objectForKey:kUserPreferredNoticeType] integerValue];
    

    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 116)];
    UIButton *loginOutBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginOutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"4-03more_ EXIT button_normal"] forState:UIControlStateNormal];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"4-03more_ EXIT button_highlight"] forState:UIControlStateHighlighted];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOutBtn.frame=CGRectMake(16, 0, SCREEN_WIDTH-32, 40);
    [tableFooter addSubview:loginOutBtn];

    UIButton *cleanCacheBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cleanCacheBtn.frame=CGRectMake(16, 56, SCREEN_WIDTH-32, 40);
    [cleanCacheBtn addTarget:self action:@selector(onClearCache:) forControlEvents:UIControlEventTouchUpInside];
    [cleanCacheBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
    [cleanCacheBtn setBackgroundImage:[UIImage imageNamed:@"4-03more_ Empty Cache button_normal"] forState:UIControlStateNormal];
    [cleanCacheBtn setBackgroundImage:[UIImage imageNamed:@"4-03more_ Empty Cache button_highlight"] forState:UIControlStateHighlighted];
    [tableFooter addSubview:cleanCacheBtn];
    
    self.moreConfigureTable.tableFooterView = tableFooter;
    [tableFooter release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_moreConfigureTable release];
    self.configureDic=nil;
    [super dealloc];
}

#pragma mark - table dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section>=0&&section<3)
//    {
        return 3;
//    }
//    else
//    {
//        return 1;
//    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(16, 0, 288, TABLE_HEADER_HEIGHT)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 288, 12)];
    [headerView addSubview:title];
    [title release];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor colorWithRed:114/255.0 green:116/255.0 blue:118/255.0 alpha:1.0];
    
    if (section==0)
    {
        title.text = @"图片显示质量";
    }
    else if (section==1)
    {
        title.text = @"通知设置";
    }
    else if(section==2)
    {
        title.text = @"其他";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLE_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLE_CELL_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:114/255.0 green:116/255.0 blue:118/255.0 alpha:1.0];
    }
    if (indexPath.section==0)
    {
        cell.textLabel.text=[[_configureDic objectForKey:@"graphicQuarity"]objectAtIndex:indexPath.row];

        if(indexPath.row == [[NUSD objectForKey:kUserPreferredImageQuality] integerValue]){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4-03more_ checkmark"]];
            cell.accessoryView = imageView;
            [imageView release];
        }else{
            cell.accessoryView = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section==1)
    {
        cell.textLabel.text=[[_configureDic objectForKey:@"remindStyle"]objectAtIndex:indexPath.row];
//        if(indexPath.row == noticeType){
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4-03more_ checkmark"]];
//            cell.accessoryView = imageView;
//            [imageView release];
        if(cell.accessoryView == nil){
            UISwitch *aSwitch = [[UISwitch alloc] init];
            cell.accessoryView = aSwitch;
            if((indexPath.row == 0 && [[NUSD objectForKey:kUserPreferredNotice] boolValue])||
               (indexPath.row == 1 && [[NUSD objectForKey:kUserPreferredSound] boolValue])||
               (indexPath.row == 2 && [[NUSD objectForKey:kUserPreferredVibrate] boolValue])){
                aSwitch.on = YES;
            }else{
                aSwitch.on = NO;
            }
            aSwitch.tag = indexPath.row;
            [aSwitch addTarget:self action:@selector(onClickSwitch:) forControlEvents:UIControlEventValueChanged];
            [aSwitch release];
        }
//        }else{
//            cell.accessoryView = nil;
        //        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        cell.textLabel.text=[[_configureDic objectForKey:@"other"]objectAtIndex:indexPath.row];
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row != [[NUSD objectForKey:kUserPreferredImageQuality] integerValue]){
            [NUSD setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:kUserPreferredImageQuality];
            [NUSD synchronize];
            
//            imageQuality = indexPath.row;
            [self.moreConfigureTable reloadData];
            //重设AppDelegate下的取图质量标准值//
            //设置网络图片获取模式（其中判断网络连接状态）//
            [APP_DELEGATE updateUserPreferredImageQuality];
            //[NSThread detachNewThreadSelector:@selector(updateUserPreferredImageQuality) toTarget:self withObject:nil ];
            
        }
    }else if (indexPath.section == 1){
//        if(indexPath.row != noticeType){
//            [NUSD setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:kUserPreferredNoticeType];
//            [NUSD synchronize];
//            NSArray *arr = @[[NSIndexPath indexPathForRow:noticeType inSection:1],indexPath];
//            noticeType = indexPath.row;
//            [self.moreConfigureTable reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
        

        
//        [self.moreConfigureTable reloadData];
    }else if(indexPath.section == 2){
        if(indexPath.row == 0){//意见反馈
            FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
            feedback.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feedback animated:YES];
            [feedback release];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else if (indexPath.row == 1){//检查更新
            [self checkForNewVersion];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else if(indexPath.row == 2){//应用推荐
            AppRecommendListViewController *appRecommendListViewController=[[AppRecommendListViewController alloc]init];
            [self.navigationController pushViewController:appRecommendListViewController animated:YES];
            [appRecommendListViewController release];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}


- (void)checkForNewVersion{
    [CustomBezelActivityView activityViewForView:self.view withLabel:@"正在检查新版本..."];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
    [param setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
    
    [RemoteManager Posts:kGET_SYSTEM_INFO Parameters:param WithBlock:^(id json, NSError *error) {
        if(error == nil){
            [CustomBezelActivityView removeViewAnimated:YES];
            if([json[@"state"] integerValue] == 1){
                HuEasySystemInfo *info = [[HuEasySystemInfo alloc] initWithDictionary:json[@"subscriberSystemInfo"]];
                
                //TODO:版本比较
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"当前所用版本已是最新" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:nil otherBlock:nil];
                [alert show];
                [alert release];
                
                [info release];
            }else{
                NSLog(NSLocalizedString(@"请求参数错误", @""));
                NSLog(@"reason: %@",json[@"message"]);
                NSLog(@"params: %@", param);
            }
        }else{
            [CustomBezelActivityView removeViewAnimated:YES];
            NSLog(NSLocalizedString(@"网络故障", @""));
        }
    }];
    
    [param release];
}

#pragma mark - user click events
- (void)logout{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您将退出登录" delegate:self cancelButtonTitle:NSLocalizedString(@"取消",@"") destructiveButtonTitle:NSLocalizedString(@"确定",@"") otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if(buttonIndex == 0){
        [APP_DELEGATE loggedOut];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClickSwitch:(UISwitch *)sender
{
    if(sender.tag == 0){
        BOOL state = sender.on;
        [NUSD setObject:[NSNumber numberWithBool:state] forKey:kUserPreferredNotice];
    }else if(sender.tag == 1){
        BOOL state = sender.on;
        [NUSD setObject:[NSNumber numberWithBool:state] forKey:kUserPreferredSound];
    }else if(sender.tag == 2){
        BOOL state = sender.on;
        [NUSD setObject:[NSNumber numberWithBool:state] forKey:kUserPreferredVibrate];
    }
    [NUSD synchronize];
}

- (void)onClearCache:(id)sender{
    CGFloat size = [ZacCache getCurrentCacheFileSize];
    [ZacCache clear];
    
    ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"已清除手机上的%.2fMB缓存", size] cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:nil otherBlock:nil];
    [alert show];
    [alert release];
}
@end