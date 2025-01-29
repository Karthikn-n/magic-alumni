// ignore_for_file: avoid_print

/// Records are same as the other collection types
/// It takes the aggerate of the data types and it is stores as the single data types
class Records{
  /// This is the common syntax of the records
  (int, int) nums = (1, 49);

  /// We can also pass the records using named parameters it can be easy to access
  /// It can be more readable than above one 
  ({int a, int b}) nums2 = (a:1, b:45);

  /// We can also pass the records to the function parameters and it can be return type
  /// uncomment the below line show the instance member can't be accessed in before intialization
  /// (int, int) result = getAnswer((a: 3,b: 4));
  /// So initialze the instance member before accessing it use it inside the constructor
  /// late will help as to initialize the result later. If this is access before initialization it will throw an run time error
  late (int, int) result;

  /// Define the constructor and call the function to get the results
  Records(){
    result = getAnswer((a: 3, b: 2));
  }


  /// If this function is called the in the global state it can't be accessed so call them inside the constructor
  /// like this Records() { (int, int) result = getAnswer((a: 3,b: 4)); } this will wors
  /// It return the record type from answer and
  /// It takes the input as the record type and perform the operation using it
  (int, int) getAnswer(({int a, int b}) nums){
    return (nums.a + nums.b, nums.a - nums.b);
  }

  /// We can access the elements from the records using $index 
  void printValues(){
    print("${nums.$1}"); // Prints the 1
    print(nums2.a); // Prints the 1
  }
}

void main(){
  Records record = Records();
  print(record.nums.$1); // This will print the answer of the (3+4)
}