import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/empty_list_data.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_bloc.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_event.dart';
import 'package:coachup/features/coaching/presentation/bloc/coaching_state.dart';
import 'package:coachup/features/coaching/presentation/pages/created_coaching_page.dart';
import 'package:coachup/features/coaching/presentation/pages/detail_coaching_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CoachingPage extends StatefulWidget {
  const CoachingPage({super.key});

  @override
  State<CoachingPage> createState() => _CoachingPageState();
}

class _CoachingPageState extends State<CoachingPage> {
  List<CoachEntity> coaching = [];
  List<CoachEntity> filterCoaching = [];
  TextEditingController searchController = TextEditingController();
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<CoachingBloc>().add(GetCoachingEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoachingBloc, CoachingState>(
      listener: (context, state) {
        if (state is GetCoachingLoading) {
          LoadingDialog.show(context);
        } else if (state is GetCoachingFailure) {
          LoadingDialog.hide(context);
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: BlocBuilder<CoachingBloc, CoachingState>(
        builder: (context, state) {
          if (state is GetCoachingLoaded) {
            coaching = state.coaching;
            if (!initialized) {
              filterCoaching = coaching;
              initialized = true;
            }
            LoadingDialog.hide(context);
          }
          return bodyForm();
        },
      ),
    );
  }

  Widget bodyForm() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringResources.coach,
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
                        hintText: 'Cari Nama Sekolah...',
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
              filterCoaching.isNotEmpty
                  ? Column(
                      children: filterCoaching.map((e) {
                        return listCoaching(size, e);
                      }).toList(),
                    )
                  : EmptyListData(
                      size: size,
                      message: 'Tidak ada data Pelatihan',
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listCoaching(Size size, CoachEntity e) {
    DateTime parsedDate = DateTime.parse(e.date);
    String formattedDate = DateFormat('d MMMM yyyy').format(parsedDate);
    int member = 0;
    if (e.members != '') {
      member = e.members.split(',').length;
    }
    return CustomInkWell(
      onTap: () async {
        // Melakukan navigasi ke halaman detail
        await AppNavigator.push(
          DetailCoachingPage(coaching: e),
          transition: TransitionType.fade,
        );
        if (mounted) {
          initialized = false; // reset biar filter di-refresh
          // Lakukan refresh atau panggil event untuk mengambil data coaching
          context.read<CoachingBloc>().add(GetCoachingEvent());
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
                    e.picCollage,
                    style: blackTextstyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$formattedDate, ${e.timeStart} - ${e.timeFinish}',
                    style: blackTextstyle.copyWith(
                      fontSize: 13,
                      fontWeight: medium,
                    ),
                  ),
                  Text(
                    e.topic,
                    style: blackTextstyle.copyWith(
                      fontSize: 13,
                      fontWeight: medium,
                    ),
                  ),
                  Text(
                    'Member : $member murid',
                    style: blackTextstyle.copyWith(
                      fontSize: 13,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Deskripsi : ${e.description}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
      const CreatedCoachingPage(),
      transition: TransitionType.fade,
    );
    if (mounted) {
      initialized = false; // reset biar filter di-refresh
      context.read<CoachingBloc>().add(GetCoachingEvent());
    }
  }

  void search(String query) {
    final lowerCaseQuery = query.toLowerCase(); // Pencarian berdasarkan nama
    filterCoaching = [];
    if (lowerCaseQuery.isEmpty) {
      filterCoaching = coaching;
    } else {
      filterCoaching = coaching
          .where((e) => e.picCollage.toLowerCase().contains(lowerCaseQuery))
          .toList();
    }
    setState(() {});
  }
}
