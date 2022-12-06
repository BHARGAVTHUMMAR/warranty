import 'dart:convert';
import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:warranty_appp/utilities/buttons.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../constants/text_field.dart';
import '../../../../main.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_item_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AddItemView extends GetView<AddItemController> {
  const AddItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        (controller.isFromHome)
            ? Get.offAndToNamed(Routes.HOME)
            : Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
                ArgumentConstant.Categoriename: controller.categoryName
              });
        return await true;
      },
      child: SafeArea(
        child: Obx(() {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                Expanded(
                  child: Container(
                    color: appTheme.appbarTheme,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(MySize.getHeight(8.0)),
                          child: GestureDetector(
                            onTap: () {
                              (controller.isFromHome)
                                  ? Get.offAndToNamed(Routes.HOME)
                                  : Get.offAndToNamed(
                                      Routes.ADD_ITEM_LISTSCREEN,
                                      arguments: {
                                          ArgumentConstant.Categoriename:
                                              controller.categoryName
                                        });
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          (controller.isFromEdit) ? "Update Item" : "Add Item",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(20),
                              color: Colors.white),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.all(MySize.getHeight(8.0)),
                          child: GestureDetector(
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.isNameEmpty.isFalse &&
                                    controller.isDurationEmpty.isFalse) {
                                  controller.expireDay.value =
                                      (getDateFromStringNew(
                                              getExpiryDateString(),
                                              formatter: "dd/MM/yyyy HH:mm:ss")
                                          .difference(getDateFromStringNew(
                                              controller
                                                  .dateController.value.text
                                                  .toString(),
                                              formatter: "dd/MM/yyyy HH:mm:ss"))
                                          .inSeconds);
                                  controller.selectedExpireSec.value =
                                      ((controller.expireDay.value) -
                                          ((controller
                                                  .selectedExpireDay.value) *
                                              86400));
                                  await (controller
                                              .durationcontroller.value.text ==
                                          "0")
                                      ? SizedBox()
                                      : controller.service
                                          .showScheduledNotification(
                                              id: 0,
                                              title: "Warranty App",
                                              body:
                                                  "${controller.itemnamecontroller.value.text} To ReNew",
                                              seconds: controller
                                                  .selectedExpireSec.value);
                                  if (controller.isFromEdit) {
                                    controller.EditItem(dataModels(
                                        id: DateTime.now()
                                            .microsecondsSinceEpoch,
                                        selectedExpireDay: controller.selectedExpireDay.value
                                            .toString(),
                                        ItemName: controller
                                            .itemnamecontroller.value.text,
                                        Date: controller
                                            .dateController.value.text,
                                        Image: (controller.files!.isNotEmpty)
                                            ? controller.files![0]
                                            : null,
                                        Bill: (controller.files1!.isNotEmpty)
                                            ? controller.files1![0]
                                            : null,
                                        expiredDate: getExpiryDateString(),
                                        selectedExpireName: controller.selectedExpireName.value
                                            .toString(),
                                        Ditails: controller
                                            .detailscontroller.value.text,
                                        Duration: controller
                                            .durationcontroller.value.text,
                                        categoriesName: controller
                                            .dropDownController!
                                            .dropDownValue!
                                            .name
                                            .toString()));
                                  } else {
                                    controller.addItem(dataModels(
                                        id: DateTime.now()
                                            .microsecondsSinceEpoch,
                                        ItemName: controller
                                            .itemnamecontroller.value.text,
                                        Date: controller
                                            .dateController.value.text,
                                        Image: (controller.files!.isNotEmpty)
                                            ? controller.files![0]
                                            : null,
                                        Bill: (controller.files1!.isNotEmpty)
                                            ? controller.files1![0]
                                            : null,
                                        expiredDate: getExpiryDateString(),
                                        selectedExpireName: controller
                                            .selectedExpireName.value
                                            .toString(),
                                        selectedExpireDay: controller
                                            .selectedExpireDay.value
                                            .toString(),
                                        Ditails: controller
                                            .detailscontroller.value.text,
                                        Duration: controller
                                            .durationcontroller.value.text,
                                        categoriesName: controller
                                            .dropDownController!
                                            .dropDownValue!
                                            .name
                                            .toString()));
                                  }
                                }
                              } else {
                                if (controller
                                    .itemnamecontroller.value.text.isEmpty) {
                                  controller.isNameEmpty.value = true;
                                }
                                if (controller
                                    .durationcontroller.value.text.isEmpty) {
                                  controller.isDurationEmpty.value = true;
                                }
                              }
                            },
                            child: Container(
                              height: MySize.getHeight(40),
                              width: MySize.getWidth(70),
                              child: Center(
                                child: Text(
                                  (controller.isFromEdit) ? "UPDATE" : "SAVE",
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(15),
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MySize.getWidth(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacing.height(20),
                              Text(
                                "Item Name",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 7),
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: MySize.getHeight(13),
                                      spreadRadius: MySize.getHeight(2),
                                    ),
                                  ],
                                ),
                                child: getTextField(
                                  hintText: "Enter Item Name",
                                  borderColor: (controller.isNameEmpty.isTrue)
                                      ? appTheme.ErrorText
                                      : Colors.transparent,
                                  size: 70,
                                  textCapitalization: TextCapitalization.words,
                                  isFilled: true,
                                  validation: (value) {
                                    if (!isNullEmptyOrFalse(value)) {
                                      controller.isNameEmpty.value = false;
                                    } else {
                                      controller.isNameEmpty.value = true;
                                    }
                                    return null;
                                  },
                                  fillColor: Colors.white,
                                  textEditingController:
                                      controller.itemnamecontroller.value,
                                ),
                              ),
                              Spacing.height(20),
                              Text(
                                "Category",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 7),
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: MySize.getHeight(13),
                                      spreadRadius: MySize.getHeight(2),
                                    ),
                                  ],
                                ),
                                child: DropDownTextField(
                                  controller: controller.dropDownController,
                                  isEnabled: controller.isFromHome,
                                  textStyle: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(13),
                                      color: Colors.black),
                                  clearOption: false,
                                  listTextStyle: GoogleFonts.lexend(
                                      fontWeight: FontWeight.w400,
                                      fontSize: MySize.getHeight(13),
                                      color: Colors.black),
                                  textFieldDecoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          MySize.getHeight(10)),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      left: MySize.getWidth(20),
                                      right: MySize.getWidth(10),
                                      //  bottom: size! / 2, // HERE THE IMPORTANT PART
                                    ),
                                  ),
                                  clearIconProperty:
                                      IconProperty(color: Colors.green),
                                  dropDownItemCount: 6,
                                  dropDownList: controller
                                      .homeController!.categoryDataList
                                      .map((element) => DropDownValueModel(
                                          name:
                                              element.categoriesName.toString(),
                                          value: element.categoriesName
                                              .toString()))
                                      .toList(),
                                ),
                              ),
                              Spacing.height(20),
                              Text(
                                "Purchase Date",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 7),
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: MySize.getHeight(13),
                                      spreadRadius: MySize.getHeight(2),
                                    ),
                                  ],
                                ),
                                child: getTextField(
                                    fontSize: MySize.getHeight(13),
                                    fillColor: Colors.white,
                                    isFilled: true,
                                    textEditingController:
                                        controller.dateController.value,
                                    labelColor: Colors.grey,
                                    readOnly: true,
                                    suffixIcon: GestureDetector(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                        primary: appTheme
                                                            .yellowPrimaryTheme,
                                                      ),
                                                      textButtonTheme:
                                                          TextButtonThemeData(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor: Colors
                                                              .black, // button text color
                                                        ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));

                                        if (pickedDate != null) {
                                          DateTime now = DateTime.now();
                                          controller.dateController.value.text =
                                              DateFormat('dd/MM/yyyy').format(
                                                  DateTime(
                                                      pickedDate.year,
                                                      pickedDate.month,
                                                      pickedDate.day,
                                                      now.hour,
                                                      now.minute,
                                                      now.second));
                                          controller.selectedDate.value =
                                              pickedDate;
                                        } else {
                                          print("Date is not selected");
                                        }
                                      },
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    textInputType: TextInputType.name),
                              ),
                              Spacing.height(20),
                              Text(
                                "Duration In Days",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 7),
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: MySize.getHeight(13),
                                      spreadRadius: MySize.getHeight(2),
                                    ),
                                  ],
                                ),
                                child: getTextField(
                                    isFilled: true,
                                    fillColor: Colors.white,
                                    borderColor:
                                        (controller.isDurationEmpty.isTrue)
                                            ? appTheme.ErrorText
                                            : Colors.white,
                                    textEditingController:
                                        controller.durationcontroller.value,
                                    hintText: "Duration In Days",
                                    validation: (value) {
                                      if (!isNullEmptyOrFalse(value)) {
                                        controller.isDurationEmpty.value =
                                            false;
                                      } else {
                                        controller.isDurationEmpty.value = true;
                                      }
                                      return null;
                                    },
                                    onChange: (value) {
                                      print(value);
                                      controller.durationcontroller.refresh();
                                      controller.days.value =
                                          int.parse(value.toString());
                                    },
                                    labelColor: Colors.grey,
                                    textInputType: TextInputType.number),
                              ),
                              Spacing.height(20),
                              if (!isNullEmptyOrFalse(
                                  controller.durationcontroller.value.text))
                                if (int.tryParse(controller
                                        .durationcontroller.value.text)! >
                                    0)
                                  Text(
                                    "Schedule Notification",
                                    style: GoogleFonts.lexend(
                                        fontWeight: FontWeight.w400,
                                        fontSize: MySize.getHeight(13),
                                        color: Colors.black),
                                  ),
                              if (!isNullEmptyOrFalse(
                                  controller.durationcontroller.value.text))
                                if (int.tryParse(controller
                                        .durationcontroller.value.text)! >
                                    0)
                                  Spacing.height(12),
                              if (!isNullEmptyOrFalse(
                                  controller.durationcontroller.value.text))
                                if (int.tryParse(controller
                                        .durationcontroller.value.text)! >
                                    0)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 7),
                                              color: Colors.black
                                                  .withOpacity(0.08),
                                              blurRadius: MySize.getHeight(13),
                                              spreadRadius: MySize.getHeight(2),
                                            ),
                                          ],
                                        ),
                                        child: DropDownTextField(
                                            textStyle: GoogleFonts.lexend(
                                              fontWeight: FontWeight.w400,
                                              fontSize: MySize.getHeight(13),
                                            ),
                                            clearOption: false,
                                            listTextStyle: GoogleFonts.lexend(
                                              fontWeight: FontWeight.w400,
                                              fontSize: MySize.getHeight(13),
                                            ),
                                            textFieldDecoration:
                                                InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelStyle: TextStyle(),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        MySize.getHeight(10)),
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                left: MySize.getWidth(20),
                                                right: MySize.getWidth(10),
                                                //  bottom: size! / 2, // HERE THE IMPORTANT PART
                                              ),
                                            ),
                                            controller: controller
                                                .notificationController,
                                            dropDownItemCount: 6,
                                            onChanged: (index) {
                                              DropDownValueModel dropDownValue =
                                                  index as DropDownValueModel;
                                              controller
                                                      .selectedExpireDay.value =
                                                  int.parse(dropDownValue.value
                                                      .toString());
                                              DropDownValueModel
                                                  dropDownValue1 = index;
                                              controller.selectedExpireName
                                                      .value =
                                                  dropDownValue1.name
                                                      .toString();
                                            },
                                            dropDownList: List.generate(
                                                (controller.days.value < 7 &&
                                                        controller.days.value !=
                                                            0)
                                                    ? controller.days.value
                                                    : controller
                                                        .notificationList
                                                        .length,
                                                (index) => DropDownValueModel(
                                                    name: controller
                                                        .notificationList[index]
                                                        .title,
                                                    value: controller
                                                        .notificationList[index]
                                                        .value))),
                                      ),
                                      Container(
                                        child: IconButton(
                                            onPressed: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );
                                              if (pickedTime != null) {
                                                DateTime parsedTime =
                                                    DateFormat.jm().parse(
                                                        pickedTime
                                                            .format(context)
                                                            .toString());
                                                String formattedTime =
                                                    DateFormat('HH:mm:ss')
                                                        .format(parsedTime);
                                                print(formattedTime);
                                                controller.selectedTime.value =
                                                    pickedTime;
                                              }
                                            },
                                            icon: Icon(
                                              Icons.alarm,
                                              color: Colors.grey,
                                              size: MySize.getHeight(40),
                                            )),
                                      )
                                    ],
                                  ),
                              Spacing.height(20),
                              Text(
                                "Detail",
                                style: GoogleFonts.lexend(
                                    fontWeight: FontWeight.w400,
                                    fontSize: MySize.getHeight(13),
                                    color: Colors.black),
                              ),
                              Spacing.height(12),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 7),
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: MySize.getHeight(13),
                                      spreadRadius: MySize.getHeight(2),
                                    ),
                                  ],
                                ),
                                child: getTextField(
                                    minLine: 1,
                                    maxLine: 5,
                                    fillColor: Colors.white,
                                    isFilled: true,
                                    textInputAction: TextInputAction.newline,
                                    textEditingController:
                                        controller.detailscontroller.value,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    hintText: "Detail",
                                    labelColor: Colors.grey,
                                    textInputType: TextInputType.multiline),
                              ),
                              Spacing.height(MySize.getHeight(30)),
                              Row(
                                children: [
                                  getimageWidget(
                                    image: "camera.png",
                                    Name: "ATTACH IMAGE",
                                    file: "*jpg,png file only",
                                    onTap: () async {
                                      await imagePick(isBill: false);
                                    },
                                  ),
                                  // Spacing.width(MySize.getWidth(17)),
                                  Spacer(),
                                  getpdfWidget(
                                    image: "bill.png",
                                    Name: "ATTACH BILL",
                                    file: "*pdf,jpg,png file only",
                                    onTap: () async {
                                      await billPick(isBill: true);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String getExpiryDateString() {
    DateTime n = DateTime(
      controller.selectedDate.value.year,
      controller.selectedDate.value.month,
      controller.selectedDate.value.day,
      controller.selectedTime.value.hour,
      controller.selectedTime.value.minute,
      controller.selectedDate.value.second,
    ).add(Duration(days: int.parse(controller.durationcontroller.value.text)));
    DateTime finalDate =
        DateTime(n.year, n.month, n.day, n.hour, n.minute, n.second);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(finalDate);
  }

  getimageWidget({
    String Counter = "0",
    String image = "pc.png",
    String Name = "",
    String file = "",
    VoidCallback? onTap,
  }) {
    return Container(
      height: (MySize.isMini) ? MySize.getHeight(250) : MySize.getHeight(200),
      width: (MySize.isMini) ? MySize.getHeight(183) : MySize.getHeight(148),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 7),
          color: Colors.black.withOpacity(0.03),
          blurRadius: MySize.getHeight(13),
          spreadRadius: MySize.getHeight(2),
        ),
      ], borderRadius: BorderRadius.circular(MySize.getHeight(10))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            "image/Rectangle 48.svg",
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 17,
              child: Padding(
                padding: EdgeInsets.all(
                  MySize.getHeight(8.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: (MySize.isMini)
                          ? EdgeInsets.only(top: 15.0)
                          : EdgeInsets.only(top: 2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              "image/Rectangle 49.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            child: (controller.files!.isNotEmpty)
                                ? (controller.files![0] == "null")
                                    ? SvgPicture.asset(
                                        "image/photo.svg",
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: MySize.getHeight(70),
                                        child: Image.file(
                                            File(controller.files!.first)))
                                : SvgPicture.asset(
                                    "image/photo.svg",
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                    ),
                    Spacing.height(10),
                    Center(
                        child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: MySize.getHeight(35),
                        width: MySize.getWidth(100),
                        child: Center(
                            child: Text(
                          "$Name",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(10),
                              color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: appTheme.yellowPrimaryTheme,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    )),
                    Spacing.height(7),
                    Container(
                        child: Center(
                            child: Text(
                      "$file",
                      style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w400,
                          fontSize: MySize.getHeight(10),
                          color: appTheme.appbarTheme),
                    ))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  getpdfWidget({
    String Counter = "0",
    String image = "pc.png",
    String Name = "",
    String file = "",
    VoidCallback? onTap,
  }) {
    return Container(
      height: (MySize.isMini) ? MySize.getHeight(250) : MySize.getHeight(200),
      width: (MySize.isMini) ? MySize.getHeight(183) : MySize.getHeight(148),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 7),
          color: Colors.black.withOpacity(0.03),
          blurRadius: MySize.getHeight(13),
          spreadRadius: MySize.getHeight(2),
        ),
      ], borderRadius: BorderRadius.circular(MySize.getHeight(10))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            "image/Rectangle 48.svg",
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 17,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: (MySize.isMini)
                          ? EdgeInsets.only(top: 15.0)
                          : EdgeInsets.only(top: 2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              "image/Rectangle 49.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            child: (controller.files1!.isNotEmpty)
                                ? (controller.files1![0] == "null")
                                    ? SvgPicture.asset(
                                        "image/bill.svg",
                                        fit: BoxFit.cover,
                                      )
                                    : ((controller.files1!.first.isPDFFileName))
                                        ? Container(
                                            height: MySize.getHeight(70),
                                            child: Image.asset(
                                              imagePath + "pdf.png",
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            height: MySize.getHeight(70),
                                            child: Image.file(
                                                File(controller.files1!.first)),
                                          )
                                : SvgPicture.asset(
                                    "image/bill.svg",
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                    ),
                    Spacing.height(10),
                    Center(
                        child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: MySize.getHeight(35),
                        width: MySize.getWidth(100),
                        child: Center(
                            child: Text(
                          "$Name",
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w400,
                              fontSize: MySize.getHeight(10),
                              color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: appTheme.yellowPrimaryTheme,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    )),
                    Spacing.height(7),
                    Container(
                        child: Center(
                            child: Text(
                      "$file",
                      style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w400,
                          fontSize: MySize.getHeight(10),
                          color: appTheme.appbarTheme),
                    ))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  imagePick({bool isBill = false}) async {
    final result = await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: (isBill) ? ['pdf', 'jpg', 'png'] : ['jpg', 'png'],
    )
        .then((value) {
      controller.files!.value =
          value!.files.map((e) => e.path).cast<String>().toList();
    });
    if (controller.files!.isEmpty) {
      return;
    }
  }

  billPick({bool isBill = false}) async {
    final result = await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: (isBill) ? ['pdf', 'jpg', 'png'] : ['jpg', 'png'],
    )
        .then((value) {
      controller.files1!.value =
          value!.files.map((e) => e.path).cast<String>().toList();
    });
    if (controller.files1!.isEmpty) {
      return;
    }
  }
}

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  // final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_stat_android');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // await _localNotificationService.initialize(
    //   settings,
    //   onSelectNotification: onSelectNotification,
    // );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  // void onSelectNotification(String? payload) {
  //   print('payload $payload');
  //   if (payload != null && payload.isNotEmpty) {
  //     onNotificationClick.add(payload);
  //   }
  // }
}
