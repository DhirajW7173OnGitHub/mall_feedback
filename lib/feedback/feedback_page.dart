import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mall_app/Api_caller/bloc.dart';
import 'package:mall_app/Utils/common_code.dart';
import 'package:mall_app/Validation/validation_mixin.dart';
import 'package:mall_app/feedback/Model/feedback_model.dart';

import '../Api_caller/api_caller.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> with ValidationMixin {
  final _mobileFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  final mobileFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  List<FeedbackDatum> feedbackListDattum = [];

  List<bool> isCheckedList = [];

  Map<int, dynamic> selectedRadioValues = {};

  int selectedSmiley = -1;

  bool checkInternet = false;

  DateTime? selectedDate;

  //After Selected varible and list
  int selectedStars = 0;
  List<String> selectedCheckBox = [];

  List<Map<int, dynamic>> selectedRadioButton = [];

  String smileySelection = "";

  Map<String, dynamic> nameTextBoxMapData = {};
  Map<String, dynamic> emailTextBoxMapData = {};
  Map<String, dynamic> mobileTextBoxMapData = {};
  Map<String, dynamic> ageTextBoxMapData = {};
  Map<String, dynamic> radioButtonMapData = {};
  Map<String, dynamic> starMapData = {};
  Map<String, dynamic> smileyMapData = {};
  Map<String, dynamic> checkBoxMapData = {};

  List<Map> feedbackList = [];

  @override
  void initState() {
    super.initState();
    _getFeedbackData();
  }

  _getFeedbackData() async {
    var res = await globalBloc.doFetchFeedBackQueData();
    setState(() {
      feedbackListDattum.addAll(res.data);
    });
  }

  selectEmojiFeedback(int index) {
    switch (index) {
      case 1:
        return "Terrible";
      case 2:
        return "Bad";
      case 3:
        return "Good";
      case 4:
        return "Very Good";
      case 5:
        return "Awesome";
    }
  }

  bool isIntValue(String value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildTextBox(feedbackData) {
    switch (feedbackData.inputType) {
      case "name validation":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            focusNode: nameFocusNode,
            enableInteractiveSelection: false,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Enter your answer',
              contentPadding: EdgeInsets.only(left: 10),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                nameTextBoxMapData = {
                  "question_id": feedbackData.id,
                  "answers": _nameController.text
                };
              });
              int index = feedbackList.indexWhere(
                  (element) => element["question_id"] == feedbackData.id);

              if (index != -1) {
                feedbackList[index] = nameTextBoxMapData;
              } else {
                feedbackList.add(nameTextBoxMapData);
              }

              log('Name Text BOx Data:$feedbackList');
            },
          ),
        );

      case "number validation":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _mobileFormKey,
            child: TextFormField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              focusNode: mobileFocusNode,
              enableInteractiveSelection: false,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Enter your answer',
                contentPadding: EdgeInsets.only(left: 10),
                border: OutlineInputBorder(),
              ),
              validator: phoneValidation,
              onChanged: (value) {
                _mobileFormKey.currentState!.validate();
                setState(() {
                  mobileTextBoxMapData = {
                    "question_id": feedbackData.id,
                    "answers": mobileController.text
                  };
                });
                int index = feedbackList.indexWhere(
                    (element) => element["question_id"] == feedbackData.id);

                if (index != -1) {
                  feedbackList[index] = mobileTextBoxMapData;
                } else {
                  feedbackList.add(mobileTextBoxMapData);
                }
                log('Mobile Text BOx Data :$mobileTextBoxMapData');
              },
            ),
          ),
        );

      case "age validation":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                readOnly: true,
                controller: ageController,
                decoration: const InputDecoration(
                  hintText: "Age",
                ),
              ),
              IconButton(
                onPressed: () {
                  dialogForDatePicked(feedbackData);
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        );
      case "email validation":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _emailFormKey,
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              focusNode: emailFocusNode,
              enableInteractiveSelection: false,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Enter your answer',
                contentPadding: EdgeInsets.only(left: 10),
                border: OutlineInputBorder(),
              ),
              validator: emailValidation,
              onChanged: (value) {
                _emailFormKey.currentState!.validate();
                setState(() {
                  emailTextBoxMapData = {
                    "question_id": feedbackData.id,
                    "answers": emailController.text
                  };
                });
                int index = feedbackList.indexWhere(
                    (element) => element["question_id"] == feedbackData.id);

                if (index != -1) {
                  feedbackList[index] = emailTextBoxMapData;
                } else {
                  feedbackList.add(emailTextBoxMapData);
                }

                log('Name Text BOx Data:$feedbackList');
              },
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCheckboxList(feedbackData) {
    return Column(
      children: feedbackData.options.asMap().entries.map<Widget>((entry) {
        int optionIndex = entry.key;
        var option = entry.value;
        return CheckboxListTile(
          title: Text(option.optionText),
          value: isCheckedList[optionIndex],
          activeColor: Colors.purple,
          onChanged: (bool? value) {
            setState(() {
              isCheckedList[optionIndex] = value!;
              if (value) {
                selectedCheckBox.add(option.optionText);
              } else {
                selectedCheckBox.remove(option.optionText);
              }

              checkBoxMapData = {
                "question_id": feedbackData.id,
                "answers": selectedCheckBox
              };
              int index = feedbackList.indexWhere(
                  (element) => element["question_id"] == feedbackData.id);

              if (index != -1) {
                feedbackList[index] = checkBoxMapData;
              } else {
                feedbackList.add(checkBoxMapData);
              }
            });

            log('Is checked Click : $feedbackList');
          },
        );
      }).toList(),
    );
  }

  Widget _buildRadioButtonList(feedbackData, int questionIndex) {
    return Column(
      children: feedbackData.options.asMap().entries.map<Widget>((entry) {
        int optionIndex = entry.key;
        var option = entry.value;
        return RadioListTile(
          title: Text(option.optionText),
          value: option.id,
          groupValue: selectedRadioValues[feedbackData.id],
          //selectedRadioValues[feedbackData.id],
          onChanged: (dynamic value) {
            setState(() {
              selectedRadioValues[feedbackData.id] = value;
              // You can also store the selected option text or id as needed
              //selectedRadioDataForID10 = option.optionText;
              // if (feedbackData.id == 10) {
              //   selectedRadioDataForID10 = option.optionText;
              // } else {
              //   selectedRadioDataForID12 = option.optionText;
              // }
              // Remove any existing entry for this feedbackData.id before adding the new one
              selectedRadioButton.removeWhere(
                  (element) => element.containsKey(feedbackData.id));

              // Add the new selection to the selectedRadioButton list
              selectedRadioButton.add({feedbackData.id: option.optionText});

              radioButtonMapData = {
                "question_id": feedbackData.id,
                "answers": option.optionText
              };
            });

            int index = feedbackList.indexWhere(
                (element) => element["question_id"] == feedbackData.id);

            if (index != -1) {
              feedbackList[index] = radioButtonMapData;
            } else {
              feedbackList.add(radioButtonMapData);
            }
            log('Selected Radio Button for Question ID ${selectedRadioButton}: ');
          },
        );
      }).toList(),
    );
  }

  Widget _buildStarRating(feedbackData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (starIndex) {
        return IconButton(
          iconSize: 32,
          icon: Icon(
            starIndex < selectedStars ? Icons.star : Icons.star_border,
          ),
          color: starIndex < selectedStars ? Colors.purple : Colors.grey,
          onPressed: () {
            setState(() {
              selectedStars = starIndex + 1;
              starMapData = {
                "question_id": feedbackData.id,
                "answers": selectedStars.toString()
              };
            });
            int index = feedbackList.indexWhere(
                (element) => element["question_id"] == feedbackData.id);

            if (index != -1) {
              feedbackList[index] = starMapData;
            } else {
              feedbackList.add(starMapData);
            }
            log('Selected Stars: $starMapData');
          },
        );
      }),
    );
  }

  Widget _buildSmileyRating(feedbackData) {
    return EmojiFeedback(
      elementSize: 40,
      labelTextStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(fontWeight: FontWeight.w400),
      onChanged: (value) {
        setState(() {
          smileySelection = selectEmojiFeedback(value);
          smileyMapData = {
            "question_id": feedbackData.id,
            "answers": smileySelection
          };
        });
        int index = feedbackList
            .indexWhere((element) => element["question_id"] == feedbackData.id);

        if (index != -1) {
          feedbackList[index] = smileyMapData;
        } else {
          feedbackList.add(smileyMapData);
        }
        log('Selected Smiley String: $smileyMapData');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feedback'),
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: clickOnSubmitButton,
              child: const Text('SUBMIT'),
            ),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<FeedbackModel>(
              stream: globalBloc.getFeedbackQueData.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Data"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      var feedbackData = snapshot.data!.data[index];

                      // Initialize the isCheckedList based on the number of options for Checkbox type
                      if (feedbackData.answerType == 'Checkbox' &&
                          isCheckedList.length != feedbackData.options.length) {
                        isCheckedList = List<bool>.filled(
                            feedbackData.options.length, false);
                      }

                      // Initialize answerWidget to a default widget
                      Widget answerWidget = const SizedBox.shrink();

                      // Check the type of question and create the appropriate input widget
                      switch (feedbackData.answerType) {
                        case 'TextBox':
                          answerWidget = _buildTextBox(feedbackData);
                          break;
                        case 'Checkbox':
                          answerWidget = _buildCheckboxList(feedbackData);
                          break;
                        case 'Radio Button':
                          answerWidget =
                              _buildRadioButtonList(feedbackData, index);
                          break;
                        case 'Stars':
                          answerWidget = _buildStarRating(feedbackData);
                          break;
                        case 'Smiley':
                          answerWidget = _buildSmileyRating(feedbackData);
                          break;
                        default:
                          answerWidget = const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    feedbackData.questions,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                answerWidget, // Add the input widget below the question
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  void clickOnSubmitButton() async {
    checkInternet = await InternetConnection().hasInternetAccess;
    log('Internet $checkInternet');
    if (checkInternet) {
      List<int> availableAllId = feedbackListDattum
          .map((item) => int.parse(item.id.toString()))
          .toList();

      List<int> questionIdFromFeedback =
          feedbackList.map((item) => item["question_id"] as int).toList();

      var data = [];
      for (var availableId in availableAllId) {
        if (!questionIdFromFeedback.contains(availableId)) {
          data.add(availableId);
        }
      }
      if (data.isNotEmpty) {
        var que = getNotAnswerQuestionName(data.first);
        CommonCode.commonDialogForData(
          context,
          msg: "Fill : $que",
          isBarrier: false,
          second: 4,
        );
      } else {
        var res = await ApiCaller().uploadFeedbackData(feedbackList);

        if (res!["errorcode"] == 0) {
          finalSubmitDialog(msg: res["message"]);
        } else {
          _getMessage(res["message"]);
        }
      }
    } else {
      _getMessage("Check Internet Connection");
    }
  }

  String getNotAnswerQuestionName(int id) {
    var item = feedbackListDattum.firstWhere(
      (item) => item.id == id,
    );
    return item.questions;
  }

  void dialogForDatePicked(feedbackData) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        var age = _calculateAge(selectedDate!);
        ageController.text = age.toString();
        ageTextBoxMapData = {
          "question_id": feedbackData.id,
          "answers": ageController.text
        };
      });
      int index = feedbackList
          .indexWhere((element) => element["question_id"] == feedbackData.id);

      if (index != -1) {
        feedbackList[index] = ageTextBoxMapData;
      } else {
        feedbackList.add(ageTextBoxMapData);
      }
      log('Mobile Text BOx Data :$feedbackList');
    }
  }

  int _calculateAge(DateTime dateOfBirth) {
    DateTime today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  void finalSubmitDialog({String? msg}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Thanks!",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 24,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  msg!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getMessage(String msg) {
    CommonCode.commonDialogForData(
      context,
      msg: msg,
      isBarrier: false,
      second: 2,
    );
  }
}
