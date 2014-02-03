//
//  IdeaFountainViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaFountainViewController.h"
#import "IdeaFountainViewCell.h"
#import "IdeaFountainCollectionViewLayout.h"

#import "SWRevealViewController.h"

#import "Utils/WordManager.h"
#import "Utils/AlertHelper.h"
#import "Utils/UserManager.h"

#import "Segues/ModalViewSegue.h"

#import "NewIdeaViewController.h"

#import "NZAlertView.h"

@interface IdeaFountainViewController () {
    NSTimer* _newWordTimer;
    bool     _updating;
}

@property (strong, nonatomic) NSMutableArray* currentWords;
@property (strong, nonatomic) NSMutableArray* stashedWords;

@property (weak, nonatomic) NSArray* availableWords;

@end

@implementation IdeaFountainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
    
    {
        UIButton* stashedIdeaButton = [[UIButton alloc] init];
        [stashedIdeaButton setFrame:CGRectMake(216, self.view.bounds.size.height - 14, 100, 30)];
        [stashedIdeaButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [stashedIdeaButton setTitle:@"Create Idea" forState:UIControlStateNormal];
        
        stashedIdeaButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [stashedIdeaButton addTarget:self
                              action:@selector(onStashedIdeaClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:stashedIdeaButton];
        [self.view bringSubviewToFront:stashedIdeaButton];
        
        UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.view.bounds.size.height - 14, 200, 30)];
        hintLabel.text = @"Click on a idea to stash it";
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.textColor = [UIColor lightGrayColor];
        
        [self.view addSubview:hintLabel];
        [self.view bringSubviewToFront:hintLabel];
    }
    
    [self runIdeaFountain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) runIdeaFountain {
    _updating = false;
    _currentWords = [[NSMutableArray alloc] init];
    _stashedWords = [[NSMutableArray alloc] init];
    _availableWords = [[WordManager sharedInstance] getWords];
    
    if(_availableWords != nil) {
        [self ideaFountainTick:nil];
        [self resume];
        
    } else {
        [AlertHelper showNZAlert:@"Error" message:@"Unable to load idea word list" style:NZAlertStyleError];
    }
}

- (void)pause {
    [_newWordTimer invalidate];
}

- (void)resume {
    _newWordTimer = [NSTimer scheduledTimerWithTimeInterval:[UserManager getIdeaDropInterval]
                                                     target:self
                                                   selector:@selector(ideaFountainTick:)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)ideaFountainTick:(NSTimer *) timer {
    [self.collectionView performBatchUpdates:^{
        [_currentWords addObject: [_availableWords objectAtIndex:arc4random() % _availableWords.count]];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_currentWords count] - 1 inSection:0]]];
        
    } completion:nil];
}

- (void)resetIdeaFountain {
    if(_updating)
        return;
    
    [_newWordTimer invalidate];
    _updating = true;
    
    [self.collectionView performBatchUpdates:^{
        IdeaFountainCollectionViewLayout* layout = (IdeaFountainCollectionViewLayout*)self.collectionView.collectionViewLayout;
        [layout reset];
        
        NSMutableArray* indexPaths = [[NSMutableArray alloc] init];
        for(int i=0; i<_currentWords.count; ++i) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
        
        _currentWords = [[NSMutableArray alloc] init];
        
    } completion:^(BOOL finished) {
    
        [self runIdeaFountain];
    }];
    
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_currentWords count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IdeaFountainViewCell *cell = (IdeaFountainViewCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"wordCell" forIndexPath:indexPath];

    cell.stashed = false;
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    cell.wordLabel.textColor = [UIColor blackColor];

    cell.wordLabel.text = [_currentWords objectAtIndex:indexPath.row];
    cell.wordLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    IdeaFountainViewCell *datasetCell = (IdeaFountainViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if(!datasetCell.stashed) {
        datasetCell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        datasetCell.wordLabel.textColor = [UIColor lightGrayColor];
        
        IdeaFountainCollectionViewLayout* layout = (IdeaFountainCollectionViewLayout*)self.collectionView.collectionViewLayout;
        [layout removeGravityAtIndexPath:indexPath];
        
        [_stashedWords addObject:[_currentWords objectAtIndex:indexPath.row]];
    }
}

#pragma mark UICollectionViewDelegate methods
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
   
    
}

#pragma SWRevealViewDelegate methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    
}

#pragma mark actions

- (IBAction)reloadClicked:(id)sender {
    [self resetIdeaFountain];
}


- (IBAction)showSidebar:(id)sender {
    [self.revealViewController revealToggle:self];
}

- (void)onStashedIdeaClicked: (id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewIdeaViewController* nv = [sb instantiateViewControllerWithIdentifier:@"newidea"];
    
    ModalViewSegue* segue = [[ModalViewSegue alloc] initWithIdentifier:@"shownewidea" source:self destination:nv];
    [self prepareForSegue:segue sender:self];
    [segue perform];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"shownewidea"]) {
        NewIdeaViewController* newIdeaView = (NewIdeaViewController*)segue.destinationViewController;
        
        NSString* ideaContent = [_stashedWords componentsJoinedByString:@", "];
        [newIdeaView setIdeaContent:ideaContent];
    }
}

@end
