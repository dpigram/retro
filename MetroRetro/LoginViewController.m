//
//  LoginViewController.m
//  MetroRetro
//
//  Created by Terell Pigram on 8/5/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginServices.h"
#import "HomeScreenViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forgotPasswordTapped:(id)sender {
    NSLog(@"forgot password");
}
- (IBAction)signUpButtonTapped:(id)sender {
   
}
- (IBAction)SignInButtonTapped:(id)sender {
    NSString *myString = [NSString stringWithFormat:@"usrname: %@, passowrd %@", self.username.text, self.password.text];
    NSLog(@"%@", myString);
    
    if([self validateCreds]){
        LoginServices *service = [[LoginServices alloc] init];
        [service AuthenticateWithUsername:self.username.text andPassword:self.password.text withCompletionHandler:^(NSDictionary *data) {
            NSString *status = [data valueForKey:@"status"];
            NSString *message = [data valueForKey:@"message"];
            NSMutableDictionary *userData = [data valueForKey:@"data"];
            
            if([status isEqualToString:@"success"]){
                [service replaceUserSettingsWithUserData:userData withCompletionHandler:^{
                    HomeScreenViewController *home = [[HomeScreenViewController alloc] init];
                    [self presentViewController:home animated:true completion:nil];
                }];
            }
            else{
                
            }
            
        }];
    }
    
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