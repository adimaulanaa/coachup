import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_botton.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_bloc.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_event.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreatedPrivatesPage extends StatefulWidget {
  const CreatedPrivatesPage({super.key});

  @override
  State<CreatedPrivatesPage> createState() => _CreatedPrivatesPageState();
}

class _CreatedPrivatesPageState extends State<CreatedPrivatesPage> {
  late PrivatesBloc _privatesBloc;
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController inputCtr = TextEditingController();
  final TextEditingController descriptionCtr = TextEditingController();
  final TextEditingController dateCtr = TextEditingController();
  final inputFocusNode = FocusNode();
  bool isMurid = false;
  bool isSubmited = false;
  List<String> listMurid = [];

  @override
  void initState() {
    super.initState();
    _privatesBloc = context.read<PrivatesBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringResources.prCreated,
          style: blackTextstyle.copyWith(
            fontSize: 20,
            fontWeight: medium,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<PrivatesBloc, PrivatesState>(
        listener: (context, state) {
          if (state is CreatedPrivatesLoading) {
            LoadingDialog.show();
          } else if (state is CreatedPrivatesSuccess) {
            LoadingDialog.hide();
            context.showSuccesSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
            AppNavigator.pop(context);
          } else if (state is CreatedPrivatesFailure) {
            LoadingDialog.hide();
            context.showSuccesSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
          }
        },
        child: BlocBuilder<PrivatesBloc, PrivatesState>(
          builder: (context, state) {
            return bodyForm();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isSubmited
          ? CustomButton(
              onTap: () {
                created();
              },
              margin: 20,
              label: 'Simpan',
            )
          : const SizedBox.shrink(),
    );
  }

  Widget bodyForm() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameCtr,
              label: StringResources.prName,
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
            CustomTextField(
              controller: descriptionCtr,
              label: StringResources.prDesc,
              isDescription: true,
              lines: 5,
              onChanged: (value) {
                checkingInput(value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextStudentField(
                    controller: inputCtr,
                    focus: inputFocusNode,
                    label: StringResources.prStudent,
                    onChanged: (value) {
                      checkingInput(value);
                    },
                    onSubmitted: (value) {
                      addMurid();
                    },
                  ),
                ),
                SizedBox(width: 10),
                CustomInkWell(
                  onTap: () {
                    addMurid();
                  },
                  child: SvgPicture.asset(
                    MediaRes.addStudent,
                    // ignore: deprecated_member_use
                    color: AppColors.primary,
                    width: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isMurid ? listMuridView() : SizedBox.shrink(),
            SizedBox(height: size.height * 0.11),
          ],
        ),
      ),
    );
  }

  Widget listMuridView() {
    return Column(
      children: listMurid.map((e) {
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
                  e,
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
                    listMurid.remove(e);
                  });
                },
                child: SvgPicture.asset(
                  MediaRes.closeCircle,
                  // ignore: deprecated_member_use
                  color: AppColors.bgGreySecond,
                  width: 20,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void checkingInput(String value) {
    if (nameCtr.text.isNotEmpty && dateCtr.text.isNotEmpty) {
      isSubmited = true;
    } else {
      isSubmited = false;
    }
    setState(() {});
  }

  void addMurid() {
    bool checking = listMurid.contains(inputCtr.text);
    if (!checking) {
      listMurid.add(inputCtr.text);
    } else {
      context.showErrorSnackBar(
        'Nama Sudah Ada!',
        onNavigate: () {}, // bottom close
      );
    }
    if (listMurid.isNotEmpty) {
      isMurid = true;
    } else {
      isMurid = false;
    }
    inputCtr.clear();

    // Fokus kembali ke input
    FocusScope.of(context).requestFocus(inputFocusNode);
    setState(() {});
  }

  void created() {
    String resultMembers = listMurid.map((e) => e).join(', ');
    PrivatesEntity model = PrivatesEntity(
      id: '',
      name: nameCtr.text,
      description: descriptionCtr.text,
      date: dateCtr.text,
      student: resultMembers,
      studentId: '',
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
    _privatesBloc.add(CreatePrivatesEvent(model));
  }
}
