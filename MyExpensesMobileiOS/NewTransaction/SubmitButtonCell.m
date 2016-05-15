//
//  SubmitButtonCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 14/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "SubmitButtonCell.h"

@implementation SubmitButtonCell

@synthesize submitButton;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    submitButton = [[UIButton alloc] init];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [submitButton setTitle:@"Add Transaction" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:submitButton];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    return self;
}

@end
