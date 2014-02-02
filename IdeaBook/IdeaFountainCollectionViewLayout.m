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
    
    [_dynamicAnimator addBehavior:_gravityBehavior];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [_dynamicAnimator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}


-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
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
        } else if(updateItem.updateAction == UICollectionUpdateActionMove) {
            
        }}];
}

@end
