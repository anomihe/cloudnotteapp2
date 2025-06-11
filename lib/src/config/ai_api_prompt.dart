import 'package:dio/dio.dart';

// const String baseUrl =
//     "https://agent-8f919ffc9392b960736f-hzkl4.ondigitalocean.app";
const String baseUrl =
    "https://r33r7k3qjmh7dowqrrny7ugn.agents.do-ai.run/";
// const String apiKey = "c3y5bVMVoC6efU89aYljcM7ciLjKmNUx";
const String apiKey = "KJ6Zsz4R-SF32z_bRP0WdjS8hveDx_V6";
final Dio dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey",
  },
));

enum MessageRole { user, assistant, system, developer }

class Message {
  final MessageRole role;
  final String content;

  Message({required this.role, required this.content});

  String get roleString => role.toString().split('.').last;

  Map<String, dynamic> toJson() {
    return {
      "role": roleString,
      "content": content,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: MessageRole.values.firstWhere(
        (e) => e.toString().split('.').last == json["role"],
        orElse: () => MessageRole.user,
      ),
      content: json["content"],
    );
  }
}

class ApiRequest {
  final List<Message> messages;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final int? maxCompletionTokens;
  final bool? stream;
  final int? k;
  final double? frequencyPenalty;
  final double? presencePenalty;
  final dynamic stop;
  final String? instructionOverride;
  final bool? includeFunctionsInfo;
  final bool? includeRetrievalInfo;
  final bool? includeGuardrailsInfo;

  ApiRequest({
    required this.messages,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.maxCompletionTokens,
    this.stream,
    this.k,
    this.frequencyPenalty,
    this.presencePenalty,
    this.stop,
    this.instructionOverride,
    this.includeFunctionsInfo,
    this.includeRetrievalInfo,
    this.includeGuardrailsInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      "messages": messages.map((m) => m.toJson()).toList(),
      "temperature": temperature,
      "top_p": topP,
      "max_tokens": maxTokens,
      "max_completion_tokens": maxCompletionTokens,
      "stream": stream,
      "k": k,
      "frequency_penalty": frequencyPenalty,
      "presence_penalty": presencePenalty,
      "stop": stop,
      "instruction_override": instructionOverride,
      "include_functions_info": includeFunctionsInfo,
      "include_retrieval_info": includeRetrievalInfo,
      "include_guardrails_info": includeGuardrailsInfo,
    };
  }
}

/// API Response Model
class ApiResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<Choice> choices;
  final Guardrails? guardrails; // Made optional
  final Functions? functions; // Made optional
  final Retrieval? retrieval; // Made optional

  ApiResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    this.guardrails,
    this.functions,
    this.retrieval,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      id: json["id"] as String? ?? "unknown_id",
      object: json["object"] as String? ?? "unknown_object",
      created: json["created"] as int? ?? 0,
      model: json["model"] as String? ?? "unknown_model",
      choices: (json["choices"] as List<dynamic>?)
              ?.map((c) => Choice.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      guardrails: json["guardrails"] != null
          ? Guardrails.fromJson(json["guardrails"] as Map<String, dynamic>)
          : null,
      functions: json["functions"] != null
          ? Functions.fromJson(json["functions"] as Map<String, dynamic>)
          : null,
      retrieval: json["retrieval"] != null
          ? Retrieval.fromJson(json["retrieval"] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Choice Model
class Choice {
  final Message message;
  final int index;
  final String? finishReason;

  Choice({required this.message, required this.index, this.finishReason});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      message: Message.fromJson(json["message"]),
      index: json["index"],
      finishReason: json["finish_reason"],
    );
  }
}

/// Guardrails Model
class Guardrails {
  final List<TriggeredGuardrail> triggeredGuardrails;

  Guardrails({required this.triggeredGuardrails});

  factory Guardrails.fromJson(Map<String, dynamic> json) {
    return Guardrails(
      triggeredGuardrails: (json["triggered_guardrails"] as List)
          .map((g) => TriggeredGuardrail.fromJson(g))
          .toList(),
    );
  }
}

class TriggeredGuardrail {
  final String message;
  final String ruleName;

  TriggeredGuardrail({required this.message, required this.ruleName});

  factory TriggeredGuardrail.fromJson(Map<String, dynamic> json) {
    return TriggeredGuardrail(
      message: json["message"],
      ruleName: json["rule_name"],
    );
  }
}

/// Functions Model
class Functions {
  final List<String> calledFunctions;

  Functions({required this.calledFunctions});

  factory Functions.fromJson(Map<String, dynamic> json) {
    return Functions(
      calledFunctions: List<String>.from(json["called_functions"]),
    );
  }
}

/// Retrieval Model
class Retrieval {
  final List<RetrievedData> retrievedData;

  Retrieval({required this.retrievedData});

  factory Retrieval.fromJson(Map<String, dynamic> json) {
    return Retrieval(
      retrievedData: (json["retrieved_data"] as List)
          .map((r) => RetrievedData.fromJson(r))
          .toList(),
    );
  }
}

class RetrievedData {
  final String id;
  final String index;
  final double score;

  RetrievedData({required this.id, required this.index, required this.score});

  factory RetrievedData.fromJson(Map<String, dynamic> json) {
    return RetrievedData(
      id: json["id"],
      index: json["index"],
      score: json["score"].toDouble(),
    );
  }
}
