//
//  AddOrChangerAddress.h
//  huyihui
//
//  Created by zhangmeifu on 20/3/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOrChangerAddress : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (retain,nonatomic)UITableView *changeAddressTable;

@property (retain,atomic)NSMutableDictionary *addressDic;

@property (retain,atomic)NSArray *firstArr;
@property (retain,atomic)NSArray *secondArr;
@property (retain,atomic)NSArray *thirdArr;


@property (retain,nonatomic)NSMutableArray *regionsListArr;
@property (retain,nonatomic)NSMutableArray  *plistArr;

@property (retain,nonatomic)NSMutableDictionary *DeliveryInfoDic;
@property (retain,nonatomic)NSMutableDictionary *originDeliveryDic;



@property (assign,nonatomic)BOOL isNewAddress;

@property (retain,nonatomic) UIPickerView *addressPickerView;

@property (copy,nonatomic)void (^saveAddressSuccess)(int success);



@end
