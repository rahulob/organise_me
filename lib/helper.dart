String getTimeString() {
  DateTime dt = DateTime.now();
  return "${dt.year}/${dt.month}/${dt.day}-${dt.hour}:${dt.minute}:${dt.second}";
}
