import 'package:http/http.dart' as http;
import 'dart:convert';

String? _authToken;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Giriş sonrası alınacak token'ı ayarlamak için kullanılan metod
  void setAuthToken(String? token) {
    _authToken = token;
  }

  // POST isteği gönderen genel metod
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode(data),
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      throw Exception('Hata: ${responseBody['message'] ?? 'Bilinmeyen bir hata oluştu.'}');
    }
  }

  // GET isteği gönderen genel metod
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      },
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception('Veri alınamadı. Hata: ${response.statusCode}');
    }
  }

  // PUT isteği gönderen genel metod (Rapor durumunu güncellemek için)
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      },
      body: jsonEncode(data),
    );

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception('Güncelleme başarısız. Hata: ${response.statusCode}');
    }
  }
}
