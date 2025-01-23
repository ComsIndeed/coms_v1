String getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 3 && hour <= 10) {
    return "Goodmorning";
  } else if (hour >= 11 && hour <= 15) {
    return "Good day";
  } else if (hour >= 16 && hour <= 18) {
    return "Goodafternoon";
  } else if (hour >= 19 || hour <= 2) {
    return "Goodevening";
  } else {
    return "Hello";
  }
}
