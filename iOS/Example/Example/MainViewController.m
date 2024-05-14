//
//  MainViewController.m
//  Example
//
//  Created by Bingo on 2024/4/19.
//

#import "MainViewController.h"
#import "AUIShortEpisodeViewController.h"
#import "Masonry.h"
#import "AUIFoundation.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    AVBlockButton *btn = [AVBlockButton new];
    [btn setTitle:@"进入短剧" forState:UIControlStateNormal];
    [btn setTitleColor:AVTheme.text_strong forState:UIControlStateNormal];
    btn.backgroundColor = AVTheme.colourful_fill_strong;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.mas_equalTo(40);
        make.center.equalTo(self.view);
    }];
    
    btn.clickBlock = ^(AVBlockButton * _Nonnull sender) {
        [self.navigationController pushViewController:[AUIShortEpisodeViewController new] animated:YES];
    };
}

@end
