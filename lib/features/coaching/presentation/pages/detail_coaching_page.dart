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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailCoachingPage extends StatefulWidget {
  final CoachingEntity coaching;
  const DetailCoachingPage({super.key, required this.coaching});

  @override
  State<DetailCoachingPage> createState() => _DetailCoachingPageState();
}

class _DetailCoachingPageState extends State<DetailCoachingPage> {
  bool isEdit = false;
  late TextEditingController nameController;
  late TextEditingController ktpController;
  late TextEditingController idCardController;
  late TextEditingController sakController;
  late TextEditingController standardController;
  late TextEditingController positionController;
  late TextEditingController statusController;
  late TextEditingController addressController;
  late TextEditingController contactController;
  late TextEditingController emailController;
  late TextEditingController imagesController;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    context.read<CoachingBloc>().add(GetIdHistoryEvent(widget.coaching.id));
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachingBloc, CoachingState>(
      listener: (context, state) {
        // Menangani efek samping untuk loading dan snackbar/error
        if (state is UpdateCoachingLoading ||
            state is DeleteCoachingLoading) {
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
          isEdit ? 'StringResources.employeEditPage' : widget.coaching.name,
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
                    'StringResources.eActive',
                    style: blackTextstyle.copyWith(
                      fontSize: 14,
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
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: ktpController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: idCardController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: sakController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: standardController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: positionController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: statusController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: addressController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: contactController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: emailController,
          label: 'StringResources',
          enabled: isEdit,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void setData() {
    nameController = TextEditingController(text: widget.coaching.name);
    ktpController = TextEditingController(text: widget.coaching.ktp);
    idCardController = TextEditingController(text: widget.coaching.idCard);
    sakController = TextEditingController(text: widget.coaching.sak);
    standardController = TextEditingController(text: widget.coaching.standard);
    positionController = TextEditingController(text: widget.coaching.position);
    statusController = TextEditingController(text: widget.coaching.status);
    addressController = TextEditingController(text: widget.coaching.address);
    contactController = TextEditingController(text: widget.coaching.contact);
    emailController = TextEditingController(text: widget.coaching.email);
    imagesController = TextEditingController(text: widget.coaching.images);
    isActive = widget.coaching.isActive;
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit; // Toggle antara edit dan view mode
    });
  }

  void saveChanges() {
    final coaching = CoachingEntity(
      id: widget.coaching.id,
      ktp: ktpController.text,
      idCard: idCardController.text,
      name: nameController.text,
      sak: sakController.text,
      standard: standardController.text,
      isActive: isActive,
      position: positionController.text,
      status: statusController.text,
      address: addressController.text,
      contact: contactController.text,
      email: emailController.text,
      images: imagesController.text,
      isDeleted: widget.coaching.isDeleted,
      createdOn: widget.coaching.createdOn,
      updatedOn: DateTime.now().toIso8601String(),
    );
    context.read<CoachingBloc>().add(UpdateCoachingEvent(coaching));
  }
}
