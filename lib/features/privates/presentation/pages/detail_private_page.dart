import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_bloc.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_event.dart';
import 'package:coachup/features/privates/presentation/bloc/privates_state.dart';
import 'package:coachup/features/privates/presentation/widgets/widgets_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPrivatePage extends StatefulWidget {
  final PrivatesEntity private;
  const DetailPrivatePage({super.key, required this.private});

  @override
  State<DetailPrivatePage> createState() => _DetailPrivatePageState();
}

class _DetailPrivatePageState extends State<DetailPrivatePage> {
  late PrivatesBloc _privatesBloc;
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController inputCtr = TextEditingController();
  final TextEditingController descriptionCtr = TextEditingController();
  final TextEditingController dateCtr = TextEditingController();
  final inputFocusNode = FocusNode();
  PrivatesEntity private = PrivatesEntity();
  bool isEdit = false;
  bool isMurid = false;
  bool isSubmited = false;
  bool isInitialized = false;
  List<String> listMurid = [];

  @override
  void initState() {
    super.initState();
    nameCtr.text = widget.private.name ?? '';
    _privatesBloc = context.read<PrivatesBloc>();
    _privatesBloc.add(GetPrivatesEvent(widget.private.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          isEdit ? StringResources.prEdited : nameCtr.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: blackTextstyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
      ),
      body: BlocListener<PrivatesBloc, PrivatesState>(
        listener: (context, state) {
          if (state is GetPrivatesLoading ||
              state is UpdatePrivatesLoading ||
              state is DeletePrivatesLoading) {
            LoadingDialog.show(context);
          } else if (state is UpdatePrivatesSuccess) {
            // LoadingDialog.hide(context);
            isInitialized = false;
            isEdit = false;
            _privatesBloc.add(GetPrivatesEvent(widget.private.id.toString()));
          } else if (state is GetPrivatesLoaded) {
            if (!isInitialized) {
              private = state.data;
              setDataValue(state.data);
              isInitialized = true;
            }
            LoadingDialog.hide(context);
          } else if (state is DeletePrivatesSuccess) {
            LoadingDialog.hide(context);
            AppNavigator.pop(context);
          } else if (state is GetPrivatesFailure) {
            LoadingDialog.hide(context);
            context.showSuccesSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
          } else if (state is UpdatePrivatesFailure) {
            LoadingDialog.hide(context);
            context.showSuccesSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
          } else if (state is DeletePrivatesFailure) {
            LoadingDialog.hide(context);
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
    );
  }

  Widget bodyForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          selectedType(),
          const SizedBox(height: 16),
          CustomTextField(
            controller: nameCtr,
            label: StringResources.prName,
            enabled: isEdit,
            onChanged: (value) {
              checkingInput(value);
            },
          ),
          const SizedBox(height: 16),
          CustomDateField(
            controller: dateCtr,
            label: StringResources.cDate,
            enabled: isEdit,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: descriptionCtr,
            label: StringResources.prDesc,
            enabled: isEdit,
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
                  enabled: isEdit,
                  onChanged: (value) {
                    checkingInput(value);
                  },
                  onSubmitted: (value) {
                    addMurid();
                  },
                ),
              ),
              SizedBox(width: 5),
              CustomInkWell(
                onTap: () {
                  addMurid();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.bgGreySecond, // Placeholder warna
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, size: 40, color: AppColors.bgColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isMurid ? listMuridView() : SizedBox.shrink(),
          const SizedBox(height: 16),
        ],
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
                  if (isEdit) {
                    setState(() {
                      listMurid.remove(e);
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
    );
  }

  Widget selectedType() {
    return Row(
      children: [
        Expanded(
          child: CustomInkWell(
            onTap: () async {
              // await savePdfToDownload(context, detail);
            },
            child: viewSelectedType('Download PDF', 1),
          ),
        ),
        Expanded(
          child: CustomInkWell(
            onTap: () {
              String id = private.id ?? '';
              _privatesBloc.add(DeletePrivatesEvent(id));
            },
            child: viewSelectedType('Deleted', 0),
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
            child: viewSelectedType(isEdit ? 'Saved' : 'Edited', 2),
          ),
        ),
      ],
    );
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit; // Toggle antara edit dan view mode
    });
  }

  void saveChanges() {
    String resultMembers = listMurid.map((e) => e).join(', ');
    PrivatesEntity model = PrivatesEntity(
      id: private.id,
      name: nameCtr.text,
      description: descriptionCtr.text,
      date: dateCtr.text,
      student: resultMembers,
      studentId: '',
      createdOn: private.createdOn,
      updatedOn: DateTime.now(),
    );
    _privatesBloc.add(UpdatePrivatesEvent(model));
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

  void checkingInput(String value) {
    if (nameCtr.text.isNotEmpty && dateCtr.text.isNotEmpty) {
      isSubmited = true;
    } else {
      isSubmited = false;
    }
  }

  void setDataValue(PrivatesModel data) {
    nameCtr.text = data.name ?? '';
    dateCtr.text = data.date ?? '';
    descriptionCtr.text = data.description ?? '';
    listMurid = data.student
            ?.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];
    isMurid = listMurid.isNotEmpty;
  }
}
