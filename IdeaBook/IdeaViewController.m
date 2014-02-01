//
//  FirstViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 1/30/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaViewController.h"
#import "SWRevealViewController/SWRevealViewController.h"

#import "NewIdeaViewController.h"

#import "Models/Idea.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ideaCell" forIndexPath:indexPath];
    NSMutableArray* ideas = [[IdeaManager sharedInstance] ideas];
    cell.textLabel.text = [(Idea*)[ideas objectAtIndex:indexPath.row] content];
    return cell;
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
