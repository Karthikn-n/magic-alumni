// ignore_for_file: avoid_print

/// This class will help to understand the type system in dart
/// How the dart is checking the types in compile and run time
class TypeSystem {
  /// Defining the variables without any specific type will be considered as dynamic type
  /// This list is inferred as the [List<dynamic>] type
  var list = [];

  /// We can add any type of the data to the [list]
  void addData() {
    list.add(1);
    list.add("Hello");
    list.add(1.0);
    list.add(true);

  }

  /// If we pass the list to any specific type function it will throw an error
  void getList({required List<int> list}) {
    /// This will print the passed list from the functions
    print(list);
    /// This will print the list from the class level because this is helped to 
    /// get the instance members 
    print(this.list);
  }

  Object obj = Object;

  set setObject(Object obj) => this.obj = obj;

  Object get getObject => obj;

  /// Soundness -> It is the type system that ensures that the type of the value is the same as the type of the variable
  /// If the type is casting with the other type it will throw an run time error
  
}
