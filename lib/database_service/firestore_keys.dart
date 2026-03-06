abstract class FirestoreKeys {
  // Collections
  static const String userBikeSetup = 'UserBikeSetup';
  static const String bikes = 'Bikes';
  static const String setupList = 'SetupList';
  static const String todoList = 'ToDoList';
  static const String myList = 'MyList';

  // User document fields
  static const String defaultBike = 'default_bike';

  // Bike document fields
  static const String bikeName = 'bike_name';
  static const String bikeType = 'bike_type';
  static const String defaultSetup = 'defaultSetup';

  // Setup document fields
  static const String setupName = 'setup_name';

  // Todo document fields
  static const String taskName = 'task_name';
  static const String taskDescription = 'task_description';
  static const String part = 'Part';
  static const String done = 'done';
  static const String created = 'created';
}
