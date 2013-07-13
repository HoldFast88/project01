//
//  AddRecordViewController.h
//  myMoney
//
//  Created by Администратор on 7/10/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRecordViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *addRecordView;
@property (nonatomic, weak) IBOutlet UIView *accountHistoryView;

@property (nonatomic, weak) IBOutlet UITableView *historyTableView;

-(void)showAccount:(Account*)account;
-(void)showAddRecord;

@end
