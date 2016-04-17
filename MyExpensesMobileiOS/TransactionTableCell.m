//
//  TransactionTableCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 17/04/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "TransactionTableCell.h"

@implementation TransactionTableCell

@synthesize description;
@synthesize category;
@synthesize amount;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
