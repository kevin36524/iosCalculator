//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Kevin Patel on 7/26/13.
//  Copyright (c) 2013 Kevin Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double) value;
- (void) pushOperandObj:(id) value;
- (double) performOperation:(NSString *)operation;
- (double) performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues;
- (void) removeTopOfStack;
- (void) clearMemory;

@property (readonly) id program;
@property (readonly) id opDictionary;

+ (double) runProgram:(id) program;
+ (NSString *) descriptionOfProgram: (id) program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@end
