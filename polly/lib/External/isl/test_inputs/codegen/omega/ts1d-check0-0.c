for (int c1 = 0; c1 < N; c1 += 1)
  s0(1, c1, 1, 0, 0);
for (int c1 = 0; c1 <= floord(T - 1, 500); c1 += 1)
  for (int c2 = 1000 * c1; c2 <= min(N + 2 * T - 3, N + 1000 * c1 + 997); c2 += 1) {
    for (int c3 = max(0, -((N + c2) % 2) - N - 1000 * c1 + c2 + 2); c3 <= min(min(998, 2 * T - 1000 * c1 - 2), -1000 * c1 + c2 - 2); c3 += 2) {
      s1(2, 1000 * c1 + c3, 0, -1000 * c1 + c2 - c3, 1);
      s2(2, 1000 * c1 + c3 + 1, 0, -1000 * c1 + c2 - c3 - 1, 1);
    }
    if (2 * T >= c2 + 1 && 1000 * c1 + 999 >= c2)
      s1(2, ((c2 + 1) % 2) + c2 - 1, 0, -((c2 + 1) % 2) + 1, 1);
  }
