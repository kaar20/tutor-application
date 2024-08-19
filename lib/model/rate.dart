class Rate {
  final double theRate;

  Rate({
    required this.theRate,
  });
}

double calculateRating(double oldR, double newR) {
  double theR = (oldR + newR) / 2;
  return theR;
}
