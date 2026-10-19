double calculerPourcentage(int nombreDeChoix, int total) {
  if (total <= 0) {
    return 0;
  }
  return (nombreDeChoix / total) * 100;
}
