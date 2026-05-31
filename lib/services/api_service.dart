import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static const String baseUrl = 'http://192.168.1.4:5000/api';

  static const String _tokenKey = 'jwt_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  // ===== AUTH =====

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, data['token']);
        await prefs.setString(_userEmailKey, email);
        if (data['user'] != null) {
          await prefs.setString(_userNameKey, data['user']['firstName'] ?? '');
        }
        return {'success': true, 'token': data['token']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> uploadProfilePicture({
    required String imageBase64,
    required String mimeType,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'profilePicture': 'data:$mimeType;base64,$imageBase64',
        }),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data['success'] == true
          ? {'success': true, 'profilePicture': data['user']?['profilePicture']}
          : {'success': false, 'message': data['message'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<String?> getProfilePicture() async {
    try {
      final result = await getUserProfile();
      if (result['success'] == true) {
        return result['user']['profilePicture'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': fullName,
          'email': email,
          'password': password,
        }),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {'success': true, 'message': 'Account created successfully'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Signup failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'user': data['user']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    int? age,
    String? gender,
    String? bloodType,
    Map<String, dynamic>? medical,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final body = <String, dynamic>{};
      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (phone != null) body['phone'] = phone;
      if (age != null) body['age'] = age;
      if (gender != null) body['gender'] = gender;
      if (bloodType != null) body['bloodType'] = bloodType;
      if (medical != null) body['medical'] = medical;

      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'user': data['user']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Update failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ===== FORGOT PASSWORD =====

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data['success'] == true
          ? {'success': true, 'message': data['message']}
          : {'success': false, 'message': data['message'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data['success'] == true
          ? {'success': true, 'resetToken': data['resetToken']}
          : {'success': false, 'message': data['message'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'resetToken': resetToken,
          'newPassword': newPassword,
        }),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data['success'] == true
          ? {'success': true, 'message': data['message']}
          : {'success': false, 'message': data['message'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ===== TOKEN MANAGEMENT =====

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }

  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_userEmailKey),
      'name': prefs.getString(_userNameKey),
    };
  }

  // ===== CHAT ENDPOINTS =====

  static Future<Map<String, dynamic>> getChats() async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.get(
        Uri.parse('$baseUrl/chats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'chats': data['chats'],
          'total': data['total']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get chats'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> renameChat({
    required String chatId,
    required String newTitle,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      final response = await http.put(
        Uri.parse('$baseUrl/chats/$chatId/rename'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'title': newTitle}),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data['success'] == true
          ? {'success': true}
          : {'success': false, 'message': data['message'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> createChat(
      {String title = 'New Chat'}) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/chats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'title': title}),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        return {'success': true, 'chat': data['chat']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create chat'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String content,
    String? fileBase64,
    String? fileType,
    String? fileName,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final body = <String, dynamic>{
        'role': 'user',
        'content': content,
      };
      if (fileBase64 != null) body['fileBase64'] = fileBase64;
      if (fileType != null) body['fileType'] = fileType;
      if (fileName != null) body['fileName'] = fileName;

      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'aiResponse': data['aiResponse'],
          'chat': data['chat'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteChat(String chatId) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.delete(
        Uri.parse('$baseUrl/chats/$chatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete chat'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getChatById(String chatId) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.get(
        Uri.parse('$baseUrl/chats/$chatId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'chat': data['chat']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ===== DRUG INTERACTION =====

  static Future<Map<String, dynamic>> checkDrugInteractions({
    required List<String> medications,
    String language = 'en',
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/drugs/check'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'medications': medications, 'language': language}),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'interactions': data['interactions'],
          'summary': data['summary'],
          'warnings': data['warnings'],
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Check failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ===== LAB TEST =====

  static Future<Map<String, dynamic>> analyzeLabReport({
    String? imageBase64,
    String? labText,
    String language = 'en',
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/lab/analyze'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (imageBase64 != null) 'imageBase64': imageBase64,
          if (labText != null) 'labText': labText,
          'language': language,
        }),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'extractedText': data['extractedText'],
          'analysis': data['analysis'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Analysis failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ===== RESEARCH ASSISTANT =====

  static Future<Map<String, dynamic>> uploadResearchPaper({
    required String paperTitle,
    List<String>? authors,
    String? journal,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/research'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'paperTitle': paperTitle,
          if (authors != null) 'authors': authors,
          if (journal != null) 'journal': journal,
        }),
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['success'] == true) {
        return {'success': true, 'chat': data['chat']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Upload failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> summarizePaper(String paperId) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/research/$paperId/summarize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'summary': data['summary']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Summarization failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> generateQA(String paperId) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/research/$paperId/qa'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'qaPairs': data['qaPairs']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Q&A generation failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> translatePaper({
    required String paperId,
    required String targetLanguage,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/research/$paperId/translate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'targetLanguage': targetLanguage}),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'translatedText': data['translatedText'],
          'originalText': data['originalText'],
          'targetLanguage': data['targetLanguage'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Translation failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> sendResearchMessage({
    required String paperId,
    required String content,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.post(
        Uri.parse('$baseUrl/research/$paperId/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'content': content}),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'aiResponse': data['aiResponse']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send message'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // ===== RESEARCH EXTRAS =====

  static Future<Map<String, dynamic>> uploadResearchFile({
    required String paperId,
    required String fileBase64,
    required String fileType,
    required String fileName,
  }) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      // نحول الـ base64 لـ bytes ونبعتها كـ multipart
      final uri = Uri.parse('$baseUrl/research/$paperId/upload');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      final bytes = base64Decode(fileBase64);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      ));

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'extractedText': data['extractedText'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Upload failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getOcrText(String paperId) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      final response = await http.get(
        Uri.parse('$baseUrl/research/$paperId/ocr'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'extractedText': data['extractedText']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> summarizePaperWithLanguage(String paperId,
      String language) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      final response = await http.post(
        Uri.parse('$baseUrl/research/$paperId/summarize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'language': language}),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'summary': data['summary']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> generateQAWithLanguage(String paperId,
      String language) async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      final response = await http.post(
        Uri.parse('$baseUrl/research/$paperId/qa'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'language': language}),
      ).timeout(Duration(seconds: 60));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'qaPairs': data['qaPairs']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getResearchPapers() async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'chats': []};

      final response = await http.get(
        Uri.parse('$baseUrl/research'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'chats': data['chats'] ?? []};
      }
      return {'success': false, 'chats': []};
    } catch (e) {
      return {'success': false, 'chats': []};
    }
  }

  // ===== ACTIVITIES =====

  static Future<Map<String, dynamic>> getActivities() async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token found'};

      final response = await http.get(
        Uri.parse('$baseUrl/activities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'activities': data['activities'],
          'total': data['total']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get activities'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}