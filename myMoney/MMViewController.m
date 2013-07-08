//
//  MMViewController.m
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "MMViewController.h"

@interface MMViewController ()

@end

@implementation MMViewController

@synthesize amountField;
@synthesize descriptionField;
@synthesize tagsField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createRecord:(id)sender
{
//    double amount = [[amountField text] doubleValue];
//    NSString *description = [descriptionField text];
//    NSString *tagsString = [tagsField text];
//    
//    NSArray *tags = [tagsString componentsSeparatedByString:@","];
//    
//    Record *record = [[Record alloc] initWithAmount:amount description:description andTags:tags];
//    if ([[DatabaseController instance] createRecord:record]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"OK" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    }
}

-(void)fetchRecords:(id)sender
{
//    [[DatabaseController instance] allRecords];
}

@end
