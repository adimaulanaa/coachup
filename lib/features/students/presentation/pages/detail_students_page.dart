import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_selected_type.dart';
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

class DetailStudentsPage extends StatefulWidget {
  final StudentEntity students;
  const DetailStudentsPage({super.key, required this.students});

  @override
  State<DetailStudentsPage> createState() => _DetailStudentsPageState();
}

class _DetailStudentsPageState extends State<DetailStudentsPage> {
  bool isEdit = false;
  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController classController;
  late TextEditingController collageController;
  late TextEditingController phoneController;
  bool isActive = false;
  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentsBloc, StudentsState>(
      listener: (context, state) {
        // Menangani efek samping untuk loading dan snackbar/error
        if (state is UpdateStudentsLoading || state is DeleteStudentsLoading) {
          // Menampilkan dialog loading jika diperlukan
          LoadingDialog.show(); // Menampilkan loading dialog
        } else if (state is UpdateStudentsSuccess) {
          LoadingDialog.hide(); // Menyembunyikan loading dialog
          isEdit = false;
          context.showSuccesSnackBar(state.message, onNavigate: () {});
        } else if (state is DeleteStudentsSuccess) {
          LoadingDialog.hide(); // Menyembunyikan loading dialog
          isEdit = false;
          context.showSuccesSnackBar(state.message, onNavigate: () {});
          AppNavigator.pop();
        } else if (state is UpdateStudentsFailure) {
          LoadingDialog.hide(); // Menyembunyikan loading dialog
          context.showErrorSnackBar(state.message, onNavigate: () {});
        } else if (state is DeleteStudentsFailure) {
          LoadingDialog.hide(); // Menyembunyikan loading dialog
          context.showErrorSnackBar(state.message, onNavigate: () {});
        }
      },
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          return bodyForm();
        },
      ),
    );
  }

  Widget bodyForm() {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          isEdit ? StringResources.studentEdited : nameController.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: blackTextstyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomInkWell(
                      onTap: () {
                        String id = widget.students.id;
                        context
                            .read<StudentsBloc>()
                            .add(DeleteStudentsEvent(id));
                      },
                      child: SelectedTypeView(
                        text: 'Delete',
                        type: 1,
                        iconPath: MediaRes.deletedStudent,
                        widthIc: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomInkWell(
                      onTap: () {
                        if (isEdit) {
                          saveChanges(); // Simpan perubahan jika dalam mode edit
                        } else {
                          toggleEdit(); // Aktifkan mode edit
                        }
                      },
                      child: SelectedTypeView(
                        text: isEdit ? StringResources.saved : StringResources.edited,
                        iconPath: isEdit ? MediaRes.saved : MediaRes.edited,
                        type: 2,
                        widthIc: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringResources.sActive,
                    style: blackTextstyle.copyWith(
                      fontSize: 15,
                      fontWeight: medium,
                    ),
                  ),
                  Switch(
                    value: isActive,
                    activeColor: AppColors.primary,
                    inactiveTrackColor: AppColors.bgGrey,
                    onChanged: isEdit
                        ? (val) {
                            setState(() {
                              isActive = val;
                            });
                          }
                        : null,
                  )
                ],
              ),
              buildEditForm(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: nameController,
          label: StringResources.sName,
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: classController,
          label: StringResources.sClass,
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GenderButton(
                gender: StringResources.male,
                selectedGender: selectedGender,
                enabled: isEdit,
                onSelect: handleGenderSelect,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GenderButton(
                gender: StringResources.female,
                selectedGender: selectedGender,
                enabled: isEdit,
                onSelect: handleGenderSelect,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: collageController,
          label: StringResources.sCollage,
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: phoneController,
          label: StringResources.sPhone,
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void setData() {
    idController = TextEditingController(text: widget.students.id);
    nameController = TextEditingController(text: widget.students.name);
    classController = TextEditingController(text: widget.students.studentClass);
    collageController = TextEditingController(text: widget.students.collage);
    phoneController = TextEditingController(text: widget.students.phone);
    if (widget.students.gender == StringResources.male) {
      selectedGender = StringResources.male;
    } else if (widget.students.gender == StringResources.female) {
      selectedGender = StringResources.female;
    }
    if (widget.students.active == 'true') {
      isActive = true;
    } else {
      isActive = false;
    }
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit; // Toggle antara edit dan view mode
    });
  }

  void handleGenderSelect(String gender) {
    if (isEdit) {
      setState(() {
        selectedGender = gender;
      });
    }
  }

  void saveChanges() {
    final students = StudentEntity(
      id: widget.students.id,
      name: nameController.text,
      studentClass: classController.text,
      gender: selectedGender,
      collage: collageController.text,
      phone: phoneController.text,
      active: isActive ? 'true' : 'false',
      createdOn: widget.students.createdOn,
      updatedOn: DateTime.now().toIso8601String(),
    );
    context.read<StudentsBloc>().add(UpdateStudentsEvent(students));
  }
}
