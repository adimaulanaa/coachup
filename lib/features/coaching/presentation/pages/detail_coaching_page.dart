import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_bloc.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_event.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_state.dart';
import 'package:coachup/features/coaching/presentation/widget/gender_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailCoachingPage extends StatefulWidget {
  final CoachEntity coaching;
  const DetailCoachingPage({super.key, required this.coaching});

  @override
  State<DetailCoachingPage> createState() => _DetailCoachingPageState();
}

class _DetailCoachingPageState extends State<DetailCoachingPage> {
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
    return BlocListener<CoachingBloc, CoachingState>(
      listener: (context, state) {
        // Menangani efek samping untuk loading dan snackbar/error
        if (state is UpdateCoachingLoading || state is DeleteCoachingLoading) {
          // Menampilkan dialog loading jika diperlukan
          LoadingDialog.show(context); // Menampilkan loading dialog
        } else if (state is UpdateCoachingSuccess) {
          LoadingDialog.hide(context); // Menyembunyikan loading dialog
          isEdit = false;
          context.showSuccesSnackBar(state.message, onNavigate: () {});
        } else if (state is DeleteCoachingSuccess) {
          LoadingDialog.hide(context); // Menyembunyikan loading dialog
          isEdit = false;
          context.showSuccesSnackBar(state.message, onNavigate: () {});
          AppNavigator.pop();
        } else if (state is UpdateCoachingFailure) {
          LoadingDialog.hide(context); // Menyembunyikan loading dialog
          context.showErrorSnackBar(state.message, onNavigate: () {});
        } else if (state is DeleteCoachingFailure) {
          LoadingDialog.hide(context); // Menyembunyikan loading dialog
          context.showErrorSnackBar(state.message, onNavigate: () {});
        }
      },
      child: BlocBuilder<CoachingBloc, CoachingState>(
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
          isEdit ? StringResources.studentEdited : widget.coaching.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: blackTextstyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              String id = widget.coaching.id;
              context.read<CoachingBloc>().add(DeleteCoachingEvent(id));
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                isEdit ? Icons.save : Icons.edit,
              ), // Ganti ikon berdasarkan mode
              onPressed: () {
                if (isEdit) {
                  saveChanges(); // Simpan perubahan jika dalam mode edit
                } else {
                  toggleEdit(); // Aktifkan mode edit
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 16),
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
    // idController = TextEditingController(text: widget.coaching.id);
    // nameController = TextEditingController(text: widget.coaching.name);
    // classController = TextEditingController(text: widget.coaching.studentClass);
    // collageController = TextEditingController(text: widget.coaching.collage);
    // phoneController = TextEditingController(text: widget.coaching.phone);
    // if (widget.coaching.gender == StringResources.male) {
    //   selectedGender = StringResources.male;
    // } else if (widget.coaching.gender == StringResources.female) {
    //   selectedGender = StringResources.female;
    // }
    // if (widget.coaching.active == 'true') {
    //   isActive = true;
    // } else {
    //   isActive = false;
    // }
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
    // final coaching = StudentEntity(
    //   id: widget.coaching.id,
    //   name: nameController.text,
    //   studentClass: classController.text,
    //   gender: selectedGender,
    //   collage: collageController.text,
    //   phone: phoneController.text,
    //   active: isActive ? 'true' : 'false',
    //   createdOn: widget.coaching.createdOn,
    //   updatedOn: DateTime.now().toIso8601String(),
    // );
    // context.read<CoachingBloc>().add(UpdateCoachingEvent(coaching));
  }
}
