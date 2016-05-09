//
//  CategoryCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 09/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell

@property (strong, nonatomic) UILabel *option;
@property (strong, nonatomic) UILabel *value;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
