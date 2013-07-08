//
//  MMViewController.h
//  myMoney
//
//  Created by Администратор on 6/12/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMViewController : UIViewController

@property (nonatomic, assign) IBOutlet UITextField *amountField;
@property (nonatomic, assign) IBOutlet UITextField *descriptionField;
@property (nonatomic, assign) IBOutlet UITextField *tagsField;

-(IBAction)createRecord:(id)sender;
-(IBAction)fetchRecords:(id)sender;

@end
