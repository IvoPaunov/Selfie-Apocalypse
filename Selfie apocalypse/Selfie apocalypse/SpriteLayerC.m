//
//  SpriteLayerC.m
//  Selfie apocalypse
//
//  Created by Ivko on 2/3/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

#import "SpriteLayerC.h"

@implementation SpriteLayerC

@synthesize sampleIndex;
@synthesize currentAnimation;

// redraw the layer only when the sampleIndex change
+ (BOOL) needsDisplayForKey: (NSString *) key
{
    return [key isEqualToString: @"sampleIndex"];
}

// avoid default actions for animated properties
+ (id<CAAction>) defaultActionForKey: (NSString *) aKey
{
    if ([aKey isEqualToString: @"contentsRect"] || [aKey isEqualToString: @"bounds"] || [aKey isEqualToString: @"position"]) {
        return (id<CAAction>)[NSNull null];
    }
    
    return [super defaultActionForKey: aKey];
}

- (void) display
{
    if ([self.delegate respondsToSelector: @selector(displayLayer:)]) {
        [self.delegate displayLayer: self];
        return;
    }
    
    unsigned int currentSampleIndex = [self currentSampleIndex];
    if (!currentSampleIndex) {
        return;
    }
    
    CGSize sampleSize = self.contentsRect.size;
    
    float offsetX = ((currentSampleIndex - 1) % (int)(1.0 / sampleSize.width)) * sampleSize.width;
    float offsetY = ((currentSampleIndex -1) / (int)(1.0 / sampleSize.height)) * sampleSize.height;
    
    self.contentsRect = CGRectMake(offsetX, offsetY, sampleSize.width, sampleSize.height);
}

- (unsigned int) currentSampleIndex
{
    return ((SpriteLayerC *) [self presentationLayer]).sampleIndex;
}

+ (id) layerWithImageAndAnimationSettings: (UIImage *) img
                               sampleSize: (CGSize) size
                      animationFrameStart:(int) startFrame
                        animationFrameEnd: (int) endFrame
                        animationDuration: (float) duration
                            lanimationRepeatCount:(float) repeatCount
{
    return [[SpriteLayerC alloc] initWithAndAnimationSettings: img
                                                   sampleSize: size
                                          animationFrameStart:startFrame
                                            animationFrameEnd:endFrame
                                            animationDuration:duration
                                        lanimationRepeatCount:repeatCount];
}

- (id) initWithAndAnimationSettings: (UIImage *) img
                         sampleSize: (CGSize) size
                animationFrameStart: (int) startFrame
                  animationFrameEnd: (int) endFrame
                  animationDuration: (float) duration
              lanimationRepeatCount: (float) repeatCount
{
    self = [super init];
    if (self != nil) {
        self.contents = (id) img.CGImage;
        sampleIndex = 1;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath: @"sampleIndex"];
        anim.fromValue = [NSNumber numberWithInt: startFrame];
        anim.toValue = [NSNumber numberWithInt: endFrame];
        anim.duration = duration;
        anim.repeatCount = repeatCount;
        //anim.autoreverses = false;
        
        currentAnimation = anim;
        
       // [self addAnimation: anim forKey: nil];
    }
    
    if (self != nil) {
        CGSize sampleSizeNormalized = CGSizeMake(size.width / CGImageGetWidth(img.CGImage), size.height / CGImageGetHeight(img.CGImage));
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        self.contentsRect = CGRectMake(0, 0, sampleSizeNormalized.width, sampleSizeNormalized.height);
    }
    
    return self;
}

-(void) playAnimationAgain {
    [self addAnimation: currentAnimation forKey: nil];
}


+(void) playAnimationAgain {
    
    [self playAnimationAgain];
}

@end
