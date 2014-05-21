//
//  ChooseReceiptType.m
//  huyihui
//
//  Created by zaczh on 14-4-8.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ChooseReceiptType.h"

@interface ChooseReceiptType ()
@property (nonatomic, copy) void (^completionBlock)(NSDictionary *);
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) UITableView *table;
@end

@implementation ChooseReceiptType
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithSelectedIndex:(NSInteger)index completion:(void (^)(NSDictionary *res))completionBlock
{
    self = [super init];
    if(self){
        self.selectedIndex = index;
        self.completionBlock = Block_copy(completionBlock);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Util rgbColor:"f3f2f1"];
    
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 50,45)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *saveItem=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem=saveItem;
    [saveItem release];
    [saveBtn addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:table];
    [self.view addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeTop multiplier:1.0 constant:.0],
                               [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:table attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0]
                               ]];
    [table release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    Block_release(_completionBlock);
    [super dealloc];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"开具发票";
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 30.0f;
    }else{
        return .0001f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = [UIColor whiteColor];
//            cell.layer.borderWidth = 0.3f;
            cell.layer.borderColor = [[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0f] CGColor];
        }
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"否";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"是";
        }
        
        if(self.selectedIndex == indexPath.row){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4-03more_ checkmark"]];
            cell.accessoryView = imageView;
            [imageView release];
        }else{
            cell.accessoryView = nil;
        }
        
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellIdentifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = [UIColor whiteColor];
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = [[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0f] CGColor];
            
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(80, 7, SCREEN_WIDTH - 10, 30)];
            text.tag = 555;
            text.delegate = self;
            text.font =[UIFont systemFontOfSize:15];
            text.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            text.text = self.receiptStr;
            [cell.contentView addSubview:text];
            [text release];
        }
        cell.textLabel.text = @"发票抬头";
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        self.selectedIndex = indexPath.row;

        [tableView reloadData];
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    if(self.completionBlock != nil){
//        self.completionBlock(@{@"value":[NSNumber numberWithInteger:self.selectedIndex],@"receiptHeader":textField.text});
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//    return YES;
//}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (self.selectedIndex == 0)
//    {
//        return  NO;
//    }
//    return YES;
//}

- (void)onSave:(id)sender{
    if(self.selectedIndex == 1){
        if(self.completionBlock != nil){
            UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            UITextField *textField = (UITextField *)[cell.contentView viewWithTag:555];
            if([textField.text isEqualToString:@""]){
                ZacAlertView *alert = [[ZacAlertView alloc] initWithTitle:@"提示" message:@"请填写发票抬头" cancelButtonTitle:@"确定" otherButtonTitle:nil cancelBlock:nil otherBlock:nil];
                [alert show];
                [alert release];
                return;
            }
            self.completionBlock(@{@"value":@1,@"receiptHeader":textField.text});
        }
    }else{
        self.completionBlock(@{@"value":@0,@"receiptHeader":@""});
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
