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

#import "ColorScheme.h"

@interface SidebarViewController ()


@property (nonatomic, strong) NSArray* menuItems;

@property (nonatomic, strong) NSMutableDictionary* cellDict;
@property (weak, nonatomic) UITableViewCell* prevSelectedCell;

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = 
    self.tableView.backgroundColor = kCellBackgroundColor;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5f alpha:0.2f];
    
    _prevSelectedCell = nil;
    _menuItems = @[@"title", @"ideas", @"nearby_ideas", @"idea_fountain", @"settings"];
    _cellDict = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [_cellDict setObject:cell forKey:cellIdentifier];
    
    cell.backgroundColor = kCellBackgroundColor;
    
    // adjusting selection color
    UIView* selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = kCellHighlightColor;
    cell.selectedBackgroundView = selectionColor;
    if([cellIdentifier isEqual:@"ideas"]) {
        selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = kCellHighlightColor;
        cell.backgroundView = selectionColor;
        
        _prevSelectedCell = cell;
    }
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell* currentCell = nil;
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"nearby_ideas"]) {
    
        
    } else if([segue.identifier isEqualToString:@"idea_fountain"]) {
    
        
    } else if([segue.identifier isEqualToString:@"settings"]) {
        
               
    } else if([segue.identifier isEqualToString:@"ideas"]) {
        
    }
    
    currentCell = [_cellDict valueForKey:segue.identifier];
    if(currentCell != nil) {
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = kCellHighlightColor;
        currentCell.backgroundView = selectionColor;
    }
    if(_prevSelectedCell != nil) {
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = kCellBackgroundColor;
        _prevSelectedCell.backgroundView = selectionColor;
    }
    _prevSelectedCell = currentCell;
    
    if ([segue isKindOfClass: [SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end
