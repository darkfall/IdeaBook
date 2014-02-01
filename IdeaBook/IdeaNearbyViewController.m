//
//  SecondViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaNearbyViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

#import "Utils/ServerAPI.h"
#import "Utils/GeoLocationManager.h"
#import "Utils/AlertHelper.h"

#import "Models/Idea.h"

#import "NZAlertView/NZAlertView.h"

#import "IdeaNearbyTableViewCell.h"

#define kMaxIdeaTitleLength 20

@interface IdeaNearbyViewController ()

@property (nonatomic, strong) NSMutableArray* nearbyIdeas;
@property (strong, nonatomic) IBOutlet UITableView *ideasTableView;

@end

@implementation IdeaNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    UIRefreshControl* refresh = [UIRefreshControl new];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refresh addTarget:self
                action:@selector(refreshNearbyIdeas:)
      forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self refreshNearbyIdeas:nil];
}

- (void)refreshNearbyIdeas: (id) sender {
    CLLocation* lastLoc = [[GeoLocationManager sharedInstance] lastLocation];
    if(lastLoc) {
        [ServerAPI getIdeasNearby:lastLoc.coordinate.longitude longitude:lastLoc.coordinate.longitude success:^(NSArray* ideas) {
            
            [self.refreshControl endRefreshing];
            
            _nearbyIdeas = [NSMutableArray arrayWithArray:ideas];
            [_ideasTableView reloadData];
            
            [AlertHelper showNZAlert:@"Info"
                             message:[NSString stringWithFormat:@"Found %i nearby ideas", [_nearbyIdeas count]]
                               style:NZAlertStyleSuccess];
        
        } fail:^{
            
            [self.refreshControl endRefreshing];
            
            [AlertHelper showNZAlert:@"Error"
                             message:@"Failed getting nearby ideas"
                               style:NZAlertStyleError];

        }];
    } else {
        [AlertHelper showNZAlert:@"Error"
                         message:@"Failed getting current location"
                           style:NZAlertStyleError];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nearbyIdeas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdeaNearbyTableViewCell *cell = (IdeaNearbyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ideaNearbyCell" forIndexPath:indexPath];
    
    Idea* idea =  [_nearbyIdeas objectAtIndex:indexPath.row];
    if(idea.content.length < kMaxIdeaTitleLength) {
        cell.ideaTitle.text = idea.content;
    } else {
        cell.ideaTitle.text = [[idea.content substringWithRange:NSMakeRange(0, kMaxIdeaTitleLength - 3)] stringByAppendingString:@"..."];
    }
    
    return cell;
}


- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
