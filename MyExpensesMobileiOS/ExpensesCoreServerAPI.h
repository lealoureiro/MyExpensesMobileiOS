//
//  ExpensesCoreServerAPI.h
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ExpensesCoreServerAPI : NSObject

+ (NSString *)loginWithUsername:(NSString *)username andPassword:(NSString *) password andError:(NSError **)error;
+ (NSString *)checkApiKey:(NSString *)apiKey andError:(NSError **) error;
+ (NSArray *)getUserAccounts:(NSString *)apiKey;
+ (NSArray *)getAccountTransactions:(NSString *)account withApiKey:(NSString *)key;

@end