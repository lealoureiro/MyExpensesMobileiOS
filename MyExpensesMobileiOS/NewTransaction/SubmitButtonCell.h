//
//  SubmitButtonCell.h
//  MyExpense
//
//  Created by Leandro Loureiro on 14/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitButtonCell : UITableViewCell

@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UILabel *resultLabel;


- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
