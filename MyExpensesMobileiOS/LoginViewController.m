//
//  LoginViewController.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 13/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "LoginViewController.h"
#import "ExpensesCoreServerAPI.h"
#import "ApplicationState.h"

@implementation LoginViewController

UITextField *usernameBox;
UITextField *passwordBox;
UILabel *errorLabel;
UIButton *loginButton;

- (void)loadView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    UILabel *usernameLabel = [[UILabel alloc] init];
    usernameLabel.text = @"Username";
    usernameLabel.textColor = [UIColor blackColor];
    usernameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:usernameLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"Password";
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [passwordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:passwordLabel];
    
    usernameBox = [[UITextField alloc] init];
    usernameBox.borderStyle = UITextBorderStyleRoundedRect;
    usernameBox.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameBox.keyboardType = UIKeyboardTypeDefault;
    usernameBox.returnKeyType = UIReturnKeyDone;
    usernameBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [usernameBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:usernameBox];
    
    passwordBox = [[UITextField alloc] init];
    passwordBox.secureTextEntry = YES;
    passwordBox.borderStyle = UITextBorderStyleRoundedRect;
    passwordBox.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordBox.keyboardType = UIKeyboardTypeDefault;
    passwordBox.returnKeyType = UIReturnKeyDone;
    passwordBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:passwordBox];
    
    errorLabel = [[UILabel alloc] init];
    errorLabel.textColor = [UIColor redColor];
    [errorLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.view addSubview:errorLabel];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:loginButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameBox attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-100.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-100.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:usernameBox attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:52.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordBox attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:usernameBox attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:passwordBox attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:errorLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(usernameBox, passwordBox, loginButton, errorLabel, usernameLabel, passwordLabel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usernameBox]-15-[passwordBox]-15-[loginButton]-15-[errorLabel]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usernameLabel]-15-[usernameBox(>=200)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[passwordLabel]-15-[passwordBox(>=200)]" options:0 metrics:nil views:views]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    errorLabel.text = @"";
}


- (void)login
{
    NSError *error;
    [errorLabel setText:@""];
    NSLog(@"Login %@ %@", usernameBox.text, passwordBox.text);
    NSString *key = [ExpensesCoreServerAPI loginWithUsername:usernameBox.text andPassword:passwordBox.text andError:&error];
    
    if (error != nil) {
        [errorLabel  setNumberOfLines:0];
        if (error.code == 0 || error.code == 400) {
           [errorLabel setText:@"Invalid credentials!"];
        } else {
            [errorLabel setText:@"Login error!"];
        }
    
    } else {
        ApplicationState *application = [ApplicationState getInstance];
        application.logged = YES;
        application.apiKey = key;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:key forKey:@"apiKey"];
        [defaults synchronize];
        NSLog(@"Saved token %@ in user defaults", key);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
