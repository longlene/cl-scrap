self.isTouchEnabled = YES;

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
        return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
        CGPoint location = [self convertTouchToNodeSpace:touch];

}
