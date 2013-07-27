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

- (void) pushOperandObj:(id) value {
    [self.programStack addObject:value];
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


+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet * retSet = nil;
    id obj;
    
    for ( obj in program) {
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            if (!retSet) {retSet = [[NSMutableSet alloc] init]; }
            [retSet addObject:obj];
        }
    }
    
    return [retSet copy];
}

/* no longer needed just kept for backward compatibility */
+ (double) runProgram:(id)program {
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray * mutableProgram = [[NSMutableArray alloc] init];
    NSSet *varSet;
    NSNumber *varVal;
    id loopObj;
    
    if ([program isKindOfClass:[NSArray class]]) {
        varSet = [self variablesUsedInProgram:[program copy]];
    }
    if (varSet) {
        for (loopObj in program) {
            if ([varSet containsObject:loopObj]){
                varVal = [variableValues objectForKey:loopObj];
                if (!varVal) varVal = [NSNumber numberWithDouble:0];
                [mutableProgram addObject:varVal];
            } else {
                [mutableProgram addObject:loopObj];
            }
        }
    }
    
    return [self evalStack: mutableProgram];
}

- (double) performOperation:(NSString *)operation {
    double result;
    
    [self.programStack addObject:operation];
    result = [[self class] runProgram:self.program usingVariableValues:nil];
    
    return result;
}

+ (BOOL)isOperation:(NSString *)operation {
    BOOL retVal = YES;
    if ([[self getOperationType:operation] isEqual:@"variable"]) {
        retVal = NO;
    }
    return retVal;
}

+ (NSString *) getOperationType: (NSString*) operation {
    NSSet *noaryOperation = [[NSSet alloc] initWithObjects:@"π",nil];
    NSSet *unaryOperation = [[NSSet alloc] initWithObjects:@"cos",@"sin",@"sqrt", nil ];
    NSSet *binaryOperation = [[NSSet alloc] initWithObjects:@"+",@"-",@"/",@"*", nil];
    NSString *result = @"variable";
    
    if ([noaryOperation containsObject:operation]) {
        result = @"noary";
    } else if ([unaryOperation containsObject:operation]) {
        result = @"unary";
    } else if ([binaryOperation containsObject:operation]) {
        result = @"binary";
    }
    return result;
}

+ (NSString *)descriptionOfTopOfStack: (NSMutableArray *) localArray {
    id topObject;
    NSString *operationType, *tempVal, *retStr = @"";
    
    topObject = [localArray lastObject];
    
    if (topObject){
        [localArray removeLastObject];
        if ([topObject isKindOfClass:[NSNumber class]]) {
            retStr = [NSString stringWithFormat:@" %g",[topObject doubleValue]];
        } else if ([topObject isKindOfClass:[NSString class]]) {
            operationType = [self getOperationType:topObject];
            if ([operationType isEqual:@"noary"] || [operationType isEqual:@"variable"]) {
                retStr = topObject;
            } else if ([operationType isEqual:@"unary"]) {
                retStr = [NSString stringWithFormat:@"%@( %@ )",topObject,[self descriptionOfTopOfStack:localArray]];
            } else if ([operationType isEqual:@"binary"]) {
                tempVal = [self descriptionOfTopOfStack:localArray];
                retStr = [NSString stringWithFormat:@"(%@ %@ %@)", [self descriptionOfTopOfStack:localArray], topObject, tempVal];
            }
        }
    }
    return retStr;
}


+ (NSString *) descriptionOfProgram: (id) program {
    NSMutableArray *newStack = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        program = [program mutableCopy];
        while ([program lastObject]) {
            [newStack addObject:[self descriptionOfTopOfStack:program]];
        }
    }
    return [newStack componentsJoinedByString:@","];
}

- (NSString *) description {
    
    return [[self class] descriptionOfProgram:self.program];
    //return [self.program componentsJoinedByString:@" "];
}

@end
