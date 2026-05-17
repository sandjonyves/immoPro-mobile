import 'domain_error.dart';

class ValidationError extends DomainError {
  const ValidationError(super.message);
}
