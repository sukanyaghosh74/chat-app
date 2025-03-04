import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubService {
  final String apiUrl = "https://api.github.com/repos/flutter/flutter/issues";

  Future<List<dynamic>> fetchGitHubIssues() async {
    var response = await http.get(Uri.parse(apiUrl));
    return jsonDecode(response.body);
  }
}
