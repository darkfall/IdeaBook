//
//  NearbyIdeaTableViewCell.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaNearbyTableViewCell.h"

#import "Models/Idea.h"
#import "Utils/ServerAPI.h"
#import "Utils/AlertHelper.h"

#import "NZAlertView.h"

#define REFRESH_TEXT(numLikes, numDislikesm, likeBtn, dislikeBtn) \
    _numLikesLabel.text = [NSString stringWithFormat:@"%i", numLikes]; \
    _numDislikesLabel.text = [NSString stringWithFormat:@"%i", numDislikes]; \
    if(likeBtn) \
        _likeButton.imageView.image = [UIImage imageNamed:likeBtn]; \
    if(dislikeBtn) \
        _dislikeButton.imageView.image = [UIImage imageNamed:dislikeBtn];

@interface IdeaNearbyTableViewCell ()

@end

@implementation IdeaNearbyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)likeClicked:(id)sender {
    if([_idea.liked intValue] == 0) {
        [ServerAPI likeIdea:_idea success:^(int numLikes, int numDislikes) {
            
            REFRESH_TEXT(numLikes, numDislikes, @"smile_light", @"smile");
            
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
            
            REFRESH_TEXT(numLikes, numDislikes, @"smile", @"smile_light");
            _idea.liked = [NSNumber numberWithInt:0];
            _idea.disliked = [NSNumber numberWithInt:1];
            
        } fail:^{
            
            [AlertHelper showNZAlert:@"Error" message:@"Dislike idea failed" style:NZAlertStyleError];
            
        } any:nil];
    } else {
        [ServerAPI cancelDislikeIdea:_idea success:^(int numLikes, int numDislikes) {
            
            REFRESH_TEXT(numLikes, numDislikes, @"smile_light", @"smile");
            _idea.disliked = [NSNumber numberWithInt:0];
            
        } fail:^{
            
            [AlertHelper showNZAlert:@"Error" message:@"Cancel dislike idea failed" style:NZAlertStyleError];
            
        } any:nil];
    }
}

@end
