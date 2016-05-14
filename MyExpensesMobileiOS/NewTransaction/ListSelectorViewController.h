//
//  ListSelectorViewController.h
//  MyExpense
//
//  Created by Leandro Loureiro on 10/05/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListSelectorViewController;

@protocol ListSelectorDelegate <NSObject>
- (void)setSelectedItem:(ListSelectorViewController *)selector didSelectKey:(NSString *)key;
@end

@interface ListSelectorViewController : UITableViewController

@property NSArray *list;
@property NSString *selectedKey;
@property NSString *type;
@property (nonatomic, weak) id <ListSelectorDelegate> delegate;

@end


