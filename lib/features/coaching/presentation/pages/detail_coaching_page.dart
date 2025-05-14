import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/domain/entities/detail_coaching_entity.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_bloc.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_event.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_state.dart';
import 'package:coachup/features/coaching/presentation/widget/view_add_student.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
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
  final TextEditingController idCtr = TextEditingController();
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController topicCtr = TextEditingController();
  final TextEditingController materiCtr = TextEditingController();
  final TextEditingController dateCtr = TextEditingController();
  final TextEditingController startTimeCtr = TextEditingController();
  final TextEditingController finishTimeCtr = TextEditingController();
  final TextEditingController picNameCtr = TextEditingController();
  final TextEditingController picCollageCtr = TextEditingController();
  final TextEditingController activityCtr = TextEditingController();
  final TextEditingController descriptionCtr = TextEditingController();
  DetailCoachingEntity detail = DetailCoachingEntity();
  List<StudentEntity> student = [];
  List<StudentEntity> resultStudent = [];
  StudentEntity? selectedStudent;

  @override
  void initState() {
    super.initState();
    context.read<CoachingBloc>().add(DetailCoachingEvent(widget.coaching.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachingBloc, CoachingState>(
      listener: (context, state) {
        // Menangani efek samping untuk loading dan snackbar/error
        if (state is UpdateCoachingLoading ||
            state is DeleteCoachingLoading ||
            state is DetailCoachingLoading) {
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
          if (state is DetailCoachingLoaded) {
            detail = state.detail;
            LoadingDialog.hide(context);
            setData();
          }
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: nameCtr,
                label: StringResources.cName,
                enabled: isEdit,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: topicCtr,
                label: StringResources.cTopic,
                enabled: isEdit,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: materiCtr,
                label: StringResources.cMateri,
                enabled: isEdit,
              ),
              const SizedBox(height: 16),
              CustomDateField(
                controller: dateCtr,
                label: StringResources.cDate,
                enabled: isEdit,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTimeField(
                      controller: startTimeCtr,
                      label: StringResources.cStartTime,
                      enabled: isEdit,
                    ),
                  ),
                  const SizedBox(width: 16), // Jarak antar field
                  Expanded(
                    child: CustomTimeField(
                      controller: finishTimeCtr,
                      label: StringResources.cFinishTime,
                      enabled: isEdit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomSearchField(
                label: 'Pilih Siswa',
                value: selectedStudent,
                enabled: isEdit,
                items: student,
                onChanged: (val) {
                  setDataSelect(val);
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: resultStudent.isNotEmpty
                    ? Column(
                        children: resultStudent.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey, // Ganti warna jika perlu
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.name,
                                    style: blackTextstyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: medium,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                CustomInkWell(
                                  onTap: () {
                                    if (isEdit) {
                                      setState(() {
                                        resultStudent.removeWhere(
                                            (student) => student.id == e.id);
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Center(
                        child: Text(
                          'Pilih dahulu murid dari list',
                          style: blackTextstyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: activityCtr,
                label: StringResources.cActivity,
                enabled: isEdit,
                isDescription: true,
                lines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: descriptionCtr,
                label: StringResources.cDesc,
                enabled: isEdit,
                isDescription: true,
                lines: 5,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: picNameCtr,
                label: StringResources.cPicName,
                enabled: isEdit,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: picCollageCtr,
                label: StringResources.cPicCollage,
                enabled: isEdit,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void setData() {
    idCtr.text = detail.id ?? '';
    nameCtr.text = detail.name ?? '';
    topicCtr.text = detail.topic ?? '';
    materiCtr.text = detail.learning ?? '';
    dateCtr.text = detail.date ?? '';
    startTimeCtr.text = detail.timeStart ?? '';
    finishTimeCtr.text = detail.timeFinish ?? '';
    picNameCtr.text = detail.picName ?? '';
    picCollageCtr.text = detail.picCollage ?? '';
    activityCtr.text = detail.activity ?? '';
    descriptionCtr.text = detail.description ?? '';
    student = detail.allStudent;
    resultStudent = detail.members;
  }

  void setDataSelect(StudentEntity? val) {
    if (val != null) {
      selectedStudent = val;
      final alreadyExists = resultStudent.any((e) => e.id == val.id);
      if (!alreadyExists) {
        resultStudent.add(val);
      } else {
        snackbarError('Murid sudah terdaftar');
      }
      setState(() {});
    }
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit; // Toggle antara edit dan view mode
    });
  }

  void snackbarError(String message) {
    return context.showErrorSnackBar(
      message,
      onNavigate: () {}, // bottom close
    );
  }

  void saveChanges() {
    String resultMembers = resultStudent.map((e) => e.id).join(', ');
    final coaching = CoachEntity(
      id: idCtr.text, 
      name: nameCtr.text,
      topic: topicCtr.text,
      learning: materiCtr.text,
      date: dateCtr.text,
      timeStart: startTimeCtr.text,
      timeFinish: finishTimeCtr.text,
      members: resultMembers,
      picName: picNameCtr.text,
      picCollage: picCollageCtr.text,
      activity: activityCtr.text,
      description: descriptionCtr.text,
      createdOn: detail.createdOn ?? DateTime.now().toIso8601String(),
      updatedOn: DateTime.now().toIso8601String(),
    );
    context.read<CoachingBloc>().add(UpdateCoachingEvent(coaching));
  }
}
