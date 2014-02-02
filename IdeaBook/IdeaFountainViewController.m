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

@interface IdeaFountainViewController () {
    NSTimer* _newWordTimer;
}

@property (strong, nonatomic) NSMutableArray* currentWords;

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
    
    _currentWords = [[NSMutableArray alloc] init];
    
    [self runIdeaFountain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) runIdeaFountain {
    [self ideaFountainTick:nil];
    
    _newWordTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(ideaFountainTick:)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void) ideaFountainTick:(NSTimer *) timer {
    [self.collectionView performBatchUpdates:^{
        [_currentWords addObject:@[@"Hell World"]];
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_currentWords count] - 1 inSection:0]]];
    } completion:nil];
}

- (void)resetIdeaFountain {
    [_newWordTimer invalidate];
    
    [self.collectionView performBatchUpdates:^{
        IdeaFountainCollectionViewLayout* layout = (IdeaFountainCollectionViewLayout*)self.collectionViewLayout;
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
    
    return cell;
}

- (IBAction)reloadClicked:(id)sender {
    [self resetIdeaFountain];
}

@end
