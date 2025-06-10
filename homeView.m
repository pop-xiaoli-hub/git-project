//
//  HomeViewController.m
//  ZARA
//
//  Created by xiaoli pop on 2025/6/5.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong)NSTimer* timer;
@property (nonatomic, strong)UIImage* logo;
@end

/*
 OC中实现滚动视图需要下面的步骤
 1.设置内容尺寸
 2.添加子视图
 3.配置滚动行为
 注意事项：
 1.滚动视图的内容区域大小必须大于视图区域才能滚动
 2.contentOffset:当前滚动位置
 contentInset:内容区域的内边距
 */
/*
 UIPageControl是iOS开发中用于显示页面的指示器的控件，通常与滚动视图配合使用，指示当前页面位置和总页面数量
 基本功能：
 1显示页面指示器：通过小圆点表示当前页面和总页面数量
 2交互响应：用户可以点击指示器切换页面
 3自定义样式
 核心属性：
 1.numberOfPage:总页面数
 2.currentPage:当前选中的页面索引
 3.pageIndicatorTintColor：未选中页面的指示器颜色
 4.currentPageIndicatorTintColor：当前选中页面指示器的颜色
 5.hidesForSinglePage：只有一页时是否隐藏指示器
 常用方法：
 1.updateCurrentPageDisplay():更新指示器的当前选中状态
 2.addTarget：添加点击事件监听
 */
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self setupScrollView];
    [self.view addSubview: self.scrollView];
    [self creatPageControl];
    [self setupTimer];
    [self creatLogo];

}


- (void)creatLogo {
    self.logo = [UIImage imageNamed:@"logo.jpg"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:self.logo];
    imageView.frame = CGRectMake(50,70, 140, 70);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:imageView];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 150, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 320);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat h = [[UIScreen mainScreen] bounds].size.height - 320;
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    self.scrollView.contentSize = CGSizeMake(w * 7, h);
    for (int i = 0; i < 7; i++) {
        UIImage* image = [[UIImage alloc] init];
        if (i == 0) {
            image = [UIImage imageNamed:@"photo05.jpg"];
        } else if (i == 6) {
            image = [UIImage imageNamed:@"photo01.jpg"];
        } else {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"photo0%d.jpg",i]];
        }
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * w, 0, w, h);
        [self.scrollView addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat screenWidth = CGRectGetWidth(scrollView.frame);
    CGFloat contentWidth = scrollView.contentSize.width;
    
    if (contentOffsetX >= contentWidth - screenWidth) {
        [scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:NO];
    } else if (contentOffsetX < screenWidth - scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(contentWidth - 2 * screenWidth, 0) animated:NO];
    }
    CGFloat width = scrollView.bounds.size.width;
    NSInteger page = (scrollView.contentOffset.x + width / 2) / width;
    if (page == 0) {
        self.pageControl.currentPage = 4;
    } else if (page == 6) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = page - 1;
    }
}

- (void)creatPageControl {
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor =  [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor systemBlueColor];
    self.pageControl.hidesForSinglePage = YES;
    
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pageControl];
    
    //Auto Layout布局
    [NSLayoutConstraint activateConstraints:@[
        [self.pageControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.pageControl.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-10]
    ]];
    //添加点击事件
    [self.pageControl addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)pressChange:(UIPageControl*)pageControl {
    NSInteger selectedPage = pageControl.currentPage;
    NSLog(@"当前切换到第%ld页", selectedPage + 1);
    CGFloat width = self.view.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(selectedPage * width, 0) animated:YES];
}
- (void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

- (void)nextPage {
    NSInteger page = self.pageControl.currentPage;
    if (page == self.pageControl.numberOfPages - 1) {
        page = 0;
    } else {
        page++;
    }
    CGFloat offsetX = (page + 1) * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}
/*
 当我们鼠标在抓取视图进行移动的时候，由于定时器的存在，视图依然会进行移动，因此为了方便，我们在当鼠标进行点击的时候，将计时器取消，当鼠标结束拖拽时重新创建计时器
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
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
