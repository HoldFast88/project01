//
//  Account.m
//  myMoney
//
//  Created by Администратор on 6/29/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "Account.h"

@implementation Account


@synthesize name = _name;
@synthesize amount = _amount;
@synthesize recordsHistory;

-(id)initWithName:(NSString *)name andAmount:(CGFloat)amount
{
    self = [super init];
    if (self){
        _name = [[NSString alloc] initWithString:name];
		_amount = amount;
        recordsHistory = [@[] mutableCopy];
    }
    return self;
}

-(NSString*)serviceName
{
    // !!! cannot start with number
    return [NSString stringWithFormat:@"Account%@", [_name stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

-(BOOL)createRecord:(Record*)record
{
    [recordsHistory addObject:record];
    return [[DatabaseController instance] createRecord:record forAccount:self];
}

-(void)removeRecord:(Record*)record
{
    [recordsHistory removeObject:record];
    [[DatabaseController instance] removeRecord:record forAccount:self];
}

-(NSArray*)allRecords
{
    return [NSArray arrayWithArray:recordsHistory];
}

-(NSArray*)recordsWithTags:(NSArray*)tags
{
    return [[DatabaseController instance] recordsWithTags:tags forAccount:self];
}

#pragma mark - NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        self.amount = [aDecoder decodeFloatForKey:@"amount"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        recordsHistory = [[[DatabaseController instance] allRecordsForAccount:self] mutableCopy];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.amount forKey:@"amount"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
