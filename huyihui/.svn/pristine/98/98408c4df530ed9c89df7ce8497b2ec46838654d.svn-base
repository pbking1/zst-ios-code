//
//  ZacFloatInputView.m
//  huyihui
//
//  Created by zaczh on 14-4-3.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "ZacFloatInputView.h"

@interface ZacFloatInputView()
{
    UIView *overlay;
    
    UIView *mainView;
    UILabel *titleLabel;
    UITextField *textField;
    UIButton *closeButton;
    UIButton *increaseButton;
    UIButton *decreaseButton;
    UIButton *cancelButton;
    UIButton *doneButton;
    
    id me;
    
    NSString *tfInitValue;
    NSString *tfMaxValue;
    void (^completeBlock)(NSString *);
}

@end

@implementation ZacFloatInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        me = [self retain];
        overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        overlay.backgroundColor = [UIColor grayColor];
        overlay.alpha = .9;
        [self addSubview:overlay];
        
        mainView = [[UIView alloc] initWithFrame:CGRectMake(20, 122, 280, 120)];
        mainView.backgroundColor = [UIColor brownColor];
        [overlay addSubview:mainView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 208, 20)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [mainView addSubview:titleLabel];

        decreaseButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 40, 20, 20)];
        [decreaseButton setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]];
        [decreaseButton setTitle:@"-" forState:UIControlStateNormal];
        [decreaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        decreaseButton.enabled = NO;
        [mainView addSubview:decreaseButton];
        
        increaseButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 40, 20, 20)];
        [increaseButton setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:242.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [increaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [increaseButton setTitle:@"+" forState:UIControlStateNormal];
        [mainView addSubview:increaseButton];
        
        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 0, 20, 20)];
        [closeButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.backgroundColor = [UIColor redColor];
        [mainView addSubview:closeButton];
        
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(116, 40, 60, 20)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:13];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [mainView addSubview:textField];
        
        
        
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
       initialValue:(NSString *)initialValue
           maxValue:(NSString *)maxValue
         completion:(void (^)(NSString *))block
{
    self = [super init];
    if(self){
        completeBlock = Block_copy(block);
        titleLabel.text = title;
        textField.text = initialValue;
        tfMaxValue = [maxValue copy];
        [textField becomeFirstResponder];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
       initialValue:(NSString *)initialValue
           maxValue:(NSString *)maxValue
           delegate:(id<ZacFloatInputViewDelegate>)delegate;
{
    self = [super init];
    if(self){
        self.delegate = delegate;
        titleLabel.text = title;
        textField.text = initialValue;
        tfMaxValue = [maxValue copy];
        [textField becomeFirstResponder];
    }
    return self;
}

- (void)dealloc{
    [overlay release];
    [mainView release];
    [titleLabel release];
    [textField release];
    [closeButton release];
    [me release];
    [tfInitValue release];
    [tfMaxValue release];
    
    if(completeBlock != nil){
        Block_release(completeBlock);
    }
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)onClose:(id)sender
{
    if(completeBlock != nil){
        if(textField.text == nil || [textField.text isEqualToString:@""]){
            completeBlock(@"0");
        }else{
            completeBlock(textField.text);
        }
    }
    [overlay removeFromSuperview];
    [me release];
}



- (void)show;
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.window addSubview:overlay];
}

- (BOOL)textField:(UITextField *)atextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [atextField.text stringByReplacingCharactersInRange:range withString:string];
    if([str longLongValue] < [tfMaxValue longLongValue]){
        atextField.text = [NSString stringWithFormat:@"%lld",[str longLongValue]];
    }
    return NO;
}
@end
