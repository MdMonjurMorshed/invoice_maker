import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swad_electric__bill_maker/controllers/controller/form_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/internet_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/message_send_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/print_controller.dart';
import 'package:swad_electric__bill_maker/controllers/controller/radio_button_controller.dart';
import 'package:swad_electric__bill_maker/themes/app_theme.dart';

import '../controllers/services/print_file.dart';
// import 'package:swad_electric__bill_maker/view/available_bluetooth_device.dart';

// import '../controllers/services/get_device_message.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final internetController = Get.find<InternetController>();
    final radioController = Get.find<RadioButtonController>();
    final formController = Get.find<FormController>();
    final printController = Get.find<PrintController>();
    final messageSendController = Get.find<MessageSendController>();
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    final formContainerHeight = mediaHeight / 15;
    final formContainerWidth = mediaWidth / 1.1;
    return Obx(() => WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(mediaHeight / 11),
            child: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(top: 26),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Swad Enterprize > Bill Maker',
                  style: AppTheme.appText.appBarTitle,
                ),
              ),
              centerTitle: true,
            ),

            // AppBar(
            //   title: Text(
            //     'Messers Swad Enterprize',
            //     style: AppTheme.appText.appBarTitle,
            //   ),
            //   centerTitle: true,
            // ),
          ),
          body: internetController.internetIsActive.value
              ? SizedBox(
                  height: mediaHeight / 1.19,
                  child: SingleChildScrollView(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // utility bill start
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Utility Bill",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: formContainerHeight,
                            width: formContainerWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Radio(
                                          fillColor: MaterialStateProperty.all(
                                              AppTheme
                                                  .appColor.radioActiveColor),
                                          activeColor: AppTheme
                                              .appColor.radioActiveColor,
                                          value:
                                              radioController.utilityBillDesco,
                                          groupValue: radioController
                                              .utilityBillSelected.value,
                                          onChanged: (value) {
                                            radioController.utilityBillSelected
                                                .value = value!;
                                            formController
                                                .getCustomerSupport(value);
                                          },
                                        ),
                                      ),
                                      Text(
                                        radioController.utilityBillDesco,
                                        style: AppTheme
                                            .appText.formRadioButtonText,
                                      )
                                    ],
                                  ),
                                ),
                                // RadioMenuButton(
                                //     value: radioController.utilityBillDesco,
                                //     groupValue: radioController
                                //         .utilityBillSelected.value,
                                //     onChanged: (value) {
                                //       radioController
                                //           .utilityBillSelected.value = value!;
                                //     },
                                //     style: ButtonStyle(
                                //       textStyle: >
                                //     ),
                                //     child: Text("DESCO")),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Radio(
                                          fillColor: MaterialStateProperty.all(
                                              AppTheme
                                                  .appColor.radioActiveColor),
                                          activeColor: AppTheme
                                              .appColor.radioActiveColor,
                                          value:
                                              radioController.utilityBillWasa,
                                          groupValue: radioController
                                              .utilityBillSelected.value,
                                          onChanged: (value) {
                                            radioController.utilityBillSelected
                                                .value = value!;
                                            formController
                                                .getCustomerSupport(value);
                                          },
                                        ),
                                      ),
                                      Text(
                                        radioController.utilityBillWasa,
                                        style: AppTheme
                                            .appText.formRadioButtonText,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Radio(
                                          fillColor: MaterialStateProperty.all(
                                              AppTheme
                                                  .appColor.radioActiveColor),
                                          activeColor: AppTheme
                                              .appColor.radioActiveColor,
                                          value: radioController.utilityBillGas,
                                          groupValue: radioController
                                              .utilityBillSelected.value,
                                          onChanged: (value) {
                                            radioController.utilityBillSelected
                                                .value = value!;
                                            formController
                                                .getCustomerSupport(value);
                                          },
                                        ),
                                      ),
                                      Text(
                                        radioController.utilityBillGas,
                                        style: AppTheme
                                            .appText.formRadioButtonText,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),

                        // utility bill end
                        //
                        //account type start
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Account Type",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: formContainerHeight,
                          width: formContainerWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Radio(
                                        fillColor: MaterialStateProperty.all(
                                            AppTheme.appColor.radioActiveColor),
                                        activeColor:
                                            AppTheme.appColor.radioActiveColor,
                                        value:
                                            radioController.accountTypePrepaid,
                                        groupValue: radioController
                                            .accountTypeSelected.value,
                                        onChanged: (value) {
                                          radioController.accountTypeSelected
                                              .value = value!;
                                        },
                                      ),
                                    ),
                                    Text(
                                      radioController.accountTypePrepaid,
                                      style:
                                          AppTheme.appText.formRadioButtonText,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: mediaWidth / 10,
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Radio(
                                        fillColor: MaterialStateProperty.all(
                                            AppTheme.appColor.radioActiveColor),
                                        activeColor:
                                            AppTheme.appColor.radioActiveColor,
                                        value:
                                            radioController.accountTypePostpaid,
                                        groupValue: radioController
                                            .accountTypeSelected.value,
                                        onChanged: (value) {
                                          radioController.accountTypeSelected
                                              .value = value!;
                                        },
                                      ),
                                    ),
                                    Text(
                                      radioController.accountTypePostpaid,
                                      style:
                                          AppTheme.appText.formRadioButtonText,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // Account type end

                        //Account reference start

                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Account Reference",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: mediaHeight / 8,
                            width: formContainerWidth,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Bkash
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.5,
                                            child: Radio(
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      AppTheme.appColor
                                                          .radioActiveColor),
                                              activeColor: AppTheme
                                                  .appColor.radioActiveColor,
                                              value: radioController
                                                  .accountRefferenceBaksh,
                                              groupValue: radioController
                                                  .accountRefferenceSelected
                                                  .value,
                                              onChanged: (value) {
                                                radioController
                                                    .accountRefferenceSelected
                                                    .value = value!;
                                              },
                                            ),
                                          ),
                                          Text(
                                            radioController
                                                .accountRefferenceBaksh,
                                            style: AppTheme
                                                .appText.formRadioButtonText,
                                          )
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: mediaWidth / 10,
                                    // ),

                                    SizedBox(
                                      width: mediaWidth / 5,
                                    ),

                                    // Nagad
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.5,
                                            child: Radio(
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      AppTheme.appColor
                                                          .radioActiveColor),
                                              activeColor: AppTheme
                                                  .appColor.radioActiveColor,
                                              value: radioController
                                                  .accountRefferenceNagad,
                                              groupValue: radioController
                                                  .accountRefferenceSelected
                                                  .value,
                                              onChanged: (value) {
                                                radioController
                                                    .accountRefferenceSelected
                                                    .value = value!;
                                              },
                                            ),
                                          ),
                                          Text(
                                            radioController
                                                .accountRefferenceNagad,
                                            style: AppTheme
                                                .appText.formRadioButtonText,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Rocket
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.5,
                                            child: Radio(
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      AppTheme.appColor
                                                          .radioActiveColor),
                                              activeColor: AppTheme
                                                  .appColor.radioActiveColor,
                                              value: radioController
                                                  .accountRefferenceRocket,
                                              groupValue: radioController
                                                  .accountRefferenceSelected
                                                  .value,
                                              onChanged: (value) {
                                                radioController
                                                    .accountRefferenceSelected
                                                    .value = value!;
                                              },
                                            ),
                                          ),
                                          Text(
                                            radioController
                                                .accountRefferenceRocket,
                                            style: AppTheme
                                                .appText.formRadioButtonText,
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      width: mediaWidth / 5,
                                    ),

                                    // Bank
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.5,
                                            child: Radio(
                                              fillColor:
                                                  MaterialStateProperty.all(
                                                      AppTheme.appColor
                                                          .radioActiveColor),
                                              activeColor: AppTheme
                                                  .appColor.radioActiveColor,
                                              value: radioController
                                                  .accountRefferenceBank,
                                              groupValue: radioController
                                                  .accountRefferenceSelected
                                                  .value,
                                              onChanged: (value) {
                                                radioController
                                                    .accountRefferenceSelected
                                                    .value = value!;
                                              },
                                            ),
                                          ),
                                          Text(
                                            radioController
                                                .accountRefferenceBank,
                                            style: AppTheme
                                                .appText.formRadioButtonText,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),

                        //Account reference end

                        // Account Number starts

                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Account Number",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),

                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: formContainerHeight,
                            width: formContainerWidth,
                            child: TextField(
                              controller:
                                  formController.accountNumberTextController,
                              style: AppTheme.appText.textFieldText,
                              cursorColor:
                                  AppTheme.appColor.textFieldCursorColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              onChanged: (value) {
                                formController.accountNumberText.value = value;
                              },
                            )),

                        // Account number end

                        // Energy cost start

                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Energy Cost",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),

                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: formContainerHeight,
                            width: formContainerWidth,
                            child: TextField(
                              controller:
                                  formController.energyCostTextController,
                              style: AppTheme.appText.textFieldText,
                              cursorColor:
                                  AppTheme.appColor.textFieldCursorColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              onChanged: (value) {
                                formController.energyCostText.value = value;
                                if (double.tryParse(
                                        formController.energyCostText.value) !=
                                    null) {
                                  formController
                                      .totalAmmountText.value = double.parse(
                                          formController.energyCostText.value) +
                                      double.parse(formController
                                          .chargesTextController.text);
                                } else {
                                  formController.totalAmmountText.value =
                                      double.parse(formController
                                          .chargesTextController.text);
                                }
                              },
                              onEditingComplete: () {},
                            )),

                        // Energy cost end

                        // Charges starts

                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Charges",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),

                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: formContainerHeight,
                            width: formContainerWidth,
                            child: TextField(
                              style: AppTheme.appText.textFieldText,
                              readOnly: true,
                              cursorColor:
                                  AppTheme.appColor.textFieldCursorColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              controller: formController.chargesTextController,
                            )),

                        // Charges end

                        // Customer Phone number start

                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Customer Phone Number",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),

                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: formContainerHeight,
                            width: formContainerWidth,
                            child: TextField(
                              controller:
                                  formController.phoneNumberTextController,
                              style: AppTheme.appText.textFieldText,
                              cursorColor:
                                  AppTheme.appColor.textFieldCursorColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              onChanged: (value) {
                                formController.customerPhoneNumberText.value =
                                    value;
                              },
                            )),

                        // Customer Phone number end

                        // Customer Support service start

                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              "Customer Support Service",
                              style: AppTheme.appText.formFieldNameTitle,
                            ),
                          ),
                        ),

                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: formContainerHeight,
                            width: formContainerWidth,
                            child: TextField(
                              style: AppTheme.appText.textFieldText,
                              readOnly: true,
                              cursorColor:
                                  AppTheme.appColor.textFieldCursorColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                              controller:
                                  formController.complainInTextController,
                            )),

                        // Customer Support service End

                        Text(formController.accountNumberText.value),
                        Text(formController.energyCostText.value)
                      ],
                    ),
                  )),
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppTheme.appIcons.internetNotConnectedIcon,
                      size: AppTheme.appIcons.internetNotConnectedIconSize,
                      color: AppTheme.appIcons.internetNotConnectedIconColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Opps!',
                      style: AppTheme.appText.internetNotConnectedText,
                    ),
                    Text(
                      'You do not have internet connection',
                      style: AppTheme.appText.internetNotConnectedText,
                    )
                  ],
                )),
          bottomSheet: internetController.internetIsActive.value
              ? Container(
                  height: mediaHeight / 15,
                  color: AppTheme.appColor.appBarColor,
                  child: Row(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: mediaWidth / 15,
                            ),
                            SizedBox(
                              child: Text(
                                "Total:",
                                style: AppTheme.appText.appBarTitle,
                              ),
                            ),
                            SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: mediaWidth / 10,
                                width: mediaWidth / 4,
                                child: Center(
                                    child: Obx(() => Text(
                                          "${formController.totalAmmountText.value}",
                                          style: AppTheme.appText.textFieldText,
                                        ))),
                              ),
                            ),
                            SizedBox(
                              width: mediaWidth / 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Get.to(
                                //   BlueToothDevicesNearBy(),
                                //   transition: Transition.rightToLeft,
                                // );

                                // await NormalMethodCall.connectDeviceAndPrint();
                                // final bondedDevices = await NormalMethodCall.getBondedDevices();
                                // print("bonded devices are: $bondedDevices");
                                // printController.getBondedDevices();
                                // printController.printSample();
                                // printController
                                //     .printData(printController.selectedDevice!);
                                if (!printController.connectedDevice.value) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext contect) {
                                        return AlertDialog(
                                          title: Text("No Connection"),
                                          content: Text(
                                              "Please connect a printer device first"),
                                          alignment: Alignment.center,
                                          actionsAlignment:
                                              MainAxisAlignment.spaceAround,
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  "ok",
                                                  style: AppTheme
                                                      .appText.yesNoButtonText,
                                                )),
                                          ],
                                        );
                                      });
                                } else {
                                  messageSendController.sendMessage(
                                      radioController.utilityBillSelected.value,
                                      radioController.accountTypeSelected.value,
                                      radioController
                                          .accountRefferenceSelected.value,
                                      formController.accountNumberText.value,
                                      formController.energyCostText.value,
                                      formController.chargesTextController.text,
                                      formController
                                          .complainInTextController.text,
                                      formController
                                          .customerPhoneNumberText.value,
                                      formController.totalAmmountText.value
                                          .toString());
                                  messageSendController.getMessageBalance();
                                  // NormalMethodCall.printFormData();
                                  // printController.printEcPos();
                                  // printController.printTicket();
                                  // printController.printSample();
                                  PDFGenerator.generateAndShareThermalPdf(
                                      radioController.utilityBillSelected.value,
                                      radioController.accountTypeSelected.value,
                                      radioController
                                          .accountRefferenceSelected.value,
                                      formController.accountNumberText.value,
                                      formController.energyCostText.value,
                                      formController.chargesTextController.text,
                                      formController
                                          .complainInTextController.text,
                                      formController
                                          .customerPhoneNumberText.value,
                                      formController.totalAmmountText.value
                                          .toString());
                                  radioController.utilityBillSelected.value =
                                      '';
                                  radioController.accountTypeSelected.value =
                                      '';
                                  radioController
                                      .accountRefferenceSelected.value = '';
                                  formController
                                      .accountNumberTextController.text = '';
                                  formController.energyCostTextController.text =
                                      '';
                                  formController
                                      .phoneNumberTextController.text = '';
                                  '';
                                  formController.complainInTextController.text =
                                      '';
                                  formController.totalAmmountText.value =
                                      double.parse(formController
                                          .chargesTextController.text);
                                }
                              },
                              child: Container(
                                height: mediaWidth / 11,
                                width: mediaWidth / 4,
                                child: Center(
                                  child: Text(
                                    'Print',
                                    style: AppTheme.appText.appBarTitle,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2,
                                        color: AppTheme
                                            .appColor.printButtonBorder)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Text(''),
        )));
  }
}
