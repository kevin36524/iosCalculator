//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kevin Patel on 7/26/13.
//  Copyright (c) 2013 Kevin Patel. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (strong,nonatomic) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;


- (NSMutableArray *) programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id) program {
    return [self.programStack copy];
}

- (void) pushOperand:(double)value {
    [self.programStack addObject:[NSNumber numberWithDouble:value]];
}

- (void) clearMemory {
    [self.programStack removeAllObjects];
}

+ (double) evalStack:(NSMutableArray *) localStack {
    id topObj = [localStack lastObject];
    double tempVal,result = 0;
    NSString *operation;
    
    if (topObj) [localStack removeLastObject];
    
    if ([topObj isKindOfClass:[NSNumber class]]) {
        result = [topObj doubleValue];
    } else if ([topObj isKindOfClass:[NSString class]]){
        operation = (NSString *)topObj;
        if ([operation isEqualToString:@"*"]) {
            result = [self evalStack: localStack] * [self evalStack: localStack];
        } else if ([operation isEqualToString:@"+"]) {
            result = [self evalStack: localStack] + [self evalStack: localStack];
        } else if ([operation isEqualToString:@"/"]) {
            tempVal = [self evalStack: localStack];
            result = [self evalStack: localStack] / tempVal;
        } else if ([operation isEqualToString:@"-"]) {
            tempVal = [self evalStack: localStack];
            result = [self evalStack: localStack] - tempVal;
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self evalStack: localStack]);
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self evalStack: localStack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self evalStack: localStack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = 3.14;
        }
    }
    
    return result;
}

+ (double) runProgram:(id)program {
    double result = 0;
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableArray *localStack = [program mutableCopy];
        result = [self evalStack: localStack];
    }
    return result;
}

- (double) performOperation:(NSString *)operation {
    double result;
    
    [self.programStack addObject:operation];
    result = [[self class] runProgram:self.program];
    
    return result;
}

+ (NSString *) progDescription: (id) program {
    NSArray *stackArr;
    NSString *retString = @"";
    
    if ([program isKindOfClass:[NSArray class]]) {
        stackArr = program;
        retString = [stackArr componentsJoinedByString:@" "];
    }
    
    return retString;
}

- (NSString *) description {
    return [[self class] progDescription:self.program];
}

@end
