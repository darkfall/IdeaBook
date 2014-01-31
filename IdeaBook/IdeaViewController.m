//
//  FirstViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

@interface IdeaViewController ()

@property (nonatomic, strong) NSArray* tableItems;

@end

@implementation IdeaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _tableItems = @[@"test1", @"test2"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaCell" forIndexPath:indexPath];
    cell.textLabel.text = [_tableItems objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
