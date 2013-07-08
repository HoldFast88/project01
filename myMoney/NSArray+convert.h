//
//  NSArray+convert.h
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(convert)

-(NSString*)commaSeparatedValuesString;

+(NSArray*)arrayFromStringCommaSeparatedValues:(NSString*)string;

@end
