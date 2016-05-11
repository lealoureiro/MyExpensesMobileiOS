//
//  CategoryCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 09/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "SelectionCell.h"

@implementation SelectionCell

@synthesize option;
@synthesize value;

- (id)initWithIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    option = [[UILabel alloc] init];
    option.font = [UIFont boldSystemFontOfSize:18.0f];
    [option setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:option];
    
    value = [[UILabel alloc] init];
    [value setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:value];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(option, value);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[option]-10-[value]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[option]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[value]-8-|" options:0 metrics:nil views:views]];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
