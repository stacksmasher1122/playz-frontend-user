import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Result of a moderation check.
class ModerationResult {
  final bool isSafe;
  ModerationResult({required this.isSafe});
}

/// Stateless service that calls the Groq API to check text for extreme profanity.
/// Fail-open: if Groq is unreachable or errors, the message is allowed through.
class ModerationService {
  static const _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  /// Check a text message for extreme profanity.
  /// Returns [ModerationResult] with isSafe = true if acceptable.
  static Future<ModerationResult> checkContent(String text) async {
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
      final model = dotenv.env['GROQ_MODEL'] ?? 'llama-3.1-8b-instant';

      if (apiKey.isEmpty) {
        debugPrint('🟡 [Moderation] No GROQ_API_KEY found, allowing message.');
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
                      'You are a content filter. Check if the user message contains extreme profanity, slurs, hate speech, or sexual content. Respond ONLY with valid JSON: {"allow":true} if acceptable, {"allow":false} if extreme. Minor slang is fine.',
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
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final content =
            body['choices']?[0]?['message']?['content']?.toString() ?? '';

        // Parse the JSON response from the model
        try {
          // Extract JSON from response (handle potential extra text)
          final jsonMatch = RegExp(r'\{[^}]*\}').firstMatch(content);
          if (jsonMatch != null) {
            final parsed = jsonDecode(jsonMatch.group(0)!);
            final allow = parsed['allow'];
            if (allow is bool) {
              return ModerationResult(isSafe: allow);
            }
          }
        } catch (_) {
          // If we can't parse the model's response, allow the message
          debugPrint('🟡 [Moderation] Could not parse model response: $content');
        }

        // Default to safe if parsing fails
        return ModerationResult(isSafe: true);
      } else {
        // API error (rate limit, server error, etc.) → fail-open
        debugPrint(
            '🟡 [Moderation] Groq API error ${response.statusCode}: ${response.body}');
        return ModerationResult(isSafe: true);
      }
    } catch (e) {
      // Network error, timeout, etc. → fail-open
      debugPrint('🟡 [Moderation] Exception during moderation check: $e');
      return ModerationResult(isSafe: true);
    }
  }
}
