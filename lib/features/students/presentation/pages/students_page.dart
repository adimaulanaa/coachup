import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/empty_list_data.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:coachup/features/students/presentation/bloc/students_bloc.dart';
import 'package:coachup/features/students/presentation/bloc/students_event.dart';
import 'package:coachup/features/students/presentation/bloc/students_state.dart';
import 'package:coachup/features/students/presentation/pages/created_students_page.dart';
import 'package:coachup/features/students/presentation/pages/detail_students_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  List<StudentEntity> students = [];
  List<StudentEntity> filterStudents = [];
  TextEditingController searchController = TextEditingController();
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<StudentsBloc>().add(GetStudentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is GetStudentsLoading) {
          LoadingDialog.show();
        } else if (state is GetStudentsFailure) {
          LoadingDialog.hide();
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is GetStudentsLoaded) {
            students = state.students;
            if (!initialized) {
              filterStudents = students;
              initialized = true;
            }
            LoadingDialog.hide();
          }
          return bodyForm(size);
        },
      ),
    );
  }

  Widget bodyForm(Size size) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringResources.student,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: blackTextstyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    // Membungkus TextFormField dengan Expanded untuk memberi ruang
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari Nama...',
                        hintStyle: transTextstyle.copyWith(
                          fontSize: 16,
                          fontWeight: light,
                          color: AppColors.bgGreySecond,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        filled: true,
                        fillColor:
                            Colors.white, // Pastikan fillColor juga putih
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            MediaRes.warning,
                            // ignore: deprecated_member_use
                            color: AppColors.bgGreySecond,
                            width: 20,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomInkWell(
                            onTap: () {
                              // Menghapus teks saat diklik
                              searchController.clear();
                              search('');
                            },
                            child: SvgPicture.asset(
                              MediaRes.warning,
                              // ignore: deprecated_member_use
                              color: AppColors.bgGreySecond,
                              width: 20,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 14.0),
                      ),
                      onChanged: (value) {
                        search(value);
                      },
                      maxLines: 1,
                      style: blackTextstyle.copyWith(
                        fontSize: 16,
                        fontWeight: light,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CustomInkWell(
                    onTap: () {
                      navCreated();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Placeholder warna
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.add, size: 30, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              filterStudents.isNotEmpty
                  ? Column(
                      children: filterStudents.map((e) {
                        return listStudents(size, e);
                      }).toList(),
                    )
                  : EmptyListData(
                      size: size,
                      message: 'Tidak ada data Murid',
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listStudents(Size size, StudentEntity e) {
    return CustomInkWell(
      onTap: () async {
        // Melakukan navigasi ke halaman detail
        await AppNavigator.push(
          DetailStudentsPage(students: e),
          transition: TransitionType.fade,
        );
        if (mounted) {
          // Lakukan refresh atau panggil event untuk mengambil data students
          context.read<StudentsBloc>().add(GetStudentsEvent());
        }
      },
      child: Container(
        width: size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.name,
                    style: blackTextstyle.copyWith(
                      fontSize: 15,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${e.studentClass} - ${e.collage}',
                    style: blackTextstyle.copyWith(
                      fontSize: 13,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navCreated() async {
    await AppNavigator.push(
      const CreatedStudentsPage(),
      transition: TransitionType.fade,
    );
    if (mounted) {
      initialized = false; // reset biar filter di-refresh
      context.read<StudentsBloc>().add(GetStudentsEvent());
    }
  }

  void search(String query) {
    final lowerCaseQuery = query.toLowerCase(); // Pencarian berdasarkan nama
    filterStudents = [];
    if (lowerCaseQuery.isEmpty) {
      filterStudents = students;
    } else {
      filterStudents = students
          .where((e) => e.name.toLowerCase().contains(lowerCaseQuery))
          .toList();
    }
    setState(() {});
  }
}
