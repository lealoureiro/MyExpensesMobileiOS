//
//  RetrieveLastMonthViewCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 21/10/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "RetrieveLastMonthViewCell.h"

@implementation RetrieveLastMonthViewCell

@synthesize retrieveButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.retrieveButton = [[UIButton alloc] init];
    self.retrieveButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [self.retrieveButton setTitle:@"Retrieve last month" forState:UIControlStateNormal];
    [self.retrieveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.retrieveButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.retrieveButton];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.retrieveButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.retrieveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    return self;
}

@end
