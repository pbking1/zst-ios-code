//
//  ChooseReceiptType.h
//  huyihui
//
//  Created by zaczh on 14-4-8.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseReceiptType : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSString *receiptStr;

- (id)initWithSelectedIndex:(NSInteger)index completion:(void (^)(NSDictionary *res))completionBlock;
@end
