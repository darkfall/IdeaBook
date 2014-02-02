//
//  IdeaTableViewCell.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaTableViewCell.h"

#import "Models/Idea.h"
#import "Utils/IdeaManager.h"
#import "Utils/GeoLocationManager.h"

@interface IdeaTableViewCell ()

@end


@implementation IdeaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)shareIdeaClicked:(id)sender {
    CLLocation* lastLoc = [[GeoLocationManager sharedInstance] lastLocation];
    if(lastLoc) {
        _idea.latitude = [NSNumber numberWithDouble:lastLoc.coordinate.latitude];
        _idea.longitude = [NSNumber numberWithDouble:lastLoc.coordinate.longitude];
    } else {
        _idea.latitude = [NSNumber numberWithDouble:0];
        _idea.longitude = [NSNumber numberWithDouble:0];
    }
    UIButton* btn = (UIButton*)sender;
    
    [[IdeaManager sharedInstance] shareOrCancelShareIdea:_idea onView:_parentTableView withNotification:YES onShared:^{
        
        btn.imageView.image = [UIImage imageNamed:@"brightness_light"];
        
    } onCancelled:^{
        
        btn.imageView.image = [UIImage imageNamed:@"brightness"];
        
    }];
    
}


@end
