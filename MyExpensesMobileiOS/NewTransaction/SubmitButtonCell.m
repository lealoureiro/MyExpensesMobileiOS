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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(submitButton);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[submitButton]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[submitButton]-8-|" options:0 metrics:nil views:views]];
    
    return self;
}

@end
