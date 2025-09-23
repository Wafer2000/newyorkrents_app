
int gridColumnsForWidth(double width) {
  if (width < 360) return 2;
  if (width < 750) return 2;
  if (width < 990) return 3;
  return 4;
}

double gridChildAspectRatio(double width, double horizontalPadding, double gutter, int columns) {
  final itemWidth = (width - horizontalPadding * 2 - gutter * (columns - 1)) / columns;
  final itemHeight = itemWidth + 72;
  return itemWidth / itemHeight;
}
