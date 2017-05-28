//
//  ViewController.m
//  JXDrawCollectionView
//
//  Created by mac on 17/4/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "JXDrawCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
/**抖动的等级(1.0f~10.0f)，默认4*/
@property (nonatomic, assign) CGFloat shakeLevel;
@end

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define angelToRandian(x)  ((x)/180.0*M_PI)

@implementation ViewController

#pragma mark - lazy loading
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        _flowLayout.itemSize = CGSizeMake(Screen_Width * 0.5 -10, Screen_Width * 0.5 - 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, Screen_Height - 20) collectionViewLayout:_flowLayout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
        _collectionView.delegate = self;
        [_collectionView registerClass:[JXDrawCell class] forCellWithReuseIdentifier:@"cellIdentiifer"];
    }
    return _collectionView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shakeLevel = 4.0;
    [self.view addSubview:self.collectionView];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.collectionView addGestureRecognizer:_longPress];
    
    self.array = [NSMutableArray arrayWithObjects:@"红包", @"转账", @"手机充值", @"芝麻信用",
                  @"天猫", @"生活缴费", @"蚂蚁呗", @"世界那么大",
                  @"余额宝", @"安全快付", @"蚂蚁聚宝", @"哈哈",@"红包1", @"转账1", @"手机充值1", @"芝麻信用1",
                  @"天猫1", @"生活缴费1", @"蚂蚁呗1", @"世界那么大1",
                  @"余额宝1", @"安全快付1", @"蚂蚁聚宝1", @"哈哈1",  nil];
}



#pragma mark - Actions
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                
                [_collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                
                [self shakeAllCell];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            [self.collectionView endInteractiveMovement];
            [self stopShakeAllCell];
            break;
        }
        default:{
            
            [self.collectionView cancelInteractiveMovement];
            [self stopShakeAllCell];
        }
            break;
    }
}

#pragma mark - 移动方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    // 1.调整数据源数据
    [self.array exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];

    // 2.刷新
    [self.collectionView reloadData];
}

#pragma mark - 动画
#pragma mark -  shakeAllCell
- (void)shakeAllCell{
    CAKeyframeAnimation* anim =[CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angelToRandian(-_shakeLevel)),@(angelToRandian(_shakeLevel)),@(angelToRandian(-_shakeLevel))];
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.2;
    NSArray *cells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        /**如果加了shake动画就不用再加了*/
        if (![cell.layer animationForKey:@"shake"]) {
            [cell.layer addAnimation:anim forKey:@"shake"];
        }
    }
    
}

- (void)stopShakeAllCell{
    NSArray *cells = [self.collectionView visibleCells];
    for (UICollectionViewCell *cell in cells) {
        [cell.layer removeAllAnimations];
    }
    
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JXDrawCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentiifer" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.label.text = self.array[indexPath.row];
    return cell;
}
@end
