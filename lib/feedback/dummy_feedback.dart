// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:mall_app/Api_caller/bloc.dart';
// import 'package:mall_app/Api_caller/upload_data_api_caller.dart';
// import 'package:mall_app/Shared_Preference/local_Storage_data.dart';
// import 'package:mall_app/Shared_Preference/storage_preference_util.dart';
// import 'package:mall_app/Utils/common_code.dart';
// import 'package:mall_app/Validation/validation_mixin.dart';
// import 'package:mall_app/feedback/Model/feedback_model.dart';

// class DummyFeedBackPage extends StatefulWidget {
//   const DummyFeedBackPage({super.key});

//   @override
//   State<DummyFeedBackPage> createState() => _DummyFeedBackPageState();
// }

// class _DummyFeedBackPageState extends State<DummyFeedBackPage>
//     with ValidationMixin {
//   final _mobileFormKey = GlobalKey<FormState>();
//   final _emailFormKey = GlobalKey<FormState>();
// //  final _commentFormKey = GlobalKey<FormState>();

//   final _nameController = TextEditingController();
//   final ageController = TextEditingController();
//   final mobileController = TextEditingController();
//   final emailController = TextEditingController();
//   final commentController = TextEditingController();

//   final mobileFocusNode = FocusNode();
//   final nameFocusNode = FocusNode();
//   final emailFocusNode = FocusNode();
//   final commentFocusNode = FocusNode();

//   int currentQuestionIndex = 0; // Track the current question index
//   bool isNextButtonVisible = false; // To show or hide the "Next" button
//   //List<bool> isCheckedList = [];

//   //used for save all FeedbackDatum data
//   List<FeedbackDatum> feedbackListDattum = [];

//   List<bool> isCheckedList = [];
//   Map<int, dynamic> selectedRadioValues = {};

//   int selectedSmiley = -1;
//   bool checkInternet = false;
//   DateTime? selectedDate;

//   //After Selected varible and list
//   int selectedStars = 0;

//   //used for adding selected checkbox name
//   List<String> selectedCheckBox = [];
//   List<Map<int, dynamic>> selectedRadioButton = [];
//   String smileySelection = "";

//   //used for save map in which contain question Id and Answer with key and value
//   Map<String, dynamic> nameTextBoxMapData = {};
//   Map<String, dynamic> emailTextBoxMapData = {};
//   Map<String, dynamic> mobileTextBoxMapData = {};
//   Map<String, dynamic> ageTextBoxMapData = {};
//   Map<String, dynamic> radioButtonMapData = {};
//   Map<String, dynamic> starMapData = {};
//   Map<String, dynamic> smileyMapData = {};
//   Map<String, dynamic> checkBoxMapData = {};
//   Map<String, dynamic> genericTextBoxMapData = {};
//   Map<String, dynamic> commentTextAreaMapData = {};

//   //Used to store all question's id with Answer
//   List<Map> feedbackList = [];

//   @override
//   void initState() {
//     super.initState();
//     _getFeedbackData();
//   }

//   _getFeedbackData() async {
//     var res = await globalBloc.doFetchFeedBackQueData();
//     setState(() {
//       feedbackListDattum.addAll(res.data);
//     });
//   }

//   //Send Answer in String according to select index of Smiley face
//   selectEmojiFeedback(int index) {
//     switch (index) {
//       case 1:
//         return "Terrible";
//       case 2:
//         return "Bad";
//       case 3:
//         return "Good";
//       case 4:
//         return "Very Good";
//       case 5:
//         return "Awesome";
//     }
//   }

//   // bool isIntValue(String value) {
//   //   try {
//   //     int.parse(value);
//   //     return true;
//   //   } catch (e) {
//   //     return false;
//   //   }
//   // }

//   Widget _buildTextBox(feedbackData) {
//     //build TextFormField according inputType of feedbackData
//     switch (feedbackData.inputType) {
//       case "name validation":
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: TextFormField(
//             controller: _nameController,
//             keyboardType: TextInputType.name,
//             focusNode: nameFocusNode,
//             enableInteractiveSelection: false,
//             textInputAction: TextInputAction.done,
//             textCapitalization: TextCapitalization.words,
//             decoration: const InputDecoration(
//               hintText: 'Enter your answer',
//               contentPadding: EdgeInsets.only(left: 10),
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 //save question ID and Answer in nameTextBoxMapData
//                 nameTextBoxMapData = {
//                   "question_id": feedbackData.id,
//                   "answers": _nameController.text
//                 };
//               });

//               // here we get index in -1 or 0 format by checking such
//               //question id exist or not in feedbackList
//               int index = feedbackList.indexWhere(
//                   (element) => element["question_id"] == feedbackData.id);
//               //According to index it add in list
//               if (index != -1) {
//                 feedbackList[index] = nameTextBoxMapData;
//               } else {
//                 feedbackList.add(nameTextBoxMapData);
//               }

//               Logger.dataLog('Name Text Box Data:$feedbackList');
//             },
//           ),
//         );

//       case "number validation":
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Form(
//             key: _mobileFormKey,
//             child: TextFormField(
//               controller: mobileController,
//               keyboardType: TextInputType.phone,
//               focusNode: mobileFocusNode,
//               enableInteractiveSelection: false,
//               textInputAction: TextInputAction.done,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your answer',
//                 contentPadding: EdgeInsets.only(left: 10),
//                 border: OutlineInputBorder(),
//               ),
//               validator: phoneValidation,
//               onChanged: (value) {
//                 _mobileFormKey.currentState!.validate();
//                 setState(() {
//                   mobileTextBoxMapData = {
//                     "question_id": feedbackData.id,
//                     "answers": mobileController.text
//                   };
//                 });
//                 int index = feedbackList.indexWhere(
//                     (element) => element["question_id"] == feedbackData.id);

//                 if (index != -1) {
//                   feedbackList[index] = mobileTextBoxMapData;
//                 } else {
//                   feedbackList.add(mobileTextBoxMapData);
//                 }
//                 Logger.dataLog('Mobile Text BOx Data :$mobileTextBoxMapData');
//               },
//             ),
//           ),
//         );

//       case "age validation":
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               TextFormField(
//                 readOnly: true,
//                 controller: ageController,
//                 decoration: const InputDecoration(
//                   hintText: "Age",
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   dialogForDatePicked(feedbackData);
//                 },
//                 icon: const Icon(Icons.calendar_month),
//               ),
//             ],
//           ),
//         );
//       case "email validation":
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Form(
//             key: _emailFormKey,
//             child: TextFormField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               focusNode: emailFocusNode,
//               enableInteractiveSelection: false,
//               textInputAction: TextInputAction.done,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your answer',
//                 contentPadding: EdgeInsets.only(left: 10),
//                 border: OutlineInputBorder(),
//               ),
//               validator: emailValidation,
//               onChanged: (value) {
//                 _emailFormKey.currentState!.validate();
//                 setState(() {
//                   emailTextBoxMapData = {
//                     "question_id": feedbackData.id,
//                     "answers": emailController.text
//                   };
//                 });
//                 int index = feedbackList.indexWhere(
//                     (element) => element["question_id"] == feedbackData.id);

//                 if (index != -1) {
//                   feedbackList[index] = emailTextBoxMapData;
//                 } else {
//                   feedbackList.add(emailTextBoxMapData);
//                 }

//                 Logger.dataLog('Name Text BOx Data:$feedbackList');
//               },
//             ),
//           ),
//         );

//       default:
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: TextFormField(
//             controller: TextEditingController(),
//             keyboardType: TextInputType.text,
//             focusNode: FocusNode(),
//             enableInteractiveSelection: false,
//             textInputAction: TextInputAction.done,
//             decoration: const InputDecoration(
//               hintText: 'Enter your answer',
//               contentPadding: EdgeInsets.only(left: 10),
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 genericTextBoxMapData = {
//                   "question_id": feedbackData.id,
//                   "answers": value
//                 };
//               });
//               int index = feedbackList.indexWhere(
//                   (element) => element["question_id"] == feedbackData.id);

//               if (index != -1) {
//                 feedbackList[index] = genericTextBoxMapData;
//               } else {
//                 feedbackList.add(genericTextBoxMapData);
//               }

//               Logger.dataLog('Generic TextBox Data:$feedbackList');
//             },
//           ),
//         );
//     }
//   }

//   Widget _buildTextAreaBox(feedbackData) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: TextField(
//         controller: commentController,
//         focusNode: commentFocusNode,
//         maxLines: 6,
//         // inputFormatters: [
//         //   FilteringTextInputFormatter.allow(
//         //     RegExp(r'[a-zA-Z\s,.\?]'),
//         //   ),
//         // ],
//         keyboardType: TextInputType.multiline,
//         decoration: const InputDecoration(
//           border: OutlineInputBorder(),
//           hintText: 'Enter your text here',
//         ),
//         onChanged: (value) {
//           setState(() {
//             commentTextAreaMapData = {
//               "question_id": feedbackData.id,
//               "answers": commentController.text,
//             };
//           });
//           int index = feedbackList.indexWhere(
//               (element) => element["question_id"] == feedbackData.id);

//           if (index != -1) {
//             feedbackList[index] = commentTextAreaMapData;
//           } else {
//             feedbackList.add(commentTextAreaMapData);
//           }

//           Logger.dataLog('Name Text BOx Data:$feedbackList');
//         },
//       ),
//     );
//   }

//   Widget _buildCheckboxList(feedbackData) {
//     return Column(
//       //construct Widget according getting data in key and value form
//       children: feedbackData.options.asMap().entries.map<Widget>((entry) {
//         int optionIndex = entry.key;
//         var option = entry.value;
//         return CheckboxListTile(
//           title: Text(option.optionText),
//           //used bool list where check box check or not according their index
//           value: isCheckedList[optionIndex],
//           activeColor: Colors.purple,
//           onChanged: (bool? value) {
//             setState(() {
//               isCheckedList[optionIndex] = value!;
//               if (value) {
//                 //value is true then add optionText in selectedCheckBox list
//                 selectedCheckBox.add(option.optionText);
//               } else {
//                 //value is false then remove optionText from selectedCheckBox list
//                 selectedCheckBox.remove(option.optionText);
//               }

//               checkBoxMapData = {
//                 "question_id": feedbackData.id,
//                 "answers":
//                     selectedCheckBox //this selectedCheckBox take as answer
//               };
//               int index = feedbackList.indexWhere(
//                   (element) => element["question_id"] == feedbackData.id);

//               if (index != -1) {
//                 feedbackList[index] = checkBoxMapData;
//               } else {
//                 feedbackList.add(checkBoxMapData);
//               }
//             });

//             Logger.dataLog('Is checked Click : $feedbackList');
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildRadioButtonList(feedbackData, int questionIndex) {
//     return Column(
//       children: feedbackData.options.asMap().entries.map<Widget>((entry) {
//         int optionIndex = entry.key;
//         var option = entry.value;
//         return RadioListTile(
//           title: Text(option.optionText),
//           value: option.id,
//           groupValue: selectedRadioValues[feedbackData.id],
//           onChanged: (dynamic value) {
//             setState(() {
//               selectedRadioValues[feedbackData.id] = value;

//               selectedRadioButton.removeWhere(
//                   (element) => element.containsKey(feedbackData.id));

//               // Add the new selection to the selectedRadioButton list
//               selectedRadioButton.add({feedbackData.id: option.optionText});

//               radioButtonMapData = {
//                 "question_id": feedbackData.id,
//                 "answers": option.optionText
//               };
//             });

//             int index = feedbackList.indexWhere(
//                 (element) => element["question_id"] == feedbackData.id);

//             if (index != -1) {
//               feedbackList[index] = radioButtonMapData;
//             } else {
//               feedbackList.add(radioButtonMapData);
//             }
//             Logger.dataLog('Selected Radio Button for Question ID $selectedRadioButton');
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildStarRating(feedbackData) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: List.generate(5, (starIndex) {
//         return IconButton(
//           iconSize: 32,
//           icon: Icon(
//             //everyTime starIndex check with selectedStars
//             starIndex < selectedStars ? Icons.star : Icons.star_border,
//           ),
//           color: starIndex < selectedStars ? Colors.purple : Colors.grey,
//           onPressed: () {
//             setState(() {
//               selectedStars = starIndex + 1;
//               starMapData = {
//                 "question_id": feedbackData.id,
//                 "answers": selectedStars.toString()
//               };
//             });
//             int index = feedbackList.indexWhere(
//                 (element) => element["question_id"] == feedbackData.id);

//             if (index != -1) {
//               feedbackList[index] = starMapData;
//             } else {
//               feedbackList.add(starMapData);
//             }
//             Logger.dataLog('Selected Stars: $starMapData');
//           },
//         );
//       }),
//     );
//   }

//   Widget _buildSmileyRating(feedbackData) {
//     //flutter_emoji_feedback package gives 6 different Emoji for feedback
//     return EmojiFeedback(
//       elementSize: 40,
//       labelTextStyle: Theme.of(context)
//           .textTheme
//           .bodySmall
//           ?.copyWith(fontWeight: FontWeight.w400),
//       onChanged: (value) {
//         setState(() {
//           smileySelection = selectEmojiFeedback(value);
//           smileyMapData = {
//             "question_id": feedbackData.id,
//             "answers": smileySelection
//           };
//         });
//         int index = feedbackList
//             .indexWhere((element) => element["question_id"] == feedbackData.id);

//         if (index != -1) {
//           feedbackList[index] = smileyMapData;
//         } else {
//           feedbackList.add(smileyMapData);
//         }
//         Logger.dataLog('Selected Smiley String: $smileyMapData');
//       },
//     );
//   }

//   void goToNextQuestion() {
//     if (currentQuestionIndex < feedbackListDattum.length - 1) {
//       setState(() {
//         currentQuestionIndex++;
//       });
//     } else {
//       // You can handle the case when all questions are answered, like submitting the form
//       print('All questions answered');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Feedback'),
//         ),
//         bottomSheet: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('CANCEL'),
//             ),
//             ElevatedButton(
//               onPressed: goToNextQuestion,
//               child: currentQuestionIndex < feedbackListDattum.length - 1
//                   ? const Text('NEXT')
//                   : const Text('SUBMIT'),
//             ),
//           ],
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Assuming that feedbackListDattum is already filled with the questions
//             if (feedbackListDattum.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Text(
//                       feedbackListDattum[currentQuestionIndex].questions,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Display the answer widget for the current question
//                   _buildAnswerWidget(feedbackListDattum[currentQuestionIndex]),
//                   const SizedBox(height: 10),
//                 ],
//               )

//             // Expanded(
//             //   child: ListView(
//             //     shrinkWrap: true,
//             //     children: [
//             //       Padding(
//             //         padding: const EdgeInsets.symmetric(
//             //             horizontal: 10, vertical: 4),
//             //         child: Column(
//             //           crossAxisAlignment: CrossAxisAlignment.start,
//             //           children: [
//             //             Padding(
//             //               padding: const EdgeInsets.only(left: 10),
//             //               child: Text(
//             //                 feedbackListDattum[currentQuestionIndex]
//             //                     .questions,
//             //                 style: Theme.of(context)
//             //                     .textTheme
//             //                     .bodyLarge!
//             //                     .copyWith(fontWeight: FontWeight.bold),
//             //               ),
//             //             ),
//             //             const SizedBox(height: 10),
//             //             // Display the answer widget for the current question
//             //             _buildAnswerWidget(
//             //                 feedbackListDattum[currentQuestionIndex]),
//             //             const SizedBox(height: 10),
//             //           ],
//             //         ),

//             //       ),
//             //       const Divider(),
//             //     ],
//             //   ),
//             // )
//             else
//               const Center(
//                 child: Text("No Questions Available"),
//               ),
//             const SizedBox(
//               height: 80,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnswerWidget(FeedbackDatum feedbackData) {
//     Widget answerWidget = const SizedBox.shrink();

//     switch (feedbackData.answerType) {
//       case 'TextBox':
//         answerWidget = _buildTextBox(feedbackData);
//         break;
//       case 'Textarea':
//         answerWidget = _buildTextAreaBox(feedbackData);
//         break;
//       case 'Checkbox':
//         answerWidget = _buildCheckboxList(feedbackData);
//         break;
//       case 'Radio Button':
//         answerWidget =
//             _buildRadioButtonList(feedbackData, currentQuestionIndex);
//         break;
//       case 'Stars':
//         answerWidget = _buildStarRating(feedbackData);
//         break;
//       case 'Smiley':
//         answerWidget = _buildSmileyRating(feedbackData);
//         break;
//       default:
//         answerWidget = const SizedBox.shrink();
//     }

//     return answerWidget;
//   }

//   void clickOnSubmitButton() async {
//     checkInternet = await InternetConnection().hasInternetAccess;
//     Logger.dataLog('Internet $checkInternet');
//     if (checkInternet) {
//       EasyLoading.show(dismissOnTap: false);

//       //here save all questions Id in integer list availableAllId
//       List<int> availableAllId = feedbackListDattum
//           .map((item) => int.parse(item.id.toString()))
//           .toList();

//       //Here Also Save All Answer questions id in questionIdFromFeedback
//       List<int> questionIdFromFeedback =
//           feedbackList.map((item) => item["question_id"] as int).toList();

//       var data = [];

//       //Here check availableAllId is present or not in questionIdFromFeedback
//       //if some availableAllId not exist in questionIdFromFeedback then such ID
//       //save in data List
//       for (var availableId in availableAllId) {
//         if (!questionIdFromFeedback.contains(availableId)) {
//           data.add(availableId);
//         }
//       }

//       //final Check Data list Is Empty or not
//       if (data.isNotEmpty) {
//         EasyLoading.dismiss();
//         //if data list not empty then showDialog of question which present at index 0
//         var question = getNotAnswerQuestionName(data.first);
//         _getMessage("Fill : $question", 4);
//       } else {
//         var res = await UploadFileDataApiCaller().uploadFeedbackData(
//             StorageUtil.getString(localStorageData.ID), feedbackList);
//         EasyLoading.dismiss();
//         if (res!["errorcode"] == 0) {
//           finalSubmitDiaLogger.dataLog(msg: res["message"]);
//         } else {
//           _getMessage(res["message"], 2);
//         }
//       }
//     } else {
//       _getMessage("Check Internet Connection", 2);
//     }
//   }

//   String getNotAnswerQuestionName(int id) {
//     //here check getting Id and id which is from feedbackListDattum
//     //list is equal or not if it get equal then return questions w.r.t that id
//     var item = feedbackListDattum.firstWhere(
//       (item) => item.id == id,
//     );
//     return item.questions;
//   }

//   void dialogForDatePicked(feedbackData) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1930),
//       lastDate: DateTime.now(),
//     );

//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//         var age = _calculateAge(selectedDate!);
//         ageController.text = age.toString();
//         ageTextBoxMapData = {
//           "question_id": feedbackData.id,
//           "answers": ageController.text
//         };
//       });
//       int index = feedbackList
//           .indexWhere((element) => element["question_id"] == feedbackData.id);

//       if (index != -1) {
//         feedbackList[index] = ageTextBoxMapData;
//       } else {
//         feedbackList.add(ageTextBoxMapData);
//       }
//       Logger.dataLog('Mobile Text BOx Data :$feedbackList');
//     }
//   }

//   int _calculateAge(DateTime dateOfBirth) {
//     DateTime today = DateTime.now();
//     int age = today.year - dateOfBirth.year;
//     if (today.month < dateOfBirth.month ||
//         (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
//       age--;
//     }
//     return age;
//   }

//   void finalSubmitDiaLogger.dataLog({String? msg}) {
//     showDiaLogger.dataLog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDiaLogger.dataLog(
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Center(
//                   child: Text(
//                     "Thanks!",
//                     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                         fontSize: 24,
//                         color: Colors.purple,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   msg!,
//                   maxLines: 2,
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge!
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                     },
//                     child: const Text("OK"),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   _getMessage(String msg, int seconds) {
//     CommonCode.commonDialogForData(
//       context,
//       msg: msg,
//       isBarrier: false,
//       second: seconds,
//     );
//   }
// }
