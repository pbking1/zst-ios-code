//
//  BuyerRemark.m
//  huyihui
//
//  Created by zaczh on 14-4-10.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BuyerRemark.h"

@interface BuyerRemark (){
    UITextView *remarkTextView;
    NSString *originText;
    UILabel *letterNumLabel;
}
@end

@implementation BuyerRemark

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _maxLength = 140;
    }
    return self;
}

- (id)initWithText:(NSString *)text{
    self = [super init];
    if (self) {
        // Custom initialization
        originText = [text copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Util rgbColor:"f3f2f1"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.text = @"请输入给卖家的留言：";
    [self.view addSubview:title];
    [title release];
    
    letterNumLabel= [[UILabel alloc] initWithFrame:CGRectMake(20+200, 10, 320-(20+200)-20, 20)];
    letterNumLabel.textAlignment=NSTextAlignmentRight;
    letterNumLabel.font =[UIFont systemFontOfSize:15];
    letterNumLabel.text = [NSString stringWithFormat:@"%d/%d",originText.length,_maxLength];
    [self.view addSubview:letterNumLabel];
    [letterNumLabel release];
    
    remarkTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, 280, 80)];
    remarkTextView.delegate = self;
    //remarkTextView.scrollEnabled = NO;
    remarkTextView.backgroundColor = [UIColor whiteColor];
    remarkTextView.font = [UIFont systemFontOfSize:13];
    remarkTextView.text = originText;
    [self.view addSubview:remarkTextView];
    
    UIButton *rightBtn = [[ButtonFactory factory] createButtonWithType:HuEasyButtonTypeDone];
    [rightBtn addTarget:self action:@selector(onDone:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBtn] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [remarkTextView release];
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

- (void)onDone:(id)sender
{
    if(self.completionBlock != nil){
        self.completionBlock(remarkTextView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//{
//    if(textView.text.length>=_maxLength){
//        return NO;
//    }else{
//        return YES;
//    }
//}
////////////////////textView的限制字数设置//////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if(string.length>_maxLength){
        string=[string substringToIndex:_maxLength];
        textView.text=string;
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    letterNumLabel.text=[NSString stringWithFormat:@"%d/%d",textView.text.length,_maxLength];
}

@end
