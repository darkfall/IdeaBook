//
//  SidebarViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/31/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "SidebarViewController.h"

#import "SWRevealViewController.h"
#import "IdeaNearbyViewController.h"
#import "UsersNearbyViewController.h"
#import "SettingsViewController.h"
#import "IdeaViewController.h"

@interface SidebarViewController ()


@property (nonatomic, strong) NSArray* menuItems;


@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = 
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5f alpha:0.2f];
    
    _menuItems = @[@"title", @"ideas", @"nearby_ideas", @"nearby_users", @"settings"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    
    // adjusting selection color
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(226/255.0) green:(148/255.0) blue:(59/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showIdeasNearby"]) {
        IdeaNearbyViewController* controller = (IdeaNearbyViewController*)segue.destinationViewController;
    } else if([segue.identifier isEqualToString:@"showUsersNearby"]) {
        UsersNearbyViewController* controller = (UsersNearbyViewController*)segue.destinationViewController;
    } else if([segue.identifier isEqualToString:@"showSettings"]) {
        SettingsViewController* controller = (SettingsViewController*)segue.destinationViewController;
    } else if([segue.identifier isEqualToString:@"showMyIdeas"]) {
        IdeaViewController* controller = (IdeaViewController*)segue.destinationViewController;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end
