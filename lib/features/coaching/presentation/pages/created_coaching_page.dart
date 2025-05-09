import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/custom_botton.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_bloc.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_event.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatedCoachingPage extends StatefulWidget {
  const CreatedCoachingPage({super.key});

  @override
  State<CreatedCoachingPage> createState() => _CreatedCoachingPageState();
}

class _CreatedCoachingPageState extends State<CreatedCoachingPage> {
  bool isSubmit = false;
  bool isNFC = false;
  String isNFCMessage = '';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController sakController = TextEditingController();
  final TextEditingController standardController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController imagesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachingBloc, CoachingState>(
      listener: (context, state) {
        if (state is CreateCoachingLoading) {
          LoadingDialog.show(context);
        } else if (state is CreateCoachingSuccess) {
          LoadingDialog.hide(context);
          context.showSuccesSnackBar(
            'StringResources.loadCreatedSuccess',
            onNavigate: () {}, // bottom close
          );
        } else if (state is CreateCoachingFailure) {
          LoadingDialog.hide(context);
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: bodyForm(),
    );
  }

  Scaffold bodyForm() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'StringResources.employeCreatedPage',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: blackTextstyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                controller: nameController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: ktpController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: idCardController,
                label: 'StringResources',
                enabled: false,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: sakController,
                label: 'StringResources',
                enabled: false,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: standardController,
                label: 'StringResources',
                enabled: false,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: positionController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: statusController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: addressController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: contactController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                label: 'StringResources',
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              SizedBox(height: size.height * 0.15),
            ],
          ),
        ),
      ),
      floatingActionButton: isSubmit
          ? CustomButton(
              onTap: () {
                if (chengigData()) {
                  created();
                }
              },
              margin: 20,
              label: 'Simpan',
            )
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void checkingInput(String value) {
    if (value.isNotEmpty) {
      isSubmit = true;
    } else {
      isSubmit = false;
    }
    setState(() {});
  }

  void created() {
    final coaching = CoachingEntity(
      id: '', // Akan digenerate UUID di repository
      ktp: ktpController.text,
      idCard: idCardController.text,
      name: nameController.text,
      sak: sakController.text,
      standard: standardController.text,
      isActive: true,
      position: positionController.text,
      status: statusController.text,
      address: addressController.text,
      contact: contactController.text,
      email: emailController.text,
      images: '',
      isDeleted: false,
      createdOn: DateTime.now().toIso8601String(),
      updatedOn: DateTime.now().toIso8601String(),
    );
    context.read<CoachingBloc>().add(CreateCoachingEvent(coaching));
  }

  bool chengigData() {
    bool result = true;
    if (ktpController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        idCardController.text.isNotEmpty &&
        sakController.text.isNotEmpty &&
        standardController.text.isNotEmpty &&
        positionController.text.isNotEmpty &&
        statusController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      result = true;
    }
    return result;
  }

  void snackbarError(String message) {
    return context.showErrorSnackBar(
      message,
      onNavigate: () {}, // bottom close
    );
  }
}
