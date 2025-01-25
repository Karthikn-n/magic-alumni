/// mixins in dart is used to create the reusable code in many class hirearchy
/// mixins have some rules to use
///  * mixins can't be instantiated because they don't have standard constructors
///  * mixins don't have extends clause so they can't be used as base class for other classes
///  * If any abstract method is defined in the mixin class it must be implemented in the class where the mixin is used
///  mixins have [on] and [implements] clause s
///  [on] * It restricts the classes that are only extends the [Animal] class can use the mixin properties
///       * is used to get super calls from other classes it will only mixed with [Animal] class
///       * if the any other want to use the [Singer] mixin they must extends the [Animal] class
mixin Singer on Animal implements Cat, Lion{

  void song(){}

  void sing(){
    print("singing");
  }
}

mixin Cricket{
  void bat();

}

class Player with Cricket{
  @override
  void bat() {
    // TODO: implement bat
  }

}

class D {}
mixin A on D implements Cat{

}

class B extends D with A {
  @override
  void catCalled() {
    // TODO: implement catCalled
  }

}

class C extends D with A{
  @override
  void catCalled() {
    // TODO: implement catCalled
  }

}

abstract interface class Cat{
  void catCalled();
}

interface class Lion{

}
class Musician extends Animal with Singer{ 
  void play(){
    print("playing");
  }
  
  @override
  void song() {
    print("img");
    super.song();
  }
  @override
  void catCalled() {
    // TODO: implement catCalled
  }
}

// class SingerDancer extends Musician with Singer, Animal{ 

// }

class Dog extends Animal{
  
  void printAnimal(){
    super.chase(Dog());
    print(super.nums);
  }
}


mixin class Animal {
  int nums =0;
  void chase(Animal animal){}
}
void main(){
  // SingerDancer().sing();
  // print(SingerDancer().nums);
}