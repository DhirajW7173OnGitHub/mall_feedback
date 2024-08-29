// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
// import 'package:mall_app/Api_caller/bloc.dart';
// import 'package:mall_app/feedback/Model/feedback_model.dart';

// class NewFeedBackScreen extends StatefulWidget {
//   const NewFeedBackScreen({super.key});

//   @override
//   State<NewFeedBackScreen> createState() => _NewFeedBackScreenState();
// }

// class _NewFeedBackScreenState extends State<NewFeedBackScreen> {
//   // Dynamic map to store the selected values for each question
//   Map<int, dynamic> selectedAnswers = {};

//   @override
//   void initState() {
//     super.initState();
//     globalBloc.doFetchFeedBackQueData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Feedback'),
//       ),
//       bottomSheet: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton(
//             onPressed: () {},
//             child: const Text('CANCEL'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               log('######:$selectedAnswers');
//             },
//             child: const Text('SUBMIT'),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           StreamBuilder<FeedbackModel>(
//             stream: globalBloc.getFeedbackQueData.stream,
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(child: Text("No Data"));
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               }
//               return Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: snapshot.data!.data.length,
//                   itemBuilder: (context, index) {
//                     var feedbackData = snapshot.data!.data[index];
//                     return buildQuestionWidget(feedbackData);
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Dynamic method to build the widget for each question based on the answer type
//   Widget buildQuestionWidget(dynamic feedbackData) {
//     Widget answerWidget;

//     switch (feedbackData.answerType) {
//       case 'TextBox':
//         answerWidget = buildTextBox(feedbackData);
//         break;
//       case 'Checkbox':
//         answerWidget = buildCheckboxList(feedbackData);
//         break;
//       case 'Radio Button':
//         answerWidget = buildRadioButtonList(feedbackData);
//         break;
//       case 'Stars':
//         answerWidget = buildStarRating(feedbackData);
//         break;
//       case 'Smiley':
//         answerWidget = buildSmileyRating(feedbackData);
//         break;
//       default:
//         answerWidget = const SizedBox.shrink();
//     }

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Text(
//                   feedbackData.questions,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               answerWidget, // Add the dynamically created input widget below the question
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//         const Divider(),
//       ],
//     );
//   }

//   // Method to build a dynamic TextBox widget
//   Widget buildTextBox(dynamic feedbackData) {
//     TextEditingController controller = TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: TextField(
//         controller: controller,
//         keyboardType: _getTextInputType(feedbackData.inputType),
//         decoration: const InputDecoration(
//           hintText: 'Enter your answer',
//           contentPadding: EdgeInsets.only(left: 10),
//           border: OutlineInputBorder(),
//         ),
//         onChanged: (value) {
//           setState(() {
//             selectedAnswers[feedbackData.id] = value;
//           });
//         },
//       ),
//     );
//   }

//   // Method to build a dynamic Checkbox list
//   Widget buildCheckboxList(dynamic feedbackData) {
//     return Column(
//       children: feedbackData.options.asMap().entries.map<Widget>((entry) {
//         int optionIndex = entry.key;
//         var option = entry.value;
//         return CheckboxListTile(
//           title: Text(option.optionText),
//           value:
//               selectedAnswers[feedbackData.id]?.contains(option.optionText) ??
//                   false,
//           activeColor: Colors.purple,
//           onChanged: (bool? value) {
//             setState(() {
//               if (value == true) {
//                 selectedAnswers[feedbackData.id] =
//                     (selectedAnswers[feedbackData.id] ?? <String>[])
//                       ..add(option.optionText);
//               } else {
//                 selectedAnswers[feedbackData.id]?.remove(option.optionText);
//               }
//             });
//           },
//         );
//       }).toList(),
//     );
//   }

//   // Method to build a dynamic Radio Button list
//   Widget buildRadioButtonList(dynamic feedbackData) {
//     return Column(
//       children: feedbackData.options.asMap().entries.map<Widget>((entry) {
//         int optionIndex = entry.key;
//         var option = entry.value;
//         return RadioListTile(
//           title: Text(option.optionText),
//           value: option.id,
//           groupValue: selectedAnswers[feedbackData.id],
//           onChanged: (dynamic value) {
//             setState(() {
//               selectedAnswers[feedbackData.id] = value;
//             });
//           },
//         );
//       }).toList(),
//     );
//   }

//   // Method to build a dynamic Star Rating widget
//   Widget buildStarRating(dynamic feedbackData) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: List.generate(5, (starIndex) {
//         return IconButton(
//           iconSize: 32,
//           icon: Icon(
//             starIndex < (selectedAnswers[feedbackData.id] ?? 0)
//                 ? Icons.star
//                 : Icons.star_border,
//           ),
//           color: starIndex < (selectedAnswers[feedbackData.id] ?? 0)
//               ? Colors.purple
//               : Colors.grey,
//           onPressed: () {
//             setState(() {
//               selectedAnswers[feedbackData.id] = starIndex + 1;
//             });
//           },
//         );
//       }),
//     );
//   }

//   // Method to build a dynamic Smiley Rating widget
//   Widget buildSmileyRating(dynamic feedbackData) {
//     return EmojiFeedback(
//       elementSize: 40,
//       labelTextStyle: Theme.of(context)
//           .textTheme
//           .bodySmall
//           ?.copyWith(fontWeight: FontWeight.w400),
//       onChanged: (value) {
//         setState(() {
//           selectedAnswers[feedbackData.id] = value;
//         });
//       },
//     );
//   }

//   // Helper method to get the appropriate TextInputType based on inputType
//   TextInputType _getTextInputType(String inputType) {
//     switch (inputType) {
//       case "name validation":
//         return TextInputType.name;
//       case "number validation":
//         return TextInputType.phone;
//       case "age validation":
//         return TextInputType.number;
//       default:
//         return TextInputType.text;
//     }
//   }

//   // Method to submit the feedback and handle the selected values
//   void submitFeedback() {
//     selectedAnswers.forEach((questionId, selectedValue) {
//       log('Question ID: $questionId, Selected Value: $selectedValue');
//     });
//     // Handle submission logic here
//   }
// }
