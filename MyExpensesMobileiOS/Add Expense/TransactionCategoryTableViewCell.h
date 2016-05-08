//
//  TransactionCategoryTableViewCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 08/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionCategoryTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *categoryPicker;


- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
