enum Colors{blue, red, white}

enum Vechicle implements Comparable<Vechicle>{
  car, bike;
  const Vechicle({
    required this.id,
    required this.passengers,
    required this.carbonkilometers,
  });

  final int id;
  final int passengers;
  final int carbonkilometers;
  @override
  int compareTo(Vechicle other) {
	return index.compareTo(other.index);
  }
}