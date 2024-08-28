// To parse this JSON data, do
//
//     final FeedbackModel = FeedbackModelFromJson(jsonString);

import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) =>
    FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
  List<FeedbackDatum> data;

  FeedbackModel({
    required this.data,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        data: List<FeedbackDatum>.from(
            json["data"].map((x) => FeedbackDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FeedbackDatum {
  int id;
  String questions;
  String answerType;
  String inputType;
  String createdAt;
  String updatedAt;
  List<Option> options;

  FeedbackDatum({
    required this.id,
    required this.questions,
    required this.inputType,
    required this.answerType,
    required this.createdAt,
    required this.updatedAt,
    required this.options,
  });

  factory FeedbackDatum.fromJson(Map<String, dynamic> json) => FeedbackDatum(
        id: (["", null, false, 0].contains(json["id"])) ? 0 : json["id"],
        questions: (["", null, false, 0].contains(json["questions"]))
            ? ""
            : json["questions"],
        answerType: (["", null, false, 0].contains(json["answer_type"]))
            ? ""
            : json["answer_type"],
        inputType: (["", null, false, 0].contains(json["input_type"]))
            ? ""
            : json["input_type"],
        createdAt: (["", null, false, 0].contains(json["created_at"]))
            ? ""
            : json["created_at"],
        updatedAt: (["", null, false, 0].contains(json["updated_at"]))
            ? ""
            : json["updated_at"],
        options: (json["options"] == [] || json["options"] == null)
            ? []
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "input_type": inputType,
        "questions": questions,
        "answer_type": answerType,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  int id;
  int questionId;
  String optionText;
  String createdAt;
  String updatedAt;

  Option({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: (["", null, false, 0].contains(json["id"])) ? 0 : json["id"],
        questionId: (["", null, false, 0].contains(json["question_id"]))
            ? 0
            : json["question_id"],
        optionText: (["", null, false, 0].contains(json["option_text"]))
            ? ""
            : json["option_text"],
        createdAt: (["", null, false, 0].contains(json["created_at"]))
            ? ""
            : json["created_at"],
        updatedAt: (["", null, false, 0].contains(json["updated_at"]))
            ? ""
            : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "option_text": optionText,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}





// // To parse this JSON data, do
// //
// //     final FeedbackModel = FeedbackModelFromJson(jsonString);

// import 'dart:convert';

// List<FeedbackModel> feedbackModelFromJson(String str) =>
//     List<FeedbackModel>.from(
//       json.decode(str).map(
//             (x) => FeedbackModel.fromJson(x),
//           ),
//     );

// String feedbackModelToJson(List<FeedbackModel> data) => json.encode(
//       List<dynamic>.from(
//         data.map(
//           (x) => x.toJson(),
//         ),
//       ),
//     );

// class FeedbackModel {
//   int id;
//   String questions;
//   String answerType;
//   String createdAt;
//   String updatedAt;
//   List<OptionDattum> options;

//   FeedbackModel({
//     required this.id,
//     required this.questions,
//     required this.answerType,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.options,
//   });

//   factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
//         id: (["", null, false, 0].contains(json["id"])) ? "" : json["id"],
//         questions: (["", null, false, 0].contains(json["questions"]))
//             ? ""
//             : json["questions"],
//         answerType: (["", null, false, 0].contains(json["answer_type"]))
//             ? ""
//             : json["answer_type"],
//         createdAt: (["", null, false, 0].contains(json["created_at"]))
//             ? ""
//             : json["created_at"],
//         updatedAt: (["", null, false, 0].contains(json["updated_at"]))
//             ? ""
//             : json["updated_at"],
//         options: (json["options"] == null || json["options"] == [])
//             ? []
//             : List<OptionDattum>.from(
//                 json["options"].map((x) => OptionDattum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "questions": questions,
//         "answer_type": answerType,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "options": List<dynamic>.from(options.map((x) => x.toJson())),
//       };
// }

// class OptionDattum {
//   int id;
//   int questionId;
//   String optionText;
//   String createdAt;
//   String updatedAt;

//   OptionDattum({
//     required this.id,
//     required this.questionId,
//     required this.optionText,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory OptionDattum.fromJson(Map<String, dynamic> json) => OptionDattum(
//         id: (["", null, false, 0].contains(json["id"])) ? 0 : json["id"],
//         questionId: (["", null, false, 0].contains(json["question_id"]))
//             ? 0
//             : json["question_id"],
//         optionText: (["", null, false, 0].contains(json["option_text"]))
//             ? ""
//             : json["option_text"],
//         createdAt: (["", null, false, 0].contains(json["created_at"]))
//             ? ""
//             : json["created_at"],
//         updatedAt: (["", null, false, 0].contains(json["updated_at"]))
//             ? ""
//             : json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "question_id": questionId,
//         "option_text": optionText,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }
