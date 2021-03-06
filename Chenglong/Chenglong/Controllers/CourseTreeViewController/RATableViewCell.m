
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RATableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RATableViewCell ()

@property (strong, nonatomic) FitLabel *customTitleLabel;
@property (strong, nonatomic) UIButton *collapseButton;
@property (strong, nonatomic) UIButton *btnSelect;
@property (strong, nonatomic) UIButton *btnPlay;
@property (strong, nonatomic) UIButton *btnPlayList;

@end

@implementation RATableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.customTitleLabel = [FitLabel new];
    [self addSubview:self.customTitleLabel];
    
    self.collapseButton = [[UIButton alloc] initWithFrame:CGRectMake(Margin, 0, 20, 20)];
    self.collapseButton.userInteractionEnabled = NO;
    //    [self.collapseButton setTitle:@"<<" forState:UIControlStateNormal];
    [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_up_icon"] forState:UIControlStateNormal];
    [self.collapseButton addTarget:self action:@selector(collapseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    self.collapseButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.collapseButton];
    //    [self.collapseButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    //    [self.collapseButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:Margin];
    //    [self.collapseButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.customTitleLabel withOffset:-Margin/2.];
    
    self.btnPlay = [UIButton new];
    [self.btnPlay setImage:[UIImage imageNamed:@"ic_play_arrow"] forState:UIControlStateNormal];
    [self addSubview:self.btnPlay];
    [self.btnPlay autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [self.btnPlay autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:1];
    [self.btnPlay autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.btnPlay addTarget:self action:@selector(playCourse:)];
    self.btnPlay.hidden = YES;
    
    self.btnSelect = [UIButton new];
    [self.btnSelect setImage:[UIImage imageNamed:@"ic_check_gray"] forState:UIControlStateNormal];
    [self addSubview:self.btnSelect];
    [self.btnSelect autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [self.btnSelect autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.btnSelect autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.btnSelect addTarget:self action:@selector(selectCourse:)];
    self.btnSelect.hidden = YES; // disable it for now
    
    self.btnPlayList = [UIButton new];
    [self.btnPlayList setImage:[UIImage imageNamed:@"ic_playlist_play"] forState:UIControlStateNormal];
    [self addSubview:self.btnPlayList];
    [self.btnPlayList autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [self.btnPlayList autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.btnPlayList autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.btnPlay];
    [self.btnPlayList addTarget:self action:@selector(addToPlayList:)];
    self.btnPlayList.hidden = YES;
    
    return self;
}

-(void)addToPlayList:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourseAppend object:self.courseDetails userInfo:nil];
}

-(void)playCourse:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPlayCourse object:self.courseDetails userInfo:nil];
}

-(void)selectCourse:(id)sender
{
    if(self.courseDetails.course.isDir.integerValue && self.courseDetails.items.count==0)
        return;
    
    if(self.courseDetails.selected) {
        self.courseDetails.selected = NO;
        [self.btnSelect setImage:[UIImage imageNamed:@"ic_check_gray"] forState:UIControlStateNormal];
    } else {
        self.courseDetails.selected = YES;
        [self.btnSelect setImage:[UIImage imageNamed:@"ic_check"] forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationCourseSelected object:self.courseDetails];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.additionButtonHidden = NO;
}


- (void)setupWithCourseDetails:(CourseDetails *)cd level:(NSInteger)level expanded:(BOOL)expanded
{
    self.courseDetails = cd;
    if([cd isDirectory]) {
//        self.btnPlay.hidden = YES;
        self.collapseButton.hidden = NO;
        if([cd hasChildren]) {
            if(expanded) {
                [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_down_icon"] forState:UIControlStateNormal];
            }
            else {
                [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_right_icon"] forState:UIControlStateNormal];
            }
        }
        else {
            [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_disabled_right_icon"] forState:UIControlStateNormal];
        }
    }
    else {
//        self.btnPlay.hidden = NO;
        self.collapseButton.hidden = YES;
        [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_up_icon"] forState:UIControlStateNormal];
    }
    
    self.customTitleLabel.text = cd.course.title;
    [self.customTitleLabel vcenterInParent];
    
    CGFloat left = 45 + 20 * level;
    if(self.btnSelect.hidden)
        left -= 25;
    if(![cd isDirectory]) {
        left -= 20;
    }
    
    CGRect titleFrame = self.customTitleLabel.frame;
    titleFrame.origin.x = left;
    titleFrame.size.width = [UIView screenWidth] - left - Margin*2;
    self.customTitleLabel.frame = titleFrame;
    
    [self.collapseButton vcenterInParent];
    self.collapseButton.x = self.customTitleLabel.left - self.collapseButton.width - 3;
    
    [self.btnSelect setImage:[UIImage imageNamed:cd.selected?@"ic_check":@"ic_check_gray"] forState:UIControlStateNormal];
}


#pragma mark - Properties

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden
{
    [self setAdditionButtonHidden:additionButtonHidden animated:NO];
}

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden animated:(BOOL)animated
{
    _additionButtonHidden = additionButtonHidden;
}


#pragma mark - Actions

- (IBAction)additionButtonTapped:(id)sender
{
    if (self.additionButtonTapAction) {
        self.additionButtonTapAction(sender);
    }
}

- (void)collapseButtonTapped:(id)sender
{
    if (self.collapseButtonTapAction) {
        self.collapseButtonTapAction(sender);
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
