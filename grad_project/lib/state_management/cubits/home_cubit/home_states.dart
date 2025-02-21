abstract class HomeStates {}

class InitialLayoutStates extends HomeStates {}

class LoadingState extends HomeStates {}

class LoadedState extends HomeStates {}

class ErrorState extends HomeStates {
  final String message;

  ErrorState(this.message);
}
