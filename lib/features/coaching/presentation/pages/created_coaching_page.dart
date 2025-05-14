import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_botton.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_bloc.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_event.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_state.dart';
import 'package:coachup/features/coaching/presentation/widget/view_add_student.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatedCoachingPage extends StatefulWidget {
  const CreatedCoachingPage({super.key});

  @override
  State<CreatedCoachingPage> createState() => _CreatedCoachingPageState();
}

class _CreatedCoachingPageState extends State<CreatedCoachingPage> {
  bool isSubmit = false;
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
  List<StudentEntity> student = [];
  List<StudentEntity> resultStudent = [];
  StudentEntity? selectedStudent;

  @override
  void initState() {
    super.initState();
    context.read<CoachingBloc>().add(GetStudentCEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachingBloc, CoachingState>(
      listener: (context, state) {
        if (state is CreateCoachingLoading || state is CreateCoachingLoading) {
          LoadingDialog.show(context);
        } else if (state is CreateCoachingSuccess) {
          LoadingDialog.hide(context);
          context.showSuccesSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
          Future.delayed(const Duration(milliseconds: 2500), () {
            AppNavigator.pop();
          });
        } else if (state is CreateCoachingFailure) {
          LoadingDialog.hide(context);
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        } else if (state is GetStudentCFailure) {
          LoadingDialog.hide(context);
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: BlocBuilder<CoachingBloc, CoachingState>(
        builder: (context, state) {
          if (state is GetStudentCLoaded) {
            student = state.student;
            LoadingDialog.hide(context);
          }
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
                controller: nameCtr,
                label: StringResources.cName,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: topicCtr,
                label: StringResources.cTopic,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: materiCtr,
                label: StringResources.cMateri,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomDateField(
                controller: dateCtr,
                label: StringResources.cDate,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTimeField(
                      controller: startTimeCtr,
                      label: StringResources.cStartTime,
                    ),
                  ),
                  const SizedBox(width: 16), // Jarak antar field
                  Expanded(
                    child: CustomTimeField(
                      controller: finishTimeCtr,
                      label: StringResources.cFinishTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomSearchField(
                label: 'Pilih Siswa',
                value: selectedStudent,
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
                                    setState(() {
                                      resultStudent.removeWhere(
                                          (student) => student.id == e.id);
                                    });
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
                isDescription: true,
                lines: 3,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: descriptionCtr,
                label: StringResources.cDesc,
                isDescription: true,
                lines: 5,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: picNameCtr,
                label: StringResources.cPicName,
                onChanged: (value) {
                  checkingInput(value);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: picCollageCtr,
                label: StringResources.cPicCollage,
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
    String resultMembers = resultStudent.map((e) => e.id).join(', ');
    final coaching = CoachEntity(
      id: '', // Akan digenerate UUID di repository
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
      createdOn: DateTime.now().toIso8601String(),
      updatedOn: DateTime.now().toIso8601String(),
    );
    context.read<CoachingBloc>().add(CreateCoachingEvent(coaching));
  }

  bool chengigData() {
    bool result = false;
    if (nameCtr.text.isNotEmpty &&
        topicCtr.text.isNotEmpty &&
        materiCtr.text.isNotEmpty &&
        dateCtr.text.isNotEmpty &&
        startTimeCtr.text.isNotEmpty &&
        finishTimeCtr.text.isNotEmpty &&
        picCollageCtr.text.isNotEmpty &&
        picNameCtr.text.isNotEmpty &&
        resultStudent.isNotEmpty) {
      result = true;
    } else {
      snackbarError('Mohon isi semua data');
    }
    return result;
  }

  void snackbarError(String message) {
    return context.showErrorSnackBar(
      message,
      onNavigate: () {}, // bottom close
    );
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
}
