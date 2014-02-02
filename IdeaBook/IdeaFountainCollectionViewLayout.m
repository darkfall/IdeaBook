//
//  IdeaFountainCollectionViewLayout.m
//  IdeaBook
//
//  Created by Robert Bu on 2/1/14.
//  Copyright (c) 2014 Robert Bu. All rights reserved.
//

#import "IdeaFountainCollectionViewLayout.h"

#define kCellItemWidth 120
#define kCellItemHeight 40

@interface IdeaFountainCollectionViewLayout () {
    
}

@property (strong, nonatomic) UIDynamicAnimator* dynamicAnimator;
@property (strong, nonatomic) UIGravityBehavior* gravityBehavior;

@property (strong, nonatomic) UIGravityBehavior* gravityBehaviorNoGravity;

@end

@implementation IdeaFountainCollectionViewLayout

- (id)init {
    if (self = [super init]) {
        #pragma mark
        // why init is not called when designed in storyboard...
    }
    
    return self;
}

- (void)prepareLayout {
    if(_dynamicAnimator == nil) {
        [self reset];
    }
}

- (void)reset {
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _gravityBehavior = [[UIGravityBehavior alloc] init];
    _gravityBehavior.gravityDirection = CGVectorMake(0, 0.05);
    
    _gravityBehaviorNoGravity = [[UIGravityBehavior alloc] init];
    _gravityBehaviorNoGravity.gravityDirection = CGVectorMake(0, 0);
    
    [_dynamicAnimator addBehavior:_gravityBehavior];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [_dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}


-(CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, 416);
}

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                            layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
            
            int32_t w = arc4random() % ((int)self.collectionView.bounds.size.width - kCellItemWidth);
            attributes.frame = CGRectMake(w,
                                          self.collectionView.bounds.origin.y - kCellItemHeight,
                                          kCellItemWidth,
                                          kCellItemHeight);
            
            
            
            [_gravityBehavior addItem:attributes];
           // [_gravityBehaviorNoGravity addItem:attributes];
        }
    }];
}

- (void)removeGravityAtIndexPath:(NSIndexPath*)indexPath {
    UICollectionViewLayoutAttributes *attributes = [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    
    UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:attributes
                                                                  attachedToAnchor:CGPointMake(CGRectGetMidX(attributes.frame), CGRectGetMidY(attributes.frame))];
    NSLog(@"%f, %f", attributes.frame.origin.x, attributes.frame.origin.y);
    
    behaviour.length = 0.0f;
    behaviour.damping = 0.8f;
    behaviour.frequency = 1.0f;
    
    [self.dynamicAnimator addBehavior:behaviour];
    [_gravityBehavior removeItem:attributes];
}

-(void)removeItemAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion {
    __block UICollectionViewLayoutAttributes *attributes = [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_gravityBehavior removeItem:attributes];
        
        [self.collectionView performBatchUpdates:^{
            completion();
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    });
    
    
}

@end
