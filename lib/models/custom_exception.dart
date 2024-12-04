class CustomException implements Exception {
  final String? message;

  const CustomException({this.message = 'Что-то пошло не так!'});

  @override
  String toString() => 'CustomException { message: $message }';
}