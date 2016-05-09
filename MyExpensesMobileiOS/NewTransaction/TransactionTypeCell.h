//
//  TransactionTypeCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 09/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionTypeCell : UITableViewCell

@property (strong, nonatomic) UISegmentedControl *transactionType;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
