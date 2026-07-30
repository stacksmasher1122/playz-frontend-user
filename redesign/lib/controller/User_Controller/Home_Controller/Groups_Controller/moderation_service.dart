import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Result of a moderation check.
class ModerationResult {
  final bool isSafe;
  final String? reason;
  ModerationResult({required this.isSafe, this.reason});
}

/// Service that checks text messages for curse words and profanity.
class ModerationService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  /// List of curse words, profanity, and offensive slurs to filter out instantly offline
  static final List<String> _profanityList = [
    'fuck', 'fucking', 'fucked', 'fucker', 'shit', 'shitting', 'shitty',
    'bitch', 'bitches', 'asshole', 'bastard', 'cunt', 'dick', 'pussy',
    'whore', 'slut', 'nigger', 'faggot', 'chink', 'retard', 'motherfucker',
    'mcbc', 'bc', 'mc', 'chutiya', 'madarchod', 'bhenchod', 'gaand', 'gand',
    'bhosdike', 'bhosdika', 'bhosda', 'lodu', 'lauda', 'loda', 'harami',
    'kutta', 'kutti', 'kamina', 'randi'
  ];

  /// Check if text contains any curse words or profanity (instant offline check)
  static bool containsCurseWords(String text) {
    final lowerText = text.toLowerCase();
    for (final word in _profanityList) {
      final pattern = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
      if (pattern.hasMatch(lowerText)) {
        return true;
      }
    }
    return false;
  }

  /// Check a text message for curse words and extreme profanity.
  /// Combines instant pattern matching and Groq AI moderation.
  static Future<ModerationResult> checkContent(String text) async {
    // 1) Instant local curse word check
    if (containsCurseWords(text)) {
      debugPrint('🔴 [Moderation] Instant profanity detection triggered.');
      return ModerationResult(
        isSafe: false,
        reason: 'Message contains curse words or offensive language.',
      );
    }

    // 2) Groq AI check for severe profanity/hate speech if API key is set
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
      final model = dotenv.env['GROQ_MODEL'] ?? 'llama-3.1-8b-instant';

      if (apiKey.isEmpty) {
        return ModerationResult(isSafe: true);
      }

      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are a content filter. Check if the user message contains curse words, extreme profanity, slurs, hate speech, or sexual content. Respond ONLY with valid JSON: {"allow":true} if acceptable, {"allow":false} if inappropriate.',
                },
                {
                  'role': 'user',
                  'content': text,
                },
              ],
              'temperature': 0,
              'max_tokens': 10,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final content =
            body['choices']?[0]?['message']?['content']?.toString() ?? '';

        final jsonMatch = RegExp(r'\{[^}]*\}').firstMatch(content);
        if (jsonMatch != null) {
          final parsed = jsonDecode(jsonMatch.group(0)!);
          final allow = parsed['allow'];
          if (allow is bool) {
            return ModerationResult(
              isSafe: allow,
              reason: allow ? null : 'Violates community guidelines.',
            );
          }
        }
        return ModerationResult(isSafe: true);
      } else {
        return ModerationResult(isSafe: true);
      }
    } catch (e) {
      debugPrint('🟡 [Moderation] Exception during Groq moderation: $e');
      return ModerationResult(isSafe: true);
    }
  }
}
