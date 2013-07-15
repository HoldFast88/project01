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

-(id)initWithName:(NSString *)name andAmount:(CGFloat)amount
{
    self = [super init];
    if (self){
        _name = [[NSString alloc] initWithString:name];
		_amount = amount;
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
    return [[DatabaseController instance] createRecord:record forAccount:self];
}

-(void)removeRecord:(Record*)record
{
    [[DatabaseController instance] removeRecord:record forAccount:self];
}

-(NSArray*)allRecords
{
//    return [NSArray arrayWithArray:recordsHistory];
	return [[DatabaseController instance] allRecordsForAccount:self];
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
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.amount forKey:@"amount"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
