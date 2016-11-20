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
+ (NSDictionary *)getAccountInformation:(NSString *)account withApiKey:(NSString *)key;
+ (NSString *)checkApiKey:(NSString *)apiKey andError:(NSError **) error;
+ (NSArray *)getUserAccounts:(NSString *)apiKey;
+ (NSArray *)getUserTags:(NSString *)apiKey;
+ (void)addNewTag:(NSString *)newTag withAPIKey:(NSString *)key andError:(NSError **) error;;
+ (NSArray *)getAccountTransactions:(NSString *)account fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withApiKey:(NSString *)key;
+ (NSString *)addTransactionToAccount:(NSString *)account withDescription:(NSString *)description withAmount:(NSInteger)amountInCents withCategory:(NSString *)category withSubCategory:(NSString *)subCategory withDate:(NSDate *)date withTags:(NSArray *)tags andAPIKey:(NSString *)key andError:(NSError **)error;
+ (void)deleteTransaction:(NSString *)transactionId inAccount:(NSString *)accountId withTimestamp:(NSNumber *)timestamp andAPIKey:(NSString *)apikey andError:(NSError **)error;
+ (NSArray *)getUserCategories:(NSString *)apiKey;
+ (void)addNewCategory:(NSString *)newCategory andAPIKey:(NSString *)key andError:(NSError **)error;
+ (void)addNewSubCategory:(NSString *)newSubCategory forCategory:(NSString *)category andAPIKey:(NSString *)key andError:(NSError **)error;
+ (void)deleteCategory:(NSString *)category andAPIKey:(NSString *)key andError:(NSError **)error;
+ (void)deleteSubCategory:(NSString *)subCategory inCategory:(NSString*) category andAPIKey:(NSString *)key andError:(NSError **)error;


@end
