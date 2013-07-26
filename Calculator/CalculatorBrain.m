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
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack {
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void) pushOperand:(double)value {
    [self.operandStack addObject:[NSNumber numberWithDouble:value]];
}

- (void) clearMemory {
    [self.operandStack removeAllObjects];
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
    
    [self pushOperand:result];
    return result;
}

@end
