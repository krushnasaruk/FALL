import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GitHubProfile {
  final String login;
  final String name;
  final String avatarUrl;
  final int publicRepos;
  final int followers;
  final String htmlUrl;

  GitHubProfile({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.publicRepos,
    required this.followers,
    required this.htmlUrl,
  });

  factory GitHubProfile.fromJson(Map<String, dynamic> json) {
    return GitHubProfile(
      login: json['login'] ?? '',
      name: json['name'] ?? json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      htmlUrl: json['html_url'] ?? '',
    );
  }
}

class GitHubRepo {
  final String name;
  final String fullName;
  final String? description;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final String htmlUrl;
  final DateTime updatedAt;

  GitHubRepo({
    required this.name,
    required this.fullName,
    this.description,
    this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
    required this.updatedAt,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'],
      language: json['language'],
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      htmlUrl: json['html_url'] ?? '',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class GitHubCommit {
  final String sha;
  final String message;
  final String authorName;
  final DateTime date;
  final String htmlUrl;

  GitHubCommit({
    required this.sha,
    required this.message,
    required this.authorName,
    required this.date,
    required this.htmlUrl,
  });

  factory GitHubCommit.fromJson(Map<String, dynamic> json) {
    final commit = json['commit'] ?? {};
    final author = commit['author'] ?? {};
    return GitHubCommit(
      sha: (json['sha'] as String?)?.substring(0, 7) ?? '',
      message: commit['message'] ?? '',
      authorName: author['name'] ?? '',
      date: DateTime.tryParse(author['date'] ?? '') ?? DateTime.now(),
      htmlUrl: json['html_url'] ?? '',
    );
  }
}

class GitHubService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _tokenKey = 'github_personal_access_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token.trim());
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<Map<String, String>> _headers() async {
    final token = await getToken();
    final headers = {
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'ProgressOS-App',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<GitHubProfile?> getAuthenticatedUser() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return null;

      final res = await http.get(
        Uri.parse('https://api.github.com/user'),
        headers: await _headers(),
      );

      if (res.statusCode == 200) {
        return GitHubProfile.fromJson(jsonDecode(res.body));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<GitHubRepo>> getUserRepositories() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.github.com/user/repos?sort=updated&per_page=15'),
        headers: await _headers(),
      );

      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.map((item) => GitHubRepo.fromJson(item)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<GitHubCommit>> getRecentCommits(String repoFullName) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.github.com/repos/$repoFullName/commits?per_page=10'),
        headers: await _headers(),
      );

      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.map((item) => GitHubCommit.fromJson(item)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

final gitHubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService();
});

final gitHubProfileProvider = FutureProvider<GitHubProfile?>((ref) async {
  final service = ref.watch(gitHubServiceProvider);
  return await service.getAuthenticatedUser();
});

