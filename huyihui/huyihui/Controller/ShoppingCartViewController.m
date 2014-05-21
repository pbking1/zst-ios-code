//
//  ShoppingCartViewController.m
//  huyihui
//
//  Created by zaczh on 14-2-20.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "HomePageViewController.h"
#import "CheckOutCenterViewController.h"
#import "LoginViewController.h"

@interface ShoppingCartViewController ()
{
    UIButton *settleBtn;
    UIButton *allSelectBtn;
    int  totalNumber;
    float totalPrice;
    BOOL selectAll;
    UILabel *totalPriceLabel;
    UILabel *allSelectLabel;
    
    NSMutableSet *selectStatus;
    
    UIView *settleView;
    
    UIView *loginView;
}

@end

@implementation ShoppingCartViewController

@synthesize shoppingCartTable=_shoppingCartTable;
@synthesize mainTableViewController=_mainTableViewController;
@synthesize shoppingCartArr=_shoppingCartArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        totalNumber=0;
        totalPrice=0.00;
        selectAll=false;
        _shoppingCartArr= [[[HuEasyShoppingCart sharedInstance] mutableItems] copy];
        selectStatus = [NSMutableSet new];
//        for (int i=0; i<6; i++)
//        {
//            NSMutableDictionary *tmpDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         [NSNumber numberWithBool:false],@"selected",
//                                         [NSNumber numberWithInt:1],@"number",
//                                         [NSNumber numberWithInt:188],@"price",
//                                         nil];
//            
//            [_shoppingCartArr addObject:tmpDic];
//        }
    }
    
//    UIButton *leftBtn = [[ButtonFactory factory] createButtonWithType:HuEasyButtonTypeCancel];
//    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setFrame:CGRectMake(0, 0,40 , 30)];
//    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    ButtonFactory *buttonFactory = [ButtonFactory factory];
    UIButton *rightBtn = [buttonFactory createButtonWithType:HuEasyButtonTypeDelete];
    [rightBtn addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem release];
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [Util rgbColor:"F3F2F1"];
    _shoppingCartTable=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _shoppingCartTable.translatesAutoresizingMaskIntoConstraints = NO;
    
//    _shoppingCartTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _shoppingCartTable.delegate=self;
    _shoppingCartTable.dataSource=self;
    _shoppingCartTable.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_shoppingCartTable];
    [self.view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_shoppingCartTable attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:_shoppingCartTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:_shoppingCartTable attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:_shoppingCartTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-44.0]
                               ]];
                               
    
//    _mainTableViewController=[[UITableViewController alloc]init];
//    _mainTableViewController.tableView=_shoppingCartTable;
//    [self addChildViewController:_mainTableViewController];
//    
//    _mainTableViewController.refreshControl=[[[UIRefreshControl alloc]init]autorelease];
//    _mainTableViewController.refreshControl.attributedTitle=[[[NSAttributedString alloc]initWithString:@"下拉同步购物车列表" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}] autorelease];
//    [_mainTableViewController.refreshControl addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventValueChanged];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectZero];
    _shoppingCartTable.tableFooterView=headerView;
    [headerView release];
    
    [self createLoginView];
    
    [self createSettleView];
}

- (void)createSettleView{
    settleView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 44)];
    settleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [settleView setBackgroundColor:[UIColor colorWithWhite:0.945 alpha:1.000]];
    
    allSelectLabel=[[[UILabel alloc]initWithFrame:CGRectMake(36, 7, 40, 30)]autorelease];
    allSelectLabel.text=@"全选";
    allSelectLabel.backgroundColor = [UIColor clearColor];
    [allSelectLabel setFont:[UIFont systemFontOfSize:13]];
    [allSelectLabel setTextColor:[UIColor grayColor]];
    
    allSelectBtn=[[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [allSelectBtn setFrame:CGRectMake(5, 7, 30, 30)];
    [allSelectBtn.titleLabel setFrame:CGRectMake(30, 5, 30, 30)];
    [allSelectBtn.titleLabel setText:@"全选"];
    //[allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allSelectBtn setImage:[UIImage imageNamed:@"list_ticking options_normal"] forState:UIControlStateNormal];
    [allSelectBtn addTarget:self action:@selector(selectAllProduct:) forControlEvents:UIControlEventTouchUpInside];
    
    settleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [settleBtn setFrame:CGRectMake(SCREEN_WIDTH-100, 9, 80, 25)];
    [settleBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
    [settleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [settleBtn setBackgroundColor:[UIColor lightGrayColor]];
    [settleBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [settleBtn addTarget:self action:@selector(goCheckoutCenter) forControlEvents:UIControlEventTouchUpInside];
    
    totalPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 7, 120, 30)];
    totalPriceLabel.backgroundColor = [UIColor clearColor];
    totalPriceLabel.text=@"总计：0.00元";
    [totalPriceLabel setFont:[UIFont systemFontOfSize:13]];
    
    [settleView addSubview:allSelectBtn];
    [settleView addSubview:allSelectLabel];
    [settleView addSubview:totalPriceLabel];
    [settleView addSubview:settleBtn];
    
    //        self.shoppingCartTable.tableFooterView=settleView;
    [self.view addSubview:settleView];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0],
                                ]];
    [settleView addConstraint:[NSLayoutConstraint constraintWithItem:settleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0f]];
    [settleView release];
    
    settleView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self refreshView];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [loginView release];
    [settleView release];
    [allSelectBtn release];
    [settleBtn release];
    [totalPriceLabel release];
    [allSelectLabel release];
    [selectStatus release];
    self.shoppingCartTable=nil;
    [super dealloc];
}


- (void)refreshView{
    if(APP_DELEGATE.isLoggedIn){
        self.shoppingCartTable.tableHeaderView = nil;
    }else{
        self.shoppingCartTable.tableHeaderView = loginView;
    }
    self.shoppingCartArr = [[HuEasyShoppingCart sharedInstance] mutableItems];
    if(_shoppingCartArr.count > 0){
        _shoppingCartTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        settleView.hidden = NO;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }else{
        _shoppingCartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        settleView.hidden = YES;
        [selectStatus removeAllObjects];
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }
    
    [self.shoppingCartTable reloadData];
    
    [self updateSelectAllBtn];
    
    [self updatePriceLabel];
}

-(void)createLoginView
{
//    if (!APP_DELEGATE.isLoggedIn)
//    {
        loginView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [loginView setBackgroundColor:[UIColor colorWithRed:0.988 green:0.984 blue:0.906 alpha:1.000]];
        UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setFrame:CGRectMake(5, 7, 44, 25)];
        [loginBtn setBackgroundColor:[UIColor lightGrayColor]];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.layer.cornerRadius=5;
        [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *loginRemindLabel=[[[UILabel alloc]initWithFrame:CGRectMake(55, 4, SCREEN_WIDTH-55, 30)]autorelease];
        loginRemindLabel.text=@"您可以在登录后同步电脑与手机购物车中的商品";
        [loginRemindLabel setFont:[UIFont systemFontOfSize:12]];
        [loginRemindLabel setTextColor:[UIColor colorWithRed:0.780 green:0.569 blue:0.365 alpha:1.000]];
        loginRemindLabel.backgroundColor=[UIColor clearColor];
        
        [loginView addSubview:loginBtn];
        [loginView addSubview:loginRemindLabel];
        _shoppingCartTable.tableHeaderView=loginView;
//    }
//    else
//    {
//        [self getshoppingCartFromServer];
//        
//    }
    

}

#pragma mark -tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = _shoppingCartArr.count;
    if(count>0){
        return count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_shoppingCartArr.count == 0){
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  //return 44;
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_shoppingCartArr.count == 0){
        return self.view.frame.size.height;
    }
    
    if (indexPath.row==1)
    {
        return 60;
    }
    else
    {
        return 90;
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // return 44;
    return 0;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_shoppingCartArr.count == 0){
        return nil;
    }
    
    UIView *headView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]autorelease];
    UIButton *selectSectionAllBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectSectionAllBtn setFrame:CGRectMake(0, 0, 40, 40)];
    UILabel *storeName=[[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 40)]autorelease];
    [storeName setFont:[UIFont systemFontOfSize:13]];
    UIButton *editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(SCREEN_WIDTH-50, 0, 40, 40)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    [headView addSubview:selectSectionAllBtn];
    [headView addSubview:storeName];
    [headView addSubview:editBtn];
    
    storeName.text=@"大富豪数码";
    
    return headView;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    static NSString *footerIdentifier=@"footerCell";
    static NSString *placeHolderIdentifier=@"placeHolderIdentifier";
    
    UITableViewCell *cell=nil;
    UIButton *rightBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;

    if(_shoppingCartArr.count == 0){
        
        rightBtn.enabled = NO;
        
        //购物车为空，显示提示
        cell = [tableView dequeueReusableCellWithIdentifier:placeHolderIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeHolderIdentifier] autorelease];
            UIView *tablePlaceHolder = [[UIView alloc] initWithFrame:CGRectMake(96, 60, 128, 128)];
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3-01shopping cart_empty"]];
            [tablePlaceHolder addSubview:image];
            [image release];
            
            UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 20)];
            label0.font = [UIFont systemFontOfSize:15];
            label0.textAlignment = NSTextAlignmentCenter;
            label0.text = @"购物车暂无商品";
            label0.textColor = [Util rgbColor:"333333"];
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 320, 20)];
            label1.text = @"马上去添加";
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = [UIFont systemFontOfSize:12];
            label1.textColor = [Util rgbColor:"666666"];
            
            [cell.contentView addSubview:tablePlaceHolder];
            [cell.contentView addSubview:label0];
            [cell.contentView addSubview:label1];
            [label0 release];
            [label1 release];
            [tablePlaceHolder release];
            
            tableView.scrollEnabled = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [Util rgbColor:"F3F2F1"];
        return  cell;
    }
    rightBtn.enabled = YES;
    
    tableView.scrollEnabled = YES;
    if (indexPath.row!=([tableView numberOfRowsInSection:indexPath.section]-1))
    {
        [tableView registerNib:[UINib nibWithNibName:@"ShoppingCartItemCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
       cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        for (UIView *view in [cell.contentView subviews])
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *btn=(UIButton*)view;
                
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                if (btn.tag>=0)
                {
                    btn.tag=indexPath.section;
//                    if ([[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"selected"]boolValue])
                    if([selectStatus containsObject:[NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row]])
                    {
                        [btn setImage:[UIImage imageNamed:@"list_ticking options_push"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn setImage:[UIImage imageNamed:@"list_ticking options_normal"] forState:UIControlStateNormal];
                        
                    }
                    
                }
            }
            
            if ([view isKindOfClass:[UIImageView class]])
            {
                UIImageView *imageView=(UIImageView*)view;
//                [imageView setImage:[UIImage imageNamed:@"3-05Share_list__Material picture"]];
                //取图质量//0：2G/3G(标清图),1：wifi（高清图）
                NSString *imagePath = @"";
                if (APP_DELEGATE.userPreferredImageQuality_Value == 0)
                {
                    //picturePath
                    imagePath = [NSString stringWithFormat:@"%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"picturePath"]];
                }
                else if (APP_DELEGATE.userPreferredImageQuality_Value == 1)
                {
                    //picturePath2G3G
                    imagePath = [NSString stringWithFormat:@"%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"picturePath2G3G"]];
                }
                else if (APP_DELEGATE.userPreferredImageQuality_Value == 2)
                {
                    //picturePathWifi
                    imagePath = [NSString stringWithFormat:@"%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"picturePathWifi"]];
                }
                [Util UIImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGE_FILE_SERVER,imagePath]] withImageBlock:^(UIImage *image) {
                    imageView.image = image;
                } errorBlock:^{
                    NSLog(@"载入图片失败");
                }];
                
                UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductDetail:)];
                
                imageView.tag = indexPath.section;
                imageView.userInteractionEnabled = YES;
                [imageView addGestureRecognizer:tapGesturRecognizer];
            }
            if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField=(UITextField*)view;
                textField.tag = indexPath.section;
                textField.layer.borderWidth=1;
                textField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                textField.text=[NSString stringWithFormat:@"%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"prodNumber"]];
                textField.keyboardType=UIKeyboardTypeNumberPad;
                textField.tag=indexPath.section;
                textField.delegate = self;
            }
        }
        
        UILabel *priceLabel=(UILabel *)[cell viewWithTag:5];
        UILabel *productNameLabel=(UILabel *)[cell viewWithTag:6];
        UILabel *productSpecLabel=(UILabel *)[cell viewWithTag:7];
        if ([_shoppingCartArr count])
        {
            priceLabel.text=[NSString stringWithFormat:@"￥%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"specialPrice"]];
            productNameLabel.text=[NSString stringWithFormat:@"%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"prodName"]];
            productSpecLabel.text=[NSString stringWithFormat:@"%@",[[_shoppingCartArr objectAtIndex:indexPath.section]objectForKey:@"prodSpec"]];
            
            UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductDetail:)];
            
            productNameLabel.tag = indexPath.section;
            productNameLabel.userInteractionEnabled = YES;
            [productNameLabel addGestureRecognizer:tapGesturRecognizer];
        }
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:footerIdentifier];
        if (cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:footerIdentifier]autorelease];
            
            UIView *footerView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)]autorelease];
//            UILabel *advertiseLabel=[[[UILabel alloc]initWithFrame:CGRectMake(17, 18, 120, 25)]autorelease];
//            advertiseLabel.tag = 1;
            UILabel *shuliangLabel=[[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 0, 60, 25)]autorelease];
            shuliangLabel.tag = 2;
            UILabel *numberLabel=[[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 60, 25)]autorelease];
            numberLabel.tag = 3;
            UILabel *hejiLabel=[[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 25, 60, 25)]autorelease];
            UILabel *totalLabel=[[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 25, 100, 25)]autorelease];
            totalLabel.textAlignment = NSTextAlignmentRight;
            totalLabel.tag = 4;
            [totalLabel setTextColor:[UIColor redColor]];
            
//            [advertiseLabel setFont:[UIFont systemFontOfSize:13]];
            [shuliangLabel setFont:[UIFont systemFontOfSize:13]];
            [numberLabel setFont:[UIFont systemFontOfSize:13]];
            [hejiLabel setFont:[UIFont systemFontOfSize:13]];
            [totalLabel setFont:[UIFont systemFontOfSize:13]];
            
//            [advertiseLabel setTextColor:[Util rgbColor:"6D6D6D"]];
            [shuliangLabel setTextColor:[Util rgbColor:"6D6D6D"]];
            [hejiLabel setTextColor:[Util rgbColor:"6D6D6D"]];
            [numberLabel setTextColor:[Util rgbColor:"6D6D6D"]];
            
            UIView *sectionView=[[[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 10)]autorelease];
            [sectionView setBackgroundColor:[UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1.000]];
            
//            [footerView addSubview:advertiseLabel];
            [footerView addSubview:shuliangLabel];
            [footerView addSubview:numberLabel];
            [footerView addSubview:hejiLabel];
            [footerView addSubview:totalLabel];
            [footerView addSubview:sectionView];
            [cell.contentView addSubview:footerView];

//            advertiseLabel.text=@"满200元，免运费";
            
            
            shuliangLabel.text=@"数量";
            hejiLabel.text=@"总价";

        }

        UILabel *numberLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *totalLabel = (UILabel *)[cell.contentView viewWithTag:4];
        NSInteger quantity = [_shoppingCartArr[indexPath.section][@"prodNumber"] integerValue];
        numberLabel.text=[NSString stringWithFormat:@"X%d", quantity];
        CGFloat price = [_shoppingCartArr[indexPath.section][@"specialPrice"] floatValue];
        totalLabel.text=[NSString stringWithFormat:@"￥%.2f",price * quantity];
    }
    
  //  cell.backgroundView=[[[UIView alloc] initWithFrame:cell.bounds] autorelease];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHidden:)];
    [_shoppingCartTable addGestureRecognizer:tap];
    [tap release];

    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shoppingCartArr.count == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        APP_DELEGATE.tabs.selectedIndex = 0;
    }
}

-(void)onDelete:(id)sender
{
    if (selectStatus.count > 0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"删除商品" message:@"确定从购物车中删除所有选中商品？"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"删除商品" message:@"没有选中的订单"delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSLog(@"确定删除");
        [CustomBezelActivityView activityViewForView:self.view withLabel:@"请稍候"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        NSMutableArray *itemsToDelete = [NSMutableArray array];
        for(NSString *item in selectStatus){
            NSInteger section =[[item componentsSeparatedByString:@"-"][0] integerValue];
            [itemsToDelete addObject:_shoppingCartArr[section]];
//            [[HuEasyShoppingCart sharedInstance] removeItemBySpeciesId:_shoppingCartArr[section][@"speciesId"]
//                                                                andSku:_shoppingCartArr[section][@"sku"]
//                                                               success:^(){
//                                                                   [self refreshView];
//                                                               }
//                                                               failure:nil];
        }
            [[HuEasyShoppingCart sharedInstance] removeItems:[[itemsToDelete copy] autorelease] completion:^(NSError *error) {
                [selectStatus removeAllObjects];
                [self refreshView];
                [CustomBezelActivityView removeViewAnimated:YES];
            }];
        });
    }
    else
    {
        NSLog(@"取消删除");
        
    }
}
-(void)tapHidden:(id)sender
{
    
  [_shoppingCartTable resignFirstResponder];
    

    
}

-(void)btnAction:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    if (btn.tag<0)
    {
        for (UIView *view in [[btn superview]subviews])
        {
            if ([view isKindOfClass:[UITextField class]])
            {
                [CustomBezelActivityView activityViewForView:self.view withLabel:@""];
                NSInteger currentNum = [((UITextField*)view).text integerValue];
                if (btn.tag==-1)
                {
                    if(currentNum<2){
                        [CustomBezelActivityView removeViewAnimated:YES];
                        [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:NSLocalizedString(@"product_wrong_num", @"更改商品数量失败，商品已无库存")  duration:1.0f];
                        return;
                    }else{
                        currentNum--;
                    }
                }
                else
                {
                    currentNum++;

                }
                [CustomBezelActivityView activityViewForView:self.view withLabel:@""];
                [[HuEasyShoppingCart sharedInstance] updateQuantityOfSpeciesId:_shoppingCartArr[view.tag][@"speciesId"]
                                                                        andSku:_shoppingCartArr[view.tag][@"sku"]
                                                                      quantity:currentNum
                                                                       success:^{
                                                                           [self refreshView];
                                                                           [CustomBezelActivityView removeViewAnimated:YES];
                                                                           ((UITextField*)view).text=[NSString stringWithFormat:@"%ld", (long)currentNum];
                                                                       }
                                                                       failure:^{
                                                                           [CustomBezelActivityView removeViewAnimated:YES];
                                                                           [ZacNoticeView showAtYPosition:SCREEN_HEIGHT - 200 type:1 text:@"商品数量超过库存上限" duration:1.0];
                                                                       }];
                
            }
        }
    }
    else
    {
        BOOL selected;
        NSString *indexPathStr = [NSString stringWithFormat:@"%ld-%d",(long)btn.tag,0];
        if([selectStatus containsObject:indexPathStr]){
            [selectStatus removeObject:indexPathStr];
            selected = YES;
        }else{
            [selectStatus addObject:indexPathStr];
            selected = NO;
        }
//        [[_shoppingCartArr objectAtIndex:btn.tag] setObject:[NSNumber numberWithBool: !selected] forKey:@"selected"];
        if(!selected)
        {
            totalNumber+=[[[_shoppingCartArr objectAtIndex:btn.tag]objectForKey:@"prodNumber"]intValue];
            [settleBtn setTitle:[NSString stringWithFormat:@"结算（%d）",totalNumber] forState:UIControlStateNormal];
            
            totalPrice+=[[[_shoppingCartArr objectAtIndex:btn.tag]objectForKey:@"specialPrice"]intValue]*[[[_shoppingCartArr objectAtIndex:btn.tag]objectForKey:@"prodNumber"]intValue];
            [totalPriceLabel setText:[NSString stringWithFormat:@"合计：%.2f元",totalPrice] ];
            
        }
        else
        {
            totalNumber-=[[[_shoppingCartArr objectAtIndex:btn.tag]objectForKey:@"prodNumber"]intValue];
            [settleBtn setTitle:[NSString stringWithFormat:@"结算（%d）",totalNumber] forState:UIControlStateNormal];
            
            totalPrice-=[[[_shoppingCartArr objectAtIndex:btn.tag]objectForKey:@"specialPrice"]intValue]*[[[_shoppingCartArr objectAtIndex:btn.tag]objectForKey:@"prodNumber"]intValue];;
            [totalPriceLabel setText:[NSString stringWithFormat:@"合计：%.2f元",totalPrice] ];
            
            
        }
        if (totalNumber>0)
        {
//            [settleBtn setBackgroundColor:[UIColor redColor]];
//            [settleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [totalPriceLabel setTextColor:[UIColor redColor]];
        }
        else
        {
//            [settleBtn setBackgroundColor:[UIColor lightGrayColor]];
//            [settleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [totalPriceLabel setTextColor:[UIColor grayColor]];
        }
        
        [self updateSelectAllBtn];
        
    }
    
    [self reloadDataSourceAndTable];
   
}

- (void)reloadDataSourceAndTable{
    self.shoppingCartArr= [[HuEasyShoppingCart sharedInstance] mutableItems];
    [_shoppingCartTable reloadData];
    [self updatePriceLabel];
}

- (void)updateSelectAllBtn{
    //更新全选按钮的状态
    if(selectStatus.count == _shoppingCartArr.count){
        [self doSelectAllItems:YES];
        selectAll = YES;
    }else{
        [self doSelectAllItems:NO];
        selectAll = NO;
    }
}

- (void)doSelectAllItems:(BOOL)isSelectAll{
    if(isSelectAll){
        [allSelectBtn setImage:[UIImage imageNamed:@"list_ticking options_push" ] forState:UIControlStateNormal];
        [allSelectLabel setTextColor:[UIColor redColor]];
    }else{
        [allSelectBtn setImage:[UIImage imageNamed:@"list_ticking options_normal"] forState:UIControlStateNormal];
        [allSelectLabel setTextColor:[UIColor grayColor]];
    }
    
    if(selectStatus.count >0){
        settleBtn.enabled = YES;
        [settleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [settleBtn setBackgroundColor:[UIColor redColor]];
    }else{
        [settleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [settleBtn setBackgroundColor:[UIColor lightGrayColor]];
        settleBtn.enabled = NO;
    }
}


- (void)updatePriceLabel{
    CGFloat gross = .0;
    int count = 0;
    for(NSString *item in selectStatus){
        NSInteger section =[[item componentsSeparatedByString:@"-"][0] integerValue];
        count += [_shoppingCartArr[section][@"prodNumber"] integerValue];
        gross += [_shoppingCartArr[section][@"prodNumber"] integerValue] * [_shoppingCartArr[section][@"specialPrice"] floatValue];
    }
    totalPriceLabel.text=[NSString stringWithFormat:@"总计：%.2f",gross];
    [settleBtn setTitle:[NSString stringWithFormat:@"结算（%d）",count] forState:UIControlStateNormal];
    
}

-(void)selectAllProduct:(id)sender
{
    selectAll=!selectAll;
    if (selectAll)
    {
//        totalNumber=0;
//        totalPrice=0;
//        for (NSMutableDictionary *dic in _shoppingCartArr){
            for (int i=0; i<_shoppingCartArr.count; i++){
                [selectStatus addObject:[NSString stringWithFormat:@"%d-%d", i, 0]];
            }
//            totalNumber+=[[dic objectForKey:@"prodNumber"]intValue];
//            totalPrice+=[[dic objectForKey:@"specialPrice"]floatValue]*[[dic objectForKey:@"prodNumber"]intValue];
//        }
//        [totalPriceLabel setTextColor:[UIColor redColor]];
//        totalPriceLabel.text=[NSString stringWithFormat:@"总计：%.2f",totalPrice];
//        [settleBtn setTitle:[NSString stringWithFormat:@"结算（%d）",totalNumber] forState:UIControlStateNormal];
        
        [self doSelectAllItems:YES];
    }
    else
    {
//        totalNumber=0;
//        totalPrice=0;
        [selectStatus removeAllObjects];
//        [totalPriceLabel setTextColor:[UIColor grayColor]];
//        totalPriceLabel.text=[NSString stringWithFormat:@"总计：%.2f",totalPrice];
//        [settleBtn setTitle:[NSString stringWithFormat:@"结算（%d）",totalNumber] forState:UIControlStateNormal];
        [self doSelectAllItems:NO];
    }
    
    [self reloadDataSourceAndTable];
}

-(void)goCheckoutCenter
{
    void (^block)() = ^(){
        NSMutableArray *selectedItems = [NSMutableArray new];
        
        [selectStatus enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSInteger section =[[obj componentsSeparatedByString:@"-"][0] integerValue];
            [selectedItems addObject:_shoppingCartArr[section]];
        }];
        
        CheckOutCenterViewController *checkOutCenter=[[CheckOutCenterViewController alloc]initWithProducts:selectedItems];
        [selectedItems release];
        
        checkOutCenter.hidesBottomBarWhenPushed=YES;
        checkOutCenter.title=@"结算中心";
        [self.navigationController pushViewController:checkOutCenter animated:YES];
        [checkOutCenter release];
    };
    
    if(!APP_DELEGATE.isLoggedIn){
        LoginViewController *login = [[LoginViewController alloc] init];
        login.successBlock = block;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
        [login release];
        [self presentViewController:navi animated:YES completion:nil];
        [navi release];
    }else{
        block();
    }
    

}


//-(void)doRefresh
//{
//    
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 44;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

-(void)loginAction:(id)sender
{
    
    LoginViewController *loginViewCtrl=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    loginViewCtrl.successBlock = ^{
        [self refreshView];
    };
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:loginViewCtrl];
    
    
    [self presentViewController:nav animated:YES completion:nil];
    [loginViewCtrl release];
    [nav release];
    
}

//-(void)getshoppingCartFromServer
//{
//    @autoreleasepool
//    {
//        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//        [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
//        [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
//        [params setObject:[NSNumber numberWithInt:2] forKey:@"num"];
//        [params setObject:[NSNumber numberWithInt:1] forKey:@"pageIndex"];
//        [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
//        
//        [RemoteManager Posts:kGET_CART_INFO Parameters:params WithBlock:^(id json, NSError *error) {
//            if (!error)
//            {
////                NSLog(@"%@",json);
//                
//                if ([json  objectForKey:@"cartList"])
//                {
//                    for (NSDictionary *dic in [json  objectForKey:@"cartList"])
//                    {
//                        [self.shoppingCartArr removeAllObjects];
//                        NSMutableDictionary *tmpDic=[NSMutableDictionary dictionaryWithDictionary:dic];
//                        [tmpDic setObject:[NSNumber numberWithBool:false] forKey:@"selected"];
//                        [self.shoppingCartArr addObject:tmpDic];
//                        
//                        [self performSelectorInBackground:@selector(mergeShoppingCart) withObject:nil];
//                    }
//                    
//                    
//                }
//                
//                [self.shoppingCartTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//            }
//        }];
//        
//        
//    }
//    
//}

-(void)changeProductNumberFromServer:(NSDictionary*)productDic
{
    @autoreleasepool
    {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:[NUSD objectForKey:kMerchantId] forKey:@"merchantId"];
        [params setObject:[NUSD objectForKey:kCurrentUserId] forKey:@"userKo"];
        [params setObject:[NUSD objectForKey:kCurrentUserToken] forKey:@"token"];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"flag"];
        [params setObject:[productDic objectForKey:@"speciesId"] forKey:@"speciesId"];
        [params setObject:[productDic objectForKey:@"sku"] forKey:@"sku"];
        [params setObject:[productDic objectForKey:@"prodNumber"] forKey:@"preBuyNum"];
        int number=[[productDic objectForKey:@"prodNumber"]intValue]-1;
        [params setObject:[NSNumber numberWithInt:number] forKey:@"nowBuyNum"];
        
        if (number>1)
        {
            [RemoteManager Posts:kCHANGE_AMOUNT Parameters:params WithBlock:^(id json, NSError *error) {
                if (error==nil)
                {
                    NSLog(@"%@",json);
                }
            }];

        }
        [params release];
        
    }
    
}



//-(BOOL) allowsFooterViewsToFloat
//{
//    return NO;
//}

#pragma mark - textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"修改数量" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"完成" cancelBlock:nil otherBlock:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    tf.text=textField.text;//取原来的数字填充进去
    alert.otherBlock = ^{
        NSInteger count = [[[alert textFieldAtIndex:0] text] integerValue];
        
        if (([textField.text integerValue] != count) && (count > 0))
        {
            if(count < 1){
                count = 1;
            }
            //        NSLog(@"___shopping cart item info_____:%@",_shoppingCartArr[textField.tag]);
            [[HuEasyShoppingCart sharedInstance] updateQuantityOfSpeciesId:_shoppingCartArr[textField.tag][@"speciesId"] andSku:_shoppingCartArr[textField.tag][@"sku"] quantity:count success:^{
                textField.text = [NSString stringWithFormat:@"%d",count];
                NSMutableDictionary *dict = _shoppingCartArr[textField.tag];
                [dict setObject:[NSNumber numberWithInteger:count] forKey:@"prodNumber"];
                [self refreshView];
            } failure:^{
                [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:NSLocalizedString(@"product_no_store", @"更改商品数量失败，商品已无库存")  duration:1.0f];
            }];
        }
        else if (count == 0)
        {
            [ZacNoticeView showAtYPosition:SCREEN_HEIGHT/2.0 type:1 text:NSLocalizedString(@"product_wrong_num", @"更改商品数量失败，商品已无库存")  duration:1.0f];
        }
    };
    [alert show];
    [alert release];
    return NO;
}

#pragma mark - 跳转商品详情
- (void)showProductDetail:(id)sender
{
    NSLog(@"跳转商品详情%i", ((UITapGestureRecognizer *)sender).view.tag);
    
    int i = ((UITapGestureRecognizer *)sender).view.tag;
    NSDictionary *tmpDic = [_shoppingCartArr objectAtIndex:i];
    
    
    NSMutableDictionary *decDic = [[NSMutableDictionary alloc] init];
////                                   @"", @"avgScore",
////                                   @"", @"brandName",
////                                   @"", @"createTime",
//                                   [tmpDic objectForKey:@""], @"",
//                                  [tmpDic objectForKey:@""], @"",
//                                   [tmpDic objectForKey:@""], @"",
//                                   [tmpDic objectForKey:@""], @"",
////                                   @"", @"merchantName",
//                                   [tmpDic objectForKey:@""], @"",
//                                   [tmpDic objectForKey:@""], @"",
////                                   @"", @"promId",
////                                   @"", @"promName",
////                                   @"", @"sales",
////                                   @"", @"scoreId",
////                                   @"", @"serial",
////                                   @"", @"speciDesc",
//                                    ,
//                                   [tmpDic objectForKey:@""], @"",
//                                   [tmpDic objectForKey:@""], @"speciesDescTable",
//                                   [tmpDic objectForKey:@"speciesId"], @"",
//                                   [tmpDic objectForKey:@"specificationId"], @"specificationId",
//                                   @"", @"tag",
////                                   @"", @"type",
////                                   @"", @"typeName",
//                                   nil];
//    HuEasyProductTypeOrdinary
    [decDic setObject:[tmpDic objectForKey:@"picturePath"] forKey:@"mathPath"];
    [decDic setObject:[tmpDic objectForKey:@"picturePathWifi"] forKey:@"mathPathWifi"];
    [decDic setObject:[tmpDic objectForKey:@"retailPrice"] forKey:@"maxRetailPrice"];
    [decDic setObject:[tmpDic objectForKey:@"specialPrice"] forKey:@"maxSalePrice"];
    [decDic setObject:[tmpDic objectForKey:@"retailPrice"] forKey:@"minRetailPrice"];
    [decDic setObject:[tmpDic objectForKey:@"specialPrice"] forKey:@"minSalePrice"];
    [decDic setObject:[tmpDic objectForKey:@"prodName"] forKey:@"speciName"];
    [decDic setObject:[tmpDic objectForKey:@"speciesId"] forKey:@"speciesId"];
    [decDic setObject:[tmpDic objectForKey:@"specificationId"] forKey:@"specificationId"];
    GroupBuyItemDetailViewController *detailView = [[GroupBuyItemDetailViewController alloc] initWithProductInfo:decDic andType:[[tmpDic objectForKey:@"teamFlag"] intValue]];

    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];
    
    [decDic release];
}

@end
