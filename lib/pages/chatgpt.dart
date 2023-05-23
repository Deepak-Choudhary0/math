import 'package:dart_openai/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String output = "";
Future<String> getResponse(String text) async {
  OpenAI.apiKey = dotenv.env['apiKey'] ?? 'Api_not_found';

  final completion = await OpenAI.instance.completion.create(
    model: "text-davinci-003",
    prompt: text,
    maxTokens: 50,
  );
  output = completion.choices[0].text;
  return output;
}
