String getTimeString() {
  DateTime dt = DateTime.now();
  return "${dt.year}/${dt.month}/${dt.day}-${dt.hour < 10 ? '0' : ''}${dt.hour}:${dt.minute < 10 ? '0' : ''}${dt.minute}:${dt.second < 10 ? '0' : ''}${dt.second}";
}

Map sortMapByKeys(Map map) {
  return Map.fromEntries(
      map.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
}
