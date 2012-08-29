//
//  RPNCalculatorEngine.m
//  RPNCalculator
//
//  Created by Kyle Maher on 8/26/12.
//  Copyright (c) 2012 Kyle Maher. All rights reserved.
//

#import "RPNCalculatorEngine.h"

@interface RPNCalculatorEngine()

@property (nonatomic, strong) NSMutableArray *programStack;

@end


@implementation RPNCalculatorEngine


@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil)
        _programStack = [[NSMutableArray alloc] init];
    
    return _programStack;
}


/**
 * Return a string representation of the program
 */
+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]])
         stack = [program mutableCopy];

    NSString *description = @"";
    id topOfStack;
    
    do
    {
        topOfStack = [stack lastObject];
        if (topOfStack)
            [stack removeLastObject];
        
        if (description != @"")
            description = [@" " stringByAppendingString:description];
    
        if ([topOfStack isKindOfClass:[NSNumber class]])
            description = [[topOfStack stringValue] stringByAppendingString:description];
        else if ([topOfStack isKindOfClass:[NSString class]])
            description = [topOfStack stringByAppendingString:description];
    } while (topOfStack);
    
    return description;
}


/**
 * Execute the program and return the result
 */
+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    
    return [self popOperandOffStack:stack];
}


/**
 * Take the next operand off the stack
 */
+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    NSString *operation;
    
    if (topOfStack)
        [stack removeLastObject];
    
    // Determine what is on our stack
    if ([topOfStack isKindOfClass:[NSNumber class]])
        return [topOfStack doubleValue];
    else if ([topOfStack isKindOfClass:[NSString class]])
        operation = topOfStack;
    
    // Handle our operation
    if ([operation isEqualToString:@"+"])
        result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
    else if ([operation isEqualToString:@"-"])
    {
        double secondOperand = [self popOperandOffStack:stack];
        result = [self popOperandOffStack:stack] - secondOperand;
    }
    else if ([operation isEqualToString:@"*"])
        result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
    else if ([operation isEqualToString:@"/"])
    {
        double secondOperand = [self popOperandOffStack:stack];
        result = [self popOperandOffStack:stack] / secondOperand;
    }
    else if ([operation isEqualToString:@"sin"])
        result = sin([self popOperandOffStack:stack]);
    else if ([operation isEqualToString:@"cos"])
        result = cos([self popOperandOffStack:stack]);
    else if ([operation isEqualToString:@"tan"])
        result = tan([self popOperandOffStack:stack]);
    else if ([operation isEqualToString:@"π"])
        result = M_PI;
    else if ([operation isEqualToString:@"√"])
        result = sqrt([self popOperandOffStack:stack]);
    else if ([operation isEqualToString:@"x^2"])
        result = pow([self popOperandOffStack:stack], 2);
    else if ([operation isEqualToString:@"x^3"])
        result = pow([self popOperandOffStack:stack], 3);
    else if ([operation isEqualToString:@"x^y"])
    {
        double secondOperand = [self popOperandOffStack:stack];
        result = pow([self popOperandOffStack:stack], secondOperand);
    }
    
    return result;
}


/**
 * Return a copy of our program
 */
- (id)program
{
    return [self.programStack copy];
}


/**
 * Clear the program
 */
- (void)clearStack
{
    [self.programStack removeAllObjects];
}


/**
 * Add an operand onto the end of the program
 */
- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


/**
 * Add an operation to the stack and evaluate the result
 */
- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    
    return [RPNCalculatorEngine runProgram:self.program];
}

@end
