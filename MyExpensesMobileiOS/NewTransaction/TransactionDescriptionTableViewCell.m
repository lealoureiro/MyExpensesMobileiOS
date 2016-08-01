//
//  TransactionDescriptionTableViewCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 05/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "TransactionDescriptionTableViewCell.h"

@implementation TransactionDescriptionTableViewCell

@synthesize descriptionBox;

UILabel *descriptionLabel;

- (id)initWithIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    descriptionLabel.text = @"Description:";
    [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:descriptionLabel];
    
    self.descriptionBox = [[UITextField alloc] init];
    self.descriptionBox.keyboardType = UIKeyboardTypeDefault;
    self.descriptionBox.returnKeyType = UIReturnKeyDone;
    self.descriptionBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.descriptionBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.descriptionBox.font = [UIFont boldSystemFontOfSize:16.0f];
    self.descriptionBox.delegate = self;
    self.descriptionBox.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.descriptionBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.descriptionBox];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(descriptionLabel, descriptionBox);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[descriptionLabel]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[descriptionBox]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[descriptionLabel]-10-[descriptionBox]-10-|" options:0 metrics:nil views:views]];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusDescription)];
    [self.contentView addGestureRecognizer:singleFingerTap];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == descriptionBox) {
        descriptionLabel.textColor = self.contentView.tintColor;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == descriptionBox) {
        descriptionLabel.textColor = [UIColor blackColor];
    }
}

- (void)focusDescription {
    NSLog(@"Description box selected");
    [self.descriptionBox becomeFirstResponder];
}

@end
