//
//  BeaconLocatorView.m
//  BleSample
//


#import "BeaconLocatorView.h"

#define POINT_HALF_WIDTH                    5.0f
#define MARGIN                              20.0f


@interface BeaconLocatorView ()

@property (nonatomic, assign) CGPoint               target;

-(void)drawPoint:(CGPoint)point withColor:(CGColorRef)color;
-(void)drawGrid;
-(void)drawBeacons;

@end


@implementation BeaconLocatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Draw the grid
    [self drawGrid];
    
    //TEST
    self.target = CGPointMake(100, 100);
    
    //Draw Beacons
    [self drawBeacons];
    
    //Draw the target if applicable
    [self drawPoint:self.target withColor:[[UIColor redColor] CGColor]];
}

-(void)drawPoint:(CGPoint)point withColor:(CGColorRef)color {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
	CGContextAddEllipseInRect(context, CGRectMake(point.x - POINT_HALF_WIDTH, point.y - POINT_HALF_WIDTH, POINT_HALF_WIDTH * 2, POINT_HALF_WIDTH *2));
    CGContextSetFillColor(context, CGColorGetComponents(color));
    CGContextFillPath(context);
}

-(void)drawGrid {
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColor(context, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextMoveToPoint(context, MARGIN, MARGIN);
    CGContextAddLineToPoint(context, width - MARGIN, MARGIN);
    CGContextAddLineToPoint(context, width - MARGIN, height - MARGIN);
    CGContextAddLineToPoint(context, MARGIN, height - MARGIN);
    CGContextAddLineToPoint(context, MARGIN, MARGIN);
    CGContextStrokePath(context);
}

-(void)drawBeacons {
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    for (Beacon * beacon in self.beaconArray) {
        [self drawPoint:CGPointMake(MARGIN + beacon.major * (width - 2 * MARGIN), MARGIN + beacon.minor * (height - 2 * MARGIN)) withColor:[[UIColor blueColor] CGColor]];
    }
}

@end
