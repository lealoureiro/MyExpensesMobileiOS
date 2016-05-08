//
//  TransactionCategoryTableViewCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 08/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "TransactionCategoryTableViewCell.h"

@implementation TransactionCategoryTableViewCell

@synthesize categoryPicker;

- (id)initWithIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    categoryLabel.text = @"Category:";
    [categoryLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:categoryLabel];
    
    categoryPicker = [[UIPickerView alloc] init];
    categoryPicker.delegate = self;
    categoryPicker.dataSource = self;
    [categoryPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:categoryPicker];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(categoryPicker, categoryLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[categoryPicker]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[categoryLabel]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[categoryLabel]-2-[categoryPicker]-5-|" options:0 metrics:nil views:views]];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Test";
}


@end
