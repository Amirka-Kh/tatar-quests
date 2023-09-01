import 'dart:math';

int levenshteinDistance(String a, String b) {
  int m = a.length;
  int n = b.length;
  var dist = List.generate(m + 1, (_) => List.filled(n + 1, 0, growable: false),
      growable: false);
  for (int i = 0; i <= m; i++) {
    for (int j = 0; j <= n; j++) {
      if (i == 0 && j != 0) {
        dist[i][j] = j;
      }
      if (i != 0 && j == 0) {
        dist[i][j] = i;
      }
      if (i != 0 && j != 0) {
        dist[i][j] = min(min(dist[i][j - 1] + 1, dist[i - 1][j] + 1),
            dist[i - 1][j - 1] + ((a[i - 1] == b[j - 1]) ? 0 : 1));
      }
    }
  }
  return dist[m][n];
}

bool checkAnswer(String answer, String supposition) {
  int n = answer.length;
  int k = levenshteinDistance(answer.toLowerCase(), supposition.toLowerCase());
  return k < n / 2;
}
