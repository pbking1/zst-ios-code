//
//  ReceiveAddressController.h
//  huyihui
//
//  Created by zhangmeifu on 6/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiveAddressController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *receiveAddressTable;

@property (assign,nonatomic) BOOL isEdit;
@property (assign,nonatomic) BOOL isManaging;

@property (retain,nonatomic)NSMutableArray *addressArr;

@property (copy,nonatomic)void (^completeAddress)(NSDictionary *addressDic);



@end
