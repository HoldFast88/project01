//
//  Record.m
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "Record.h"

@implementation Record

@synthesize amount = _amount;
@synthesize description = _description;
@synthesize tags = _tags;
@synthesize date;
@synthesize ID;

-(id)initWithAmount:(double)amount description:(NSString *)description andTags:(NSArray *)tags
{
    self = [super init];
    if (self){
        _amount = amount;
        _description = [[NSString alloc] initWithString:description];
        _tags = [[NSArray alloc] initWithArray:tags];
        date = [NSDate date];
    }
    
    return self;
}

-(BOOL)isProfit
{
    return _amount > 0.0;
}

@end
