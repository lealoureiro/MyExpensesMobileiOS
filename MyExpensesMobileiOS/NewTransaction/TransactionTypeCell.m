//
//  TransactionTypeCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 09/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "TransactionTypeCell.h"

@implementation TransactionTypeCell

@synthesize transactionType;

- (id)initWithIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *types = [NSArray arrayWithObjects:@"Expense", @"Income", nil];
    transactionType = [[UISegmentedControl alloc] initWithItems:types];
    transactionType.selectedSegmentIndex = 0;
    [transactionType setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:transactionType];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(transactionType);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[transactionType]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[transactionType]-8-|" options:0 metrics:nil views:views]];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
