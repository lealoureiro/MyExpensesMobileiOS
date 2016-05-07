//
//  TransactionAmountTableViewCell.m
//  MyExpense
//
//  Created by Leandro Loureiro on 07/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "TransactionAmountTableViewCell.h"

@implementation TransactionAmountTableViewCell

@synthesize amountBox;

UILabel *amountLabel;
NSNumberFormatter *formatter;
NSNumber *currentAmount;

- (id)initWithIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    currentAmount = [NSNumber numberWithDouble:0.0];
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    amountLabel = [[UILabel alloc] init];
    amountLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    amountLabel.text = @"Amount:";
    [amountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:amountLabel];
    
    self.amountBox = [[UITextField alloc] init];
    self.amountBox.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountBox.returnKeyType = UIReturnKeyDone;
    self.amountBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.amountBox.textAlignment = NSTextAlignmentRight;
    self.amountBox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.amountBox.font = [UIFont boldSystemFontOfSize:22.0f];
    self.amountBox.text = [formatter stringFromNumber:[NSNumber numberWithDouble:0.0]];
    self.amountBox.textColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1];
    self.amountBox.delegate = self;
    [self.amountBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.amountBox];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(amountLabel, amountBox);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[amountLabel]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[amountBox]-15-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[amountLabel]-10-[amountBox]-10-|" options:0 metrics:nil views:views]];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAmount)];
    [self.contentView addGestureRecognizer:singleFingerTap];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == amountBox) {
        amountLabel.textColor = self.contentView.tintColor;
        amountBox.textColor = [UIColor blackColor];
        amountBox.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == amountBox) {
        amountLabel.textColor = [UIColor blackColor];
        if ([amountBox.text isEqualToString:@""]) {
            amountBox.textColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1];
            amountBox.text = [formatter stringFromNumber:[NSNumber numberWithDouble:0.0]];
        } else {
            NSScanner *scanner = [NSScanner localizedScannerWithString:amountBox.text];
            double result;
            [scanner scanDouble:&result];
            amountBox.text = [formatter stringFromNumber:[NSNumber numberWithDouble:result]];
        }
    }
}

- (void)focusAmount {
    NSLog(@"Amount box selected");
    [self.amountBox becomeFirstResponder];
}

@end
