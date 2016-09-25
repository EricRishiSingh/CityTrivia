//
//  Questions.h
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-26.
//  Copyright (c) 2013 Eric Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Questions : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    UIView *mask;
}

@property (nonatomic) NSUInteger questionCount;
@property (nonatomic) NSMutableArray *cityArray;
@property (nonatomic) NSString *currentCity;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *evaluateQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
//@property (weak, nonatomic) IBOutlet UIButton *goToCity;
//@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (nonatomic, retain) IBOutlet UIPickerView *cityPickerView;
@property (weak, nonatomic) IBOutlet UITextView *factTextField;
@property (weak, nonatomic) IBOutlet UIButton *factButton;


//- (IBAction)evaluateQuestionPressed:(id)sender;
//- (IBAction)goToCityPressed:(id)sender;

@end
