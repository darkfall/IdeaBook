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
#import "IdeaNearbyDetailViewController.h"

#define kMaxIdeaTitleLength 30

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
    
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [self.refreshControl beginRefreshing];
    [self refreshNearbyIdeas:nil];
}

- (void)refreshNearbyIdeas: (id) sender {
    CLLocation* lastLoc = [[GeoLocationManager sharedInstance] lastLocation];
    if(lastLoc) {
        [ServerAPI getIdeasNearby:lastLoc.coordinate.longitude longitude:lastLoc.coordinate.longitude success:^(NSArray* ideas) {
            
            [self.refreshControl endRefreshing];
        
           // bool showAlert = _nearbyIdeas == nil || _nearbyIdeas.count == 0;
            bool showAlert = false;
            _nearbyIdeas = [NSMutableArray arrayWithArray:ideas];
            [_ideasTableView reloadData];
            
            if(showAlert)
                [AlertHelper showNZAlert:@"Info"
                                 message:[NSString stringWithFormat:@"Found %i ideas nearby you",   [_nearbyIdeas count]]
                                   style:NZAlertStyleSuccess];
        
        } fail:^{
            
            [self.refreshControl endRefreshing];
            
            [AlertHelper showNZAlert:@"Error"
                             message:@"Failed getting nearby ideas"
                               style:NZAlertStyleError];

        }];
    } else {
        
        [self.refreshControl endRefreshing];
        
        [AlertHelper showNZAlert:@"Error"
                         message:@"Failed getting current location. Please enable location services."
                           style:NZAlertStyleError];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_nearbyIdeas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdeaNearbyTableViewCell *cell = (IdeaNearbyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ideaNearbyCell" forIndexPath:indexPath];
    
    Idea* idea = [_nearbyIdeas objectAtIndex:indexPath.row];
    cell.idea = idea;
    
    if(idea.content.length < kMaxIdeaTitleLength) {
        cell.ideaTitle.text = idea.content;
    } else {
        cell.ideaTitle.text = [[idea.content substringWithRange:NSMakeRange(0, kMaxIdeaTitleLength - 3)] stringByAppendingString:@"..."];
    }
    cell.userNameLabel.text = [@"By " stringByAppendingString:idea.username];
    
    cell.numLikesLabel.text = [NSString stringWithFormat:@"%i", [idea.likes intValue]];
    cell.numDislikesLabel.text = [NSString stringWithFormat:@"%i", [idea.dislikes intValue]];
    
    cell.distanceLabel.text = [[GeoLocationManager sharedInstance] stringDistanceFromCurrentLocation:[idea.latitude doubleValue]
                                                                                           longitude:[idea.longitude doubleValue]];
    
    if([idea.liked intValue] > 0) {
        cell.likeImage.image = [UIImage imageNamed:@"smile_light"];
    } else {
        cell.likeImage.image = [UIImage imageNamed:@"smile"];
    }
    
    if([idea.disliked intValue] > 0) {
        cell.dislikeImage.image = [UIImage imageNamed:@"smile_sad_light"];
    } else {
        cell.dislikeImage.image = [UIImage imageNamed:@"smile_sad"];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showIdeaDetail"]) {
        IdeaNearbyDetailViewController* detailController = (IdeaNearbyDetailViewController*)segue.destinationViewController;
        
        NSIndexPath* selectedRowIndex = [self.tableView indexPathForSelectedRow];
        detailController.idea = [_nearbyIdeas objectAtIndex:selectedRowIndex.row];
    }
}


- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
