
// ignore_for_file: avoid_print

/// Soundness
/// The static type of the object is same ad the runtime type of the object
/// if this mismatch it will raise an error
/// for example if the object is assigned as the String and it is used as the in it will throw error
/// Object a = "String";
class Animal{
  
  Animal get parent => this;
  
  Object a = "String";

  void lengthOfString() {
    /// This will throw an error becase the object is uses the String property
    /// uncomment the below line to show the error
    /// print(a.length);
    /// To avoid the above error we can cast them as String to use the properties of the String
    /// print((a as String).length);
    /// This will thrown an run time error becuase the static type of the [a] is String and it is casted as int
    print(a as int);
  }

  void chase(Animal animal){}
}

class HoneyBadger extends Animal{
  /// Sound return type of the parent is same as the child
  /// This return type is either the Same type [Animal] as overridden method or the subtype [HoneyBadger], [Lion] of the Parent type
  /// Here it is the Lion() which is the subtype of the Animal so it can be returned
  /// @override
  /// Lion get parent => Lion();
  /// So the above override methos will throw exception in the sub Type [HoneyBadger] class if they return the 
  /// parent type [HoneyBadger] instead of the [Lion]
  /// Because the [HoneyBadger] is not the same type as the [Lion] but the [Lion] is the subtype of the [Animal], [HoneyBadger]
  /// If any subtype overrides this method the return type must be
  /// [Animal], [HoneyBadger] or the subtype of the [Animal], [HoneyBadger]
  @override
  Animal get parent => Lion();

  @override
  void chase(Animal animal){}
}

class Lion extends HoneyBadger{
  @override
  HoneyBadger get parent => this;

  /// This is sound parameter type when overriding the method
  /// The parameter type must be same or permissive than the parameter type 
  /// Narrowing the parameter type will throw a compile time error
  /// @override
  /// void chase(HoneyBadger animal){}
  @override
  void chase(Animal animal){}
  
}

void main(){
  /// This will call the Animal class chase method because in dart the method dispatch happens in the compile time
  /// Method dispatch -> means when the method is executed the method is called based on the type of the object
  /// If the method dispatch is happens compile time it will call the Refernce variable type method
  /// If the method dispatch is happens in the run time it will call the object type method
  /// In this case the static type of [lion] is [Animal] so it will call the [Animal] class chase method
  Animal lion = Lion();
  /// This will call the [Animal] class chase method because the method dispatch is happens in the compile time
  (lion).chase(HoneyBadger());
  /// We can explicitly call the [Lion] class call method by casting the object to the [Lion] type
  /// This will call the [Lion] class chase method because at the 
  (lion as Lion).chase(HoneyBadger());
  /// Thiw will call the [Lion] class chase method because the method dispatch is happens in the run time
  Lion lion1 = Lion();
  lion1.chase(Animal());
}