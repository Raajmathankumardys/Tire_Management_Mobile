abstract class BaseState<T> {}

class InitialState<T> extends BaseState<T> {}

class LoadingState<T> extends BaseState<T> {}

class LoadedState<T> extends BaseState<T> {
  final List<T> items;
  LoadedState(this.items);
}

class ErrorState<T> extends BaseState<T> {
  final String message;
  ErrorState(this.message);
}

class AddedState<T> extends BaseState<T> {
  final String message;
  AddedState(this.message);
}

class UpdatedState<T, int> extends BaseState<T> {
  final String message;
  UpdatedState(this.message);
}

class DeletedState<T> extends BaseState<T> {
  final String message;
  DeletedState(this.message);
}
