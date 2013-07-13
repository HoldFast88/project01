//
//  AddRecordViewController.m
//  myMoney
//
//  Created by Администратор on 7/10/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "AddRecordViewController.h"

@interface AddRecordViewController ()
{
    Account *showingAccount;
}

@end


@implementation AddRecordViewController

@synthesize addRecordView;
@synthesize accountHistoryView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *imageList = [UIImage imageNamed:@"reveal_menu_icon_portrait.png"];
    UIImage *imageSettings = [UIImage imageNamed:@"settings.png"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageList
																   landscapeImagePhone:nil
																				 style:UIBarButtonItemStylePlain
																				target:self
																				action:@selector(showLeftView:)];
    }
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeRight)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageSettings
																	landscapeImagePhone:nil
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(showRightView:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

- (void)showRightView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.rightViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.rightViewController];
    }
}

-(void)showAccount:(Account *)account
{
    accountHistoryView.hidden = NO;
    addRecordView.hidden = YES;
    
    [self showLeftView:nil];
}

-(void)showAddRecord
{
    accountHistoryView.hidden = YES;
    addRecordView.hidden = NO;
    
    [self showLeftView:nil];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"reuseIDRecordsList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    
    Record *record = showingAccount.recordsHistory[indexPath.row];
    
    cell.textLabel.text = [@(record.amount) stringValue];
    cell.detailTextLabel.text = record.description;
    
    if (record.isProfit){
        cell.contentView.backgroundColor = [UIColor greenColor];
    }else{
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [showingAccount.recordsHistory count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
