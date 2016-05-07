//
//  TransactionDescriptionTableViewCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 05/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionDescriptionTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *descriptionBox;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
