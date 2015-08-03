//
//  ViewController.m
//  7.14-HTML_object-c_interaction
//
//  Created by linyibin on 15/7/14.
//  Copyright (c) 2015年 NXAristotle. All rights reserved.
//

#import "ViewController.h"
#import "NXInfoViewController.h"
#import "WKWebController.h"
#import "CALayer+Transition.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIView+Genie.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = item;
}
- (void)btnClick:(UIButton *)btn
{

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.8f animations:^{
        self.view.alpha = 1.f;
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIView animateWithDuration:0.8f animations:^{
        self.view.alpha = 0.f;
    }];
}

- (IBAction)jumpToInfo:(id)sender {
    
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGRect endRect = CGRectMake(width - 32, 42, 44, 44);
    NXInfoViewController *infoVc = [[NXInfoViewController alloc] init];
//
//    
//    
//    NSLog(@"%@",NSStringFromCGRect(endRect));
//    [self.view genieInTransitionWithDuration:0.8f destinationRect:endRect destinationEdge:BCRectEdgeBottom completion:^{
//        NSLog(@"complete");
//        
//        
//    }];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:infoVc];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:infoVc animated:YES];


}
- (IBAction)jumpToWkcontroller:(UIButton *)sender {
    
    WKWebController *wkController = [[WKWebController alloc] init];
    
    [self.navigationController pushViewController:wkController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
