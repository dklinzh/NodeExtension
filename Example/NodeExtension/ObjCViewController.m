//
//  ObjCViewController.m
//  NodeExtension_Example
//
//  Created by Linzh on 11/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "ObjCViewController.h"
@import NodeExtension;
@import AsyncDisplayKit;

@interface ObjCViewController ()

@end

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] init];
    [button dl_addControlWithEvents:UIControlEventTouchUpInside action:^(UIControl * _Nonnull sender) {
        
    }];
    [self.view addSubview:button];
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
