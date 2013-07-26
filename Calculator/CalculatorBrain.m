//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kevin Patel on 7/26/13.
//  Copyright (c) 2013 Kevin Patel. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (strong,nonatomic) NSMutableArray *operandStack;
@property (strong,nonatomic) NSString *displayStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;
@synthesize displayStack = _displayStack;

- (NSString *) displayStack {
    if (!_displayStack) {
        _displayStack = @"";
    }
    return _displayStack;
}

- (NSMutableArray *) operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}



- (void) justPushOperand:(double)value {
    [self.operandStack addObject:[NSNumber numberWithDouble:value]];
}

- (void) pushOperand:(double)value {
    [self justPushOperand:value];
    self.displayStack = [self.displayStack stringByAppendingFormat:@"%g ",value];
}

- (void) clearMemory {
    [self.operandStack removeAllObjects];
    self.displayStack = @"";
}

- (double) popOperand {
    NSNumber *numObj;
    
    numObj = [self.operandStack lastObject];
    if(numObj) [self.operandStack removeLastObject];
    return [numObj doubleValue];
}

- (double) performOperation:(NSString *)operation {
    double result = 0;
    double tempVal;
    
    if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        tempVal = [self popOperand];
        result = [self popOperand] / tempVal;
    } else if ([operation isEqualToString:@"-"]) {
        tempVal = [self popOperand];
        result = [self popOperand] - tempVal;
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = 3.14;
    }
    
    self.displayStack = [self.displayStack stringByAppendingFormat:@"%@ ",operation];
    [self justPushOperand:result];
    return result;
}

- (NSString *) description {
    return self.displayStack;
}

@end
