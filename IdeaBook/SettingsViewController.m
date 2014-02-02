//
//  SettingsViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

@interface SettingsViewController ()


@property (nonatomic, strong) NSArray* settingsIdentifiers;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingsIdentifiers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [self.settingsIdentifiers objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    
    // adjusting selection color
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(226/255.0) green:(148/255.0) blue:(59/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}

- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
