
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


@end

@implementation RATableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.customTitleLabel = [FitLabel new];
    [self addSubview:self.customTitleLabel];
    
    self.collapseButton = [[UIButton alloc] initWithFrame:CGRectMake(Margin, 0, 20, 20)];
    //    [self.collapseButton setTitle:@"<<" forState:UIControlStateNormal];
    [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_up_icon"] forState:UIControlStateNormal];
    [self.collapseButton addTarget:self action:@selector(collapseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    self.collapseButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.collapseButton];
    //    [self.collapseButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    //    [self.collapseButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:Margin];
    //    [self.collapseButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.customTitleLabel withOffset:-Margin/2.];
    
    return self;
}




- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.additionButtonHidden = NO;
}


- (void)setupWithCourseDetails:(CourseDetails *)cd level:(NSInteger)level expanded:(BOOL)expanded
{
    if([cd isDirectory]) {
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
        self.collapseButton.hidden = YES;
        [self.collapseButton setBackgroundImage:[UIImage imageNamed:@"file_item_up_icon"] forState:UIControlStateNormal];
    }
    
    self.customTitleLabel.text = cd.course.title;
    [self.customTitleLabel vcenterInParent];
    
    CGFloat left = 21 + 20 * level;
    if(![cd isDirectory]) {
        left -= 20;
    }
    
    CGRect titleFrame = self.customTitleLabel.frame;
    titleFrame.origin.x = left;
    titleFrame.size.width = [UIView screenWidth] - left - Margin*2;
    self.customTitleLabel.frame = titleFrame;
    
    [self.collapseButton vcenterInParent];
    self.collapseButton.x = self.customTitleLabel.left - self.collapseButton.width;
    
    CGRect detailsFrame = self.detailedLabel.frame;
    detailsFrame.origin.x = left;
    self.detailedLabel.frame = detailsFrame;
    [self.detailedLabel vcenterInParent];
}


#pragma mark - Properties

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden
{
    [self setAdditionButtonHidden:additionButtonHidden animated:NO];
}

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden animated:(BOOL)animated
{
    _additionButtonHidden = additionButtonHidden;
    [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
        self.additionButton.hidden = additionButtonHidden;
    }];
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

@end
