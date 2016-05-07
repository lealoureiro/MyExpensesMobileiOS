//
//  TransactionAmountTableViewCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 07/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionAmountTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *amountBox;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
