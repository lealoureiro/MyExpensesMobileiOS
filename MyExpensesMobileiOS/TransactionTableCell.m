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
@synthesize amount;
@synthesize category;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.description = [[UILabel alloc] init];
    [self.description setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.description];
    
    self.amount = [[UILabel alloc] init];
    [self.amount setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.amount];
    
    self.category = [[UILabel alloc] init];
    [self.category setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.category];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(description, amount, category);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[description]-15-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[description]-5-[category]-5-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[description]-5-[amount]-5-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[category]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[amount]-15-|" options:0 metrics:nil views:views]];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
