import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_botton.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:coachup/features/students/presentation/bloc/students_bloc.dart';
import 'package:coachup/features/students/presentation/bloc/students_event.dart';
import 'package:coachup/features/students/presentation/bloc/students_state.dart';
import 'package:coachup/features/students/presentation/widget/gender_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatedStudentsPage extends StatefulWidget {
  const CreatedStudentsPage({super.key});

  @override
  State<CreatedStudentsPage> createState() => _CreatedStudentsPageState();
}

class _CreatedStudentsPageState extends State<CreatedStudentsPage> {
  bool isSubmit = false;
  String selectedGender = '';
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController collageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController activeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is CreateStudentsLoading) {
          LoadingDialog.show();
        } else if (state is CreateStudentsSuccess) {
          LoadingDialog.hide();
          context.showSuccesSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
          Future.delayed(const Duration(milliseconds: 2500), () {
            AppNavigator.pop();
          });
        } else if (state is CreateStudentsFailure) {
          LoadingDialog.hide();
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          return bodyForm();
        },
      ),
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
          StringResources.studentCreated,
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
                label: StringResources.sName,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: classController,
                label: StringResources.sClass,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GenderButton(
                      gender: StringResources.male,
                      selectedGender: selectedGender,
                      enabled: isSubmit,
                      onSelect: handleGenderSelect,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GenderButton(
                      gender: StringResources.female,
                      selectedGender: selectedGender,
                      enabled: isSubmit,
                      onSelect: handleGenderSelect,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: collageController,
                label: StringResources.sCollage,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: phoneController,
                label: StringResources.sPhone,
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
    final students = StudentEntity(
      id: '', // Akan digenerate UUID di repository
      name: nameController.text,
      studentClass: classController.text,
      gender: selectedGender,
      collage: collageController.text,
      phone: phoneController.text,
      active: 'true',
      createdOn: DateTime.now().toIso8601String(),
      updatedOn: DateTime.now().toIso8601String(),
    );
    context.read<StudentsBloc>().add(CreateStudentsEvent(students));
  }

  bool chengigData() {
    bool result = true;
    if (nameController.text.isNotEmpty &&
        classController.text.isNotEmpty &&
        selectedGender.isNotEmpty &&
        collageController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
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

  void handleGenderSelect(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }
}
