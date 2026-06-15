/// Time class for user greetings
class Time {
  static String getSystemGreeting() {
    final int hour = DateTime.now().hour;

    if (hour >= 4 && hour < 12) {
      return 'Good Morning🌄';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon☀️';
    } else if (hour >= 17 && hour < 22) {
      return 'Good Evening🌆';
    } else {
      return 'Good Night🌚';
    }
  }
}
