import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/ai_message_model.dart';

class AiService {
  static final AiService _instance = AiService._internal();

  factory AiService() => _instance;

  AiService._internal();

  final _uuid = const Uuid();

  /// Returns a canned agriculture assistant response.
  Future<AiMessage> getAssistantResponse(String prompt) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final normalized = prompt.toLowerCase();
    final answer = _generateResponse(normalized);

    return AiMessage(
      id: _uuid.v4(),
      text: answer,
      role: AiMessageRole.assistant,
      createdAt: DateTime.now(),
    );
  }

  String _generateResponse(String prompt) {
    if (prompt.contains('su') || prompt.contains('suvarma') || prompt.contains('sulamaq')) {
      return 'Suvarma üçün ən yaxşı vaxt səhər tezdən və ya axşamdır. Bitkinizin növünə görə 2-3 gün arası torpağı nəmləndirmək kifayət edir.';
    }

    if (prompt.contains('pestisid') || prompt.contains('zərərverici') || prompt.contains('zərərlilər')) {
      return 'Zərərvericilərə qarşı təbii mübarizə daha uzunmüddətli nəticə verir. Hər zaman bitkiyə uyğun pestisid seçin və istifadə təlimatlarına riayət edin.';
    }

    if (prompt.contains('torpaq') || prompt.contains('gübrə') || prompt.contains('ph')) {
      return 'Torpağın vəziyyətini yoxlamaq üçün pH testi aparın. Torpaq qələvi isə kükürd, turşu isə əhəng əlavə etmək kömək edə bilər.';
    }

    if (prompt.contains('havan') || prompt.contains('hava') || prompt.contains('proqnoz')) {
      return 'Hava proqnozunu nəzərə alaraq yağışdan əvvəl suvarmaya ehtiyac yoxdur. Əgər duman və rütubət yüksəkdirsə, xəstəlik riski arta bilər.';
    }

    return 'AQRO-BOT: Bu mövzuda daha ətraflı məlumat verə bilərsinizmi? Məsələn, hansı bitki, məhsul və ya problem barədə danışmaq istəyirsiniz?';
  }
}
