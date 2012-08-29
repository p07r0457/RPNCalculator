//
//  RPNCalculatorEngine.h
//  RPNCalculator
//
//  Created by Kyle Maher on 8/26/12.
//  Copyright (c) 2012 Kyle Maher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPNCalculatorEngine : NSObject

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

- (void)clearStack;
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;

@end
