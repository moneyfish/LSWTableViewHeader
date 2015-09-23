//
//  LSWTestAViewController.m
//  LSWTableViewHeaderDemo
//
//  Created by sWen on 15/9/22.
//  Copyright (c) 2015年 sWen. All rights reserved.
//

#import "LSWTestAViewController.h"
#import "LSWTestBViewController.h"
#import "UIImage+UIColor.h"
#import <Masonry.h>

// 获取RGB颜色
#define ColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ColorRGB(r,g,b) ColorRGBA(r,g,b,1.0f)

const CGFloat LSWHeaderViewHeight = 180;

@interface LSWTestAViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    UIImageView *_headerImageView;
    MASConstraint *_headerViewLeftConstraint;//左边约束
    MASConstraint *_headerViewWidthConstraint;//宽的约束
    MASConstraint *_headerViewTopConstraint;//上边的约束
    MASConstraint *_headerViewHeightConstraint;//高的约束
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LSWTestAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

/**
 *  初始化导航栏
 */
- (void)setNavigationBar{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [settingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(0, 0, 40, 25);
    [settingButton addTarget:self action:@selector(settingButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
}

/**
 *  下拉图片放大
 */
- (void)setHeaderView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[[UIColor clearColor] colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    _tableView.contentInset= UIEdgeInsetsMake(LSWHeaderViewHeight, 0, 0, 0);
    
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.jpg"]];
    _headerImageView.backgroundColor = [UIColor clearColor];
    [_tableView addSubview:_headerImageView];
    
    //设置约束之前，一定要先把‘子视图’添加到‘父视图’，否则会报错
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        _headerViewLeftConstraint = make.left.equalTo(@0);
        _headerViewWidthConstraint = make.width.equalTo(@(_tableView.frame.size.width));
        _headerViewTopConstraint = make.top.equalTo(@(-LSWHeaderViewHeight));
        _headerViewHeightConstraint = make.height.equalTo(@(LSWHeaderViewHeight));
    }];
    
    //在headerImageView中添加一个Label
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:20.0];         //用label来设置字体大小
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor redColor];
    tipLabel.text = NSLocalizedString(@"下拉放大", nil);
    [_headerImageView addSubview:tipLabel];
    
    //为tipLabel添加约束
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

#pragma mark - UIButton Action

- (void)settingButtonAction:(UIButton *)sender {
    //LSWTestBViewController *testBVC = [[LSWTestBViewController alloc] init];
    //[self.navigationController pushViewController:testBVC animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + LSWHeaderViewHeight)/2;
    if (yOffset < -LSWHeaderViewHeight) {
        _headerViewTopConstraint.offset = yOffset;
        _headerViewLeftConstraint.offset = xOffset;
        _headerViewWidthConstraint.offset = _tableView.frame.size.width + fabs(xOffset) * 2;
        _headerViewHeightConstraint.offset = -yOffset;
    }
    CGFloat alpha = (yOffset + LSWHeaderViewHeight)/LSWHeaderViewHeight;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ColorRGB(94.0, 158.0, 236.0) colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    alpha = fabs(alpha);
    alpha = fabs(1 - alpha);
    alpha = alpha < 0.5 ? 0.5 : alpha;
    _headerImageView.alpha = alpha;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"indexRow:%zd", indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self settingButtonAction:nil];
}

@end
