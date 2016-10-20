//
//  RetrieveLastMonthViewCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 21/10/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "RetrieveLastMonthViewCell.h"

@implementation RetrieveLastMonthViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel *description = [[UILabel alloc] init];
    description.font = [UIFont boldSystemFontOfSize:18.0f];
    description.text = @"Retrieve last month";
    [description setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:description];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:description attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:description attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    return self;
}

@end
