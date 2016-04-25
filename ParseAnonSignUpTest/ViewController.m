//
//  ViewController.m
//  ParseAnonSignUpTest
//
//  Created by Calvin Yu on 4/25/16.
//  Copyright © 2016 BlueboardMedia. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runTest:(id)sender {
    if ([PFUser currentUser] != nil) {
        [PFUser logOut];
    }
    [PFAnonymousUtils logInWithBlock:^(PFUser* user, NSError *error) {
        if (!user) {
            NSLog(@"error on anonymous login: %@", error);
        } else {
            NSLog(@"login successful: %@", user.objectId);
            [self callCloudFunction];
        }
    }];
}

- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser currentUser];
    if (user == nil) {
        user = [PFUser user];
    }
    user.username = self.username.text;
    user.password = self.password.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"sign up succeeded");
            [self callCloudFunction];
        } else {
            NSLog(@"sign up failed: %@", error);
        }
    }];
}

- (void)callCloudFunction
{
    NSLog(@"running cloud function");
    [PFCloud callFunctionInBackground:@"hello" withParameters:nil block:^(id  _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"cloud function error: %@", error);
            [self callCloudFunction];
        } else {
            NSLog(@"cloud function result: %@", object);
        }
    }];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"logout error: %@", error);
        } else {
            NSLog(@"logout successful");
        }
    }];
}

@end
