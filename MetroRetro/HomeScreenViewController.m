//
//  HomeScreenViewController.m
//  MetroRetro
//
//  Created by Terell Pigram on 8/7/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "CoreDataManager.h"
#import "LoginServices.h"

@interface HomeScreenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *email;
@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObject *object = [[CoreDataManager sharedManager] getLoggedInUsersettingsByUsername:@"tpigram"];
    self.email.text = [object valueForKey:@"email"];
    
    [[LoginServices shareInstance] requestAllTeamsWithCompletionHandler:^(NSArray *data, NSError *error) {
        NSLog(@"%@", data);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
