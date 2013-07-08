//
//  NSArray+convert.m
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "NSArray+convert.h"

@implementation NSArray(convert)

-(NSString*)commaSeparatedValuesString
{
    NSString *returnString = [NSString string];
    
    for (NSString *value in self){
        returnString = [returnString stringByAppendingFormat:@"%@,", value];
    }
    
    returnString = [returnString substringToIndex:returnString.length - 2]; // remove last comma
    
    return returnString;
}

+(NSArray*)arrayFromStringCommaSeparatedValues:(NSString*)string
{
    return [string componentsSeparatedByString:@","];
}

@end
