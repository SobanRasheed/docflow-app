sealed class DocFlowException implements Exception {
  const DocFlowException([this.message = 'An unexpected error occurred.', this.cause, this.stackTrace]);
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends DocFlowException {
  const NetworkException([super.message = 'No internet connection.']);
}

class TimeoutException extends DocFlowException {
  const TimeoutException([super.message = 'The request took too long.']);
}

class AuthException extends DocFlowException {
  const AuthException([super.message = 'Invalid or expired API credentials.']);
}

class FileTooLargeException extends DocFlowException {
  FileTooLargeException(this.sizeMb, this.limitMb)
      : super('File is ${sizeMb.toStringAsFixed(1)} MB; limit is $limitMb MB.');
  final double sizeMb;
  final int limitMb;
}

class UnsupportedFormatException extends DocFlowException {
  UnsupportedFormatException(this.extension, this.toolTitle)
      : super('".$extension" is not supported for $toolTitle.');
  final String extension;
  final String toolTitle;
}

class ServerException extends DocFlowException {
  const ServerException([String? serverMessage])
      : super(serverMessage ?? 'The conversion service is unavailable.');
}

class CancelledException extends DocFlowException {
  const CancelledException([super.message = 'Conversion cancelled.']);
}

class NoFilesException extends DocFlowException {
  const NoFilesException([super.message = 'No files were selected.']);
}

class MissingConfigurationException extends DocFlowException {
  const MissingConfigurationException()
      : super('DocFlow is not configured. Add ILOVEPDF_PUBLIC_KEY.');
}
