//
//  ExpensesCoreServerAPI.h
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 09/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ExpensesCoreServerAPI : NSObject

+ (NSString *)loginWithUsername:(NSString *)username withPassword:(NSString *) password andError:(NSError **)error;
+ (NSArray *)getUserAccounts:(NSString *)authToken;



@end