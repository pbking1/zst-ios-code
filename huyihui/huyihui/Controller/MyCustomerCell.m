//
//  MyCustomerCell.m
//  huyihui
//
//  Created by zhangmeifu on 20/2/14.
//  Copyright (c) 2014 linyi. All rights reserved.
//

#import "MyCustomerCell.h"

@implementation MyCustomerCell

//@synthesize productImageView=_productImageView;
//@synthesize productNameTextView=_productNameTextView;
//@synthesize promotionalPriceLabel=_promotionalPriceLabel;
//@synthesize marketPriceLabel=_marketPriceLabel;
//@synthesize goodCommentLabel=_goodCommentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_productImageView release];
    [_productNameTextView release];
    [_promotionalPriceLabel release];
    [_marketPriceLabel release];
    [_goodCommentLabel release];
    [super dealloc];
}
@end
