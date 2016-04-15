//
//  ApplicationState.m
//  MyExpensesMobileiOS
//
//  Created by Leandro Loureiro on 15/01/15.
//  Copyright (c) 2015 Leandro Loureiro. All rights reserved.
//

#import "ApplicationState.h"

@implementation ApplicationState


@synthesize logged;
@synthesize apiKey;

static ApplicationState *instance = nil;


+(ApplicationState *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance = [ApplicationState new];
        }
    }
    return instance;
}

@end
