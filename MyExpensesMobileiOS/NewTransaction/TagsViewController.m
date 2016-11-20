//
//  TagsViewController.m
//  MyExpense
//
//  Created by Leandro Loureiro on 20/11/16.
//  Copyright © 2016 Leandro Loureiro. All rights reserved.
//

#import "TagsViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@interface TagsViewController ()

@end

@implementation TagsViewController

@synthesize list;
@synthesize selectedTags;
@synthesize delegate;
@synthesize update;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addNewItem)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.tableView.allowsMultipleSelection = YES;
    
    if (self.selectedTags == nil) {
        self.selectedTags = [[NSMutableSet alloc] init];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"optionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *option = [list objectAtIndex:indexPath.row];
    NSString *tag = [option objectForKey:@"name"];
    cell.textLabel.text = tag;
    if ([self.selectedTags containsObject:tag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionNone];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *option = [list objectAtIndex:indexPath.row];
    NSLog(@"Selected tag: %@", [option objectForKey:@"name"]);
    [self.selectedTags addObject:[option objectForKey:@"name"]];
    [self.delegate setSelectedTags:self];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *option = [list objectAtIndex:indexPath.row];
    [self.selectedTags removeObject:[option objectForKey:@"name"]];
    [self.delegate setSelectedTags:self];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void)addNewItem {
    
    NSString *description1 = @"Add new tag";
    NSString *description2 = @"Please enter the new tag name:";
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:description1
                                message:description2
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *addButton = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          NSArray *textfields = alert.textFields;
                                                          UITextField *name = textfields[0];
                                                          [self addNewTag:name.text];
                                                      }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:addButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addNewTag:(NSString *)newTag {

    for (NSDictionary *option in self.list) {
        if ([[option objectForKey:@"name"] isEqual:newTag]) {
            NSLog(@"Tag %@ already added!", newTag);
            return;
        }
    }
    
    NSError *error = nil;
    [ExpensesCoreServerAPI addNewTag:newTag withAPIKey:[ApplicationState getInstance].apiKey andError:&error];
    if (error == nil) {
        NSLog(@"Tag %@ added successfully.", newTag);
        [self.list addObject:@{@"name": newTag}];
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
        [self.list sortUsingDescriptors:sortDescriptors];
        [self.tableView reloadData];
        *update = YES;
    }
}

@end
