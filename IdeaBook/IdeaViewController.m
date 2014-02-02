//
//  FirstViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

#import "IdeaDetailViewController.h"
#import "NewIdeaViewController.h"
#import "IdeaTableViewCell.h"
#import "Models/Idea.h"

#import "ColorScheme.h"

#define kMaxIdeaTitleLength 30

@interface IdeaViewController ()

@property (strong, nonatomic) IBOutlet UITableView *ideaTableView;

@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [IdeaManager sharedInstance].delegate = self;
    
    self.navigationController.navigationBar.barTintColor = kCellHighlightColor;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[IdeaManager sharedInstance] ideas] count];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdeaTableViewCell *cell = (IdeaTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ideaCell" forIndexPath:indexPath];
    NSMutableArray* ideas = [[IdeaManager sharedInstance] ideas];
    
    Idea* idea = [ideas objectAtIndex:indexPath.row];
    if([idea.shared boolValue]) {
        cell.ideaShareButton.imageView.image = [UIImage imageNamed:@"brightness_light"];
    } else {
        cell.ideaShareButton.imageView.image = [UIImage imageNamed:@"brightness"];
    }
    cell.idea = idea;
    cell.parentTableView = self.tableView;
    
    if(idea.content.length < kMaxIdeaTitleLength) {
        cell.ideaTitle.text = idea.content;
    } else {
        cell.ideaTitle.text = [[idea.content substringWithRange:NSMakeRange(0, kMaxIdeaTitleLength - 3)] stringByAppendingString:@"..."];
    }
    cell.ideaCreationTime.text = idea.time;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showIdeaDetail"]) {
        IdeaDetailViewController* ideaController = segue.destinationViewController;
        
        NSIndexPath* selectedRowIndex = [self.tableView indexPathForSelectedRow];
        NSMutableArray* ideas = [[IdeaManager sharedInstance] ideas];
        Idea* idea = [ideas objectAtIndex:selectedRowIndex.row];
        
        ideaController.idea = idea;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [[IdeaManager sharedInstance] removeAtIndex:indexPath.row withNotification:NO];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

- (void)ideaRemoved:(Idea *)idea index:(NSUInteger)index {
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)ideaAdded:(Idea *)idea index:(NSUInteger)index {
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)ideaChanged:(Idea *)idea index:(NSUInteger)index {
    
}

- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
