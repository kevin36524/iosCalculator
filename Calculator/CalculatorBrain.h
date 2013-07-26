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
- (double) performOperation:(NSString*) operation;
- (void) clearMemory;

@property (readonly) id program;
+ (void) runProgram:(id) program;
+ (void) progDescription: (id) program;

@end
