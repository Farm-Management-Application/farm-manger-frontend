// lib/api/headers.dart
Map<String, String> getCommonHeaders({bool isFormData = false}) {
  return {
    'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
    'Accept': 'application/json',
  };
}