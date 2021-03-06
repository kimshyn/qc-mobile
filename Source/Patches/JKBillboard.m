//
//  JKBillboard.m
//  QCDemos
//
//  Created by Joris Kluivers on 6/1/13.
//  Copyright (c) 2013 Joris Kluivers. All rights reserved.
//

#import <CoreImage/CoreImage.h>

#import "JKBillboard.h"
#import "JKContextUtil.h"

@implementation JKBillboard

@dynamic inputScale, inputPixelAligned, inputRotation;

- (id) initWithDictionary:(NSDictionary *)dict composition:(JKComposition *)composition
{
    self = [super initWithDictionary:dict composition:composition];
    
    if (self) {
        NSDictionary *state = dict[@"state"];
        
        _CIRendering = state[@"CIRendering"];
        _optimizedRendering = state[@"optimizedRendering"];
        _sizeMode = state[@"sizeMode"];
    }
    
    return self;
}

- (void) execute:(id<JKContext>)context atTime:(NSTimeInterval)time
{
    if (!self.inputImage) {
        // does not render when no image present
        return;
    }
    
    CGFloat width, height;
    CGFloat imageRatio =  self.inputImage.extent.size.height / self.inputImage.extent.size.width;
    
    if ([self.sizeMode isEqualToString:@"autoHeight"]) {
        width = [self.inputScale floatValue];
        height = width * imageRatio;
    } else if ([self.sizeMode isEqualToString:@"autoWidth"]) {
        height = [self.inputScale floatValue];
        width = height / imageRatio;
    } else if ([self.sizeMode isEqualToString:@"real"]) {
        width = JKPixelsToUnits(context, self.inputImage.extent.size.width);
        height = JKPixelsToUnits(context, self.inputImage.extent.size.height); 
    } else /*([self.sizeMode isEqualToString:@"custom"]) */ {
        // input width / height unchanged for custom mode
        width = [self.inputWidth floatValue];
        height = [self.inputHeight floatValue];
    }
    
    self.inputRZ = self.inputRotation;
    self.inputWidth = @(width);
    self.inputHeight = @(height);
    
    [super execute:context atTime:time];
}

@end
