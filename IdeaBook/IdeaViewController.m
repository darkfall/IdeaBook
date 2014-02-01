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

#define kMaxIdeaTitleLength 20

@interface IdeaViewController ()

@property (strong, nonatomic) IBOutlet UITableView *ideaTableView;

@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [IdeaManager sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[IdeaManager sharedInstance] ideas] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IdeaTableViewCell *cell = (IdeaTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ideaCell" forIndexPath:indexPath];
    NSMutableArray* ideas = [[IdeaManager sharedInstance] ideas];
    
    Idea* idea = [ideas objectAtIndex:indexPath.row];
    if([idea.shared boolValue]) {
        cell.ideaSharedIcon.image = [UIImage imageNamed:@"brightness.png"];
    } else {
        cell.ideaSharedIcon.image = nil;
    }
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
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
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

- (void)ideaRemoved:(Idea *)idea {
    [_ideaTableView reloadData];
}

- (void)ideaAdded:(Idea *)idea {
    [_ideaTableView reloadData];
}

- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

@end
