long gcd(long x, long y)
{
        if (x < 0)
                x = -x;
        if (y < 0)
                y = -y;

        if (x == 0)
                return y;
        if (y == 0)
                return x;

        while (x > 0) {
                long t = x;
                x = y % x;
                y = t;
        }
        return y;
}

