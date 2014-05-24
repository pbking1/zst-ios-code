//
//  ButtonMacro.h
//  huyihui
//
//  Created by linyi on 14-3-3.
//  Copyright (c) 2014年 linyi. All rights reserved.
//

#ifndef huyihui_ButtonMacro_h
#define huyihui_ButtonMacro_h

typedef NS_OPTIONS(NSUInteger, HuEasyButtonType){
    HuEasyButtonTypeBack = 1,
    HuEasyButtonTypeSearch = 2,
    HuEasyButtonTypeShare = 3,
    HuEasyButtonTypeConfirm = 4,
    HuEasyButtonTypeActive = 5,
    HuEasyButtonTypeDone = 6,
    HuEasyButtonTypeFilter = 7,
    HuEasyButtonTypeMore =  8,
    HuEasyButtonTypeCancel =  9,
    HuEasyButtonTypeDelete = 10,
    HuEasyButtonTypeRefresh = 11,
};
#define BACKBUTTON  1
#define SEARCHBUTTON 2
#define SHAREBUTTON 3
#define CONFIRMBUTTON 4
#define ACTIVEBUTTON 5
#define DONEBUTTON 6
#define FILTERBUTTON 7
#define MOREBTN  8
#define SENDBUTTON 9
#define BACKTOMAINPAGE 13

#endif
