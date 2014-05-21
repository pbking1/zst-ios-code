//
//  ChoosePayMeansViewController.m
//  huyihui
//
//  Created by zaczh on 14-4-8.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ChoosePayMeansViewController.h"

@interface ChoosePayMeansViewController ()
@property (nonatomic, copy) void (^completionBlock)(NSDictionary *);
@property (nonatomic, copy) NSArray *options;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ChoosePayMeansViewController

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
    // Do any additional setup after loading the view.
//    self.title = @"选择支付方式";
    self.view.backgroundColor = [Util rgbColor:"f3f2f1"];
    
    UITableView *table = [UITableView new];
    table.scrollEnabled = NO;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.sectionHeaderHeight = 10.0f;
    table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:table];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeTop multiplier:1.0 constant:-20.0],
                                [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0]
                                ]];
}

- (id)initWithOptions:(NSArray *)options selectedIndex:(NSInteger)index completion:(void (^)(NSDictionary *res))completionBlock
{
    self = [super init];
    if(self){
        _options = [options copy];
        _completionBlock = Block_copy(completionBlock);
        _selectedIndex = index;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.options.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0f] CGColor];
    }
    cell.textLabel.text = self.options[indexPath.section][@"display"];

    if(self.selectedIndex == [self.options[indexPath.section][@"value"] integerValue]){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4-03more_ checkmark"]];
        imageView.backgroundColor = [UIColor clearColor];
        cell.accessoryView = imageView;
        [imageView release];
    }else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.selectedIndex = indexPath.section;
//    [tableView reloadData];
    if(self.completionBlock != nil){
        self.completionBlock(self.options[indexPath.section]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
