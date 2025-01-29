enum Colors{blue, red, white}

enum Vechicle implements Comparable<Vechicle>{
  car(id: 1, passengers: 4, carbonPerKilometer: 100),
  bike(id: 2, passengers: 2, carbonPerKilometer: 50);
  const Vechicle({
    required this.id,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int id;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonfoorPrint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vechicle.bike;
  @override
  int compareTo(Vechicle other) {
	return index.compareTo(other.index);
  }
}

void main(List<String> args) {
  Vechicle.bike.isTwoWheeled;
}