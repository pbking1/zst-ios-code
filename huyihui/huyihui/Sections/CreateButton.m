//
//  CreateButton.m
//  huyihui
//
//  Created by linyi on 14-3-6.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "CreateButton.h"

@implementation CreateButton

@synthesize type = _type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithType:(HuEasyButtonType)type{
    self = [super init];
    self.type = type;
    
    [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    if (type == HuEasyButtonTypeBack)
    {
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            self.frame = CGRectMake(0, 2, 50, 40);
        }else{
            self.frame = CGRectMake(0, 2, 70, 40);
        }
        [self setTitle:@"返回" forState:UIControlStateNormal];
        [self setTitle:@"返回" forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"nav_back_highlight"] forState:UIControlStateHighlighted];
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, -20, 10, 0)];

//        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    else if (_type == HuEasyButtonTypeCancel)
    {
//        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            self.frame = CGRectMake(0, 2, 50, 40);
//        }else{
//            self.frame = CGRectMake(0, 2, 70, 40);
//        }
        [self setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateHighlighted];
    }
    else if (_type == SEARCHBUTTON)
    {
        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
    else if (_type == SHAREBUTTON)
    {
        [self setTitle:@"分享" forState:UIControlStateNormal];
        [self setTitle:@"分享" forState:UIControlStateHighlighted];
    }
    else if (_type == CONFIRMBUTTON)
    {
        self.frame = CGRectMake(0, 12, 40, 20);
        [self setTitle:@"确定" forState:UIControlStateNormal];
        [self setTitle:@"确定" forState:UIControlStateHighlighted];
    }
    else if (_type == ACTIVEBUTTON)
    {
        self.frame = CGRectMake(0, 0, 40, 44);
        [self setTitle:@"激活" forState:UIControlStateNormal];
        [self setTitle:@"激活" forState:UIControlStateHighlighted];
    }
    else if (_type == HuEasyButtonTypeDone)
    {
        self.frame = CGRectMake(0, 0, 40, 44);
        [self setTitle:@"完成" forState:UIControlStateNormal];
        [self setTitle:@"完成" forState:UIControlStateHighlighted];
    }
    else if (_type == FILTERBUTTON)
    {
        [self setTitle:@"筛选" forState:UIControlStateNormal];
        [self setTitle:@"筛选" forState:UIControlStateHighlighted];
    }
    else if (_type == SENDBUTTON)
    {
        [self setTitle:@"发送" forState:UIControlStateNormal];
        [self setTitle:@"发送" forState:UIControlStateHighlighted];
    }
    else if (_type == HuEasyButtonTypeMore)
    {
        self.frame = CGRectMake(0, 0, 40, 44);
        [self setTitle:@"更多" forState:UIControlStateNormal];
        [self setTitle:@"更多" forState:UIControlStateHighlighted];
        
    }else if (_type == BACKTOMAINPAGE)  //?
    {
        self.frame = CGRectMake(50, 50, 40, 44);
        [self setTitle:@"返回主页" forState:UIControlStateNormal];
        [self setTitle:@"返回主页" forState:UIControlStateHighlighted];
        
    }else if (_type == HuEasyButtonTypeDelete){
        self.frame = CGRectMake(0, 0, 40, 44);
        [self setTitle:NSLocalizedString(@"删除" ,@"") forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"删除" ,@"") forState:UIControlStateHighlighted];
    }else if (_type == HuEasyButtonTypeRefresh){
        self.frame = CGRectMake(0, 0, 40, 44);
        [self setTitle:NSLocalizedString(@"刷新" ,@"") forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"刷新" ,@"") forState:UIControlStateHighlighted];
    }
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
    // Drawing code

//}

- (void)onClick:(CreateButton *)sender{
    if(self.clickHandler != NULL){
        self.clickHandler();
    }
}

- (void)dealloc{
    self.clickHandler = nil;
    [super dealloc];
}

@end
