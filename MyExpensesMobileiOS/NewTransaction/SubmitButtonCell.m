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
@synthesize resultLabel;

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
    
    resultLabel = [[UILabel alloc] init];
    resultLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    [resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:resultLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:submitButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(submitButton, resultLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[resultLabel]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[submitButton]-5-[resultLabel]" options:0 metrics:nil views:views]];
    
    return self;
}

@end
