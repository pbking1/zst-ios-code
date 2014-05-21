//
//  CommentViewController.h
//  huyihui
//
//  Created by zaczh on 14-4-16.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *table;
- (id)initWithOrder:(NSDictionary *)order;
@end
