//
//  IdeaNearbyDetailViewController.m
//  IdeaBook
//
//  Created by Robert Bu on 2/2/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaNearbyDetailViewController.h"

#import "Models/Idea.h"
#import "Models/IdeaComment.h"
#import "Models/IdeaUser.h"

#import "Utils/ServerAPI.h"
#import "Utils/AlertHelper.h"
#import "Utils/GeoLocationManager.h"

#import "NZAlertView.h"

#import "IdeaNearbyCommentCell.h"
#import "IdeaNearbyDetailCell.h"

#import "ColorScheme.h"


#define REFRESH_TEXT(numLikes, numDislikesm, likeBtn, dislikeBtn) \
    if(likeBtn) \
        _likeButton.imageView.image = [UIImage imageNamed:likeBtn]; \
    if(dislikeBtn) \
        _dislikeButton.imageView.image = [UIImage imageNamed:dislikeBtn]; \
    IdeaNearbyDetailCell* cell = (IdeaNearbyDetailCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:kIdeaMainViewSection]]; \
    cell.numLikeDislikeLabel.text = [NSString stringWithFormat:@"%d likes   %d dislikes", [[_idea likes] intValue], [[_idea dislikes] intValue]]; \

/*
_numLikesLabel.text = [NSString stringWithFormat:@"%i", numLikes]; \
_numDislikesLabel.text = [NSString stringWithFormat:@"%i", numDislikes]; \
*/
@interface IdeaNearbyDetailViewController () {
    UIActivityIndicatorView* _commentLoadingIndicator;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray* comments;

@end

@implementation IdeaNearbyDetailViewController

#define kIdeaMainViewSection 0
#define kMainCellHeight      160
#define kCommentCellHeight   75
- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _commentLoadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.tableView.bounds.size.width / 2 - 24, 250, 48, 48)];
    [_commentLoadingIndicator setColor:[UIColor blackColor]];
    [self.view addSubview:_commentLoadingIndicator];
    [self.view bringSubviewToFront:_commentLoadingIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if([_idea.liked intValue] > 0) {
        _likeButton.imageView.image = [UIImage imageNamed:@"smile_light"];
    } else {
        _likeButton.imageView.image = [UIImage imageNamed:@"smile"];
    }
    
    if([_idea.disliked intValue] > 0) {
        _dislikeButton.imageView.image = [UIImage imageNamed:@"smile_sad_light"];
    } else {
        _dislikeButton.imageView.image = [UIImage imageNamed:@"smile_sad"];
    }
    
    [_commentLoadingIndicator startAnimating];
    
    _comments = [[NSArray alloc] init];
    [ServerAPI getComments:_idea success:^(NSArray* comments) {
        
        [_commentLoadingIndicator stopAnimating];
        
        _comments = comments;
        
        [_tableView reloadData];
        
    } fail:^{
        [AlertHelper showNZAlert:@"Error" message:@"Failed to get idea comments" style:NZAlertStyleError];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + _comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == kIdeaMainViewSection) {
        IdeaNearbyDetailCell* cell = (IdeaNearbyDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"ideamain" forIndexPath:indexPath];

        cell.ideaContent.text = _idea.content;
        cell.userNameLabel.text = _idea.username;
        
        float dist = [[GeoLocationManager sharedInstance] distanceFromCurrentLocation:[_idea.latitude floatValue]
                                                                            longitude:[_idea.longitude floatValue]];
        if(dist > 0) {
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fmi away", dist];
        } else {
            cell.distanceLabel.text = @"unknown mi away";
        }
        
        cell.numLikeDislikeLabel.text = [NSString stringWithFormat:@"%d likes   %d dislikes", [[_idea likes] intValue], [[_idea dislikes] intValue]];
        
        return cell;
        
    } else {
        
        IdeaNearbyCommentCell* cell = (IdeaNearbyCommentCell*)[tableView dequeueReusableCellWithIdentifier:@"ideacomment" forIndexPath:indexPath];
   
        IdeaComment* comment = [_comments objectAtIndex:indexPath.section - 1];
        
        cell.commentDetail.text = comment.content;
        cell.commentorName.text = [@"By " stringByAppendingString: comment.user_name];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kIdeaMainViewSection) {
        return kMainCellHeight;
    } else {
        return kCommentCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0f];
    [view setBackgroundColor:kCellBackgroundColor];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0f];
    [view setBackgroundColor:kCellBackgroundColor];
    return view;
    
}

#pragma mark - actions

- (IBAction)likeClicked:(id)sender {
    if([_idea.liked intValue] == 0) {
        [ServerAPI likeIdea:_idea success:^(int numLikes, int numDislikes) {
            
            REFRESH_TEXT(numLikes, numDislikes, @"smile_light", @"smile_sad");
           
            
        } fail:^{
            
            [AlertHelper showNZAlert:@"Error" message:@"Like idea failed" style:NZAlertStyleError];
            
        } any:nil];
    } else {
        [ServerAPI cancelLikeIdea:_idea success:^(int numLikes, int numDislikes) {
            
            REFRESH_TEXT(numLikes, numDislikes, @"smile", nil);
            _idea.liked = [NSNumber numberWithInt:0];
            
        } fail:^{
            
            [AlertHelper showNZAlert:@"Error" message:@"Cancel like idea failed" style:NZAlertStyleError];
            
        } any:nil];
    }
}

- (IBAction)dislikeClicked:(id)sender {
    if([_idea.disliked intValue] == 0) {
        [ServerAPI dislikeIdea:_idea success:^(int numLikes, int numDislikes) {
            
            REFRESH_TEXT(numLikes, numDislikes, @"smile", @"smile_sad_light");
            _idea.liked = [NSNumber numberWithInt:0];
            _idea.disliked = [NSNumber numberWithInt:1];
            
        } fail:^{
            
            [AlertHelper showNZAlert:@"Error" message:@"Dislike idea failed" style:NZAlertStyleError];
            
        } any:nil];
    } else {
        [ServerAPI cancelDislikeIdea:_idea success:^(int numLikes, int numDislikes) {
            
            REFRESH_TEXT(numLikes, numDislikes, nil, @"smile_sad");
            _idea.disliked = [NSNumber numberWithInt:0];
            
        } fail:^{
            
            [AlertHelper showNZAlert:@"Error" message:@"Cancel dislike idea failed" style:NZAlertStyleError];
            
        } any:nil];
    }
}

- (IBAction)commentClicked:(id)sender {
    
}

@end
