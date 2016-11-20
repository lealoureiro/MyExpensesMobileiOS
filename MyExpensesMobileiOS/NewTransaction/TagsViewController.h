//
//  TagsViewController.h
//  MyExpense
//
//  Created by Leandro Loureiro on 20/11/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagsViewController;

@protocol TagsSelectorDelegate <NSObject>
- (void)setSelectedTags:(TagsViewController *)selector;
@end

@interface TagsViewController : UITableViewController

@property NSMutableArray *list;
@property NSMutableSet *selectedTags;
@property (nonatomic, weak) id <TagsSelectorDelegate> delegate;
@property BOOL *update;

@end
