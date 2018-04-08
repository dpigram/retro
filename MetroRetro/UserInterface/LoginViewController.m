//
//  LoginViewController.m
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginServices.h"
#import "MetroRetro-Swift.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *credsBackgroudView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self styleTextFields];
}

- (void)styleTextFields{
    self.username.layer.borderColor = UIColor.grayColor.CGColor;
    self.username.layer.borderWidth = 1;
    self.username.layer.cornerRadius = 0;
    
    self.password.layer.borderColor = UIColor.grayColor.CGColor;
    self.password.layer.borderWidth = 1;
    self.password.layer.cornerRadius = 0;
    
    self.credsBackgroudView.layer.borderWidth = 1;
    self.credsBackgroudView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.credsBackgroudView.layer.cornerRadius = 5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forgotPasswordTapped:(id)sender {
    NSLog(@"forgot password");
}


- (IBAction)SignInButtonTapped:(id)sender {
    NSString *myString = [NSString stringWithFormat:@"usrname: %@, passowrd %@", self.username.text, self.password.text];
    NSLog(@"%@", myString);
    
    if([self validateCreds]){
        LoginServices *service = [LoginServices shareInstance];
        
        [service authenticateWithUsername:self.username.text andPassword:self.password.text withCompletionHandler:^(NSDictionary *data, NSError *error) {
            if (!error) {
                NSString *status = [data valueForKey:@"status"];
                NSString *message = [data valueForKey:@"message"];
                NSMutableDictionary *userData = [data valueForKey:@"data"];
                
                if([status isEqualToString:@"success"]){
                    [service replaceUserSettingsWithUserData:userData withCompletionHandler:^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
                else{
                    [self showErrorMessage:(NSString *)message];
                }
            } else {
                //handle error
            }
        }];
    }
}

- (void)showErrorMessage:(NSString*)message{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Invalid Login" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:action];
    [self presentViewController:errorAlert animated:true completion:nil];
}

- (IBAction)signUpButtonTapped:(id)sender {
    NSLog(@"Sign Up");
}

- (BOOL) validateCreds{
    if(self.username.text && self.username.text.length > 0 && self.password.text && self.password.text.length > 0){
        return true;
    }
    else{
        if((!self.username.text || self.username.text.length == 0) && (!self.password.text || self.password.text.length == 0)){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication Failure" message:@"Please enter a username and a password" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
        else if(!self.username.text || self.username.text.length == 0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication Failure" message:@"Please enter a username" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
        else if(!self.password.text || self.password.text.length == 0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Authentication Failure" message:@"Please enter a password" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
        return false;
    }
    return false;
}
@end
