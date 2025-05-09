import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
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

class CoachingPage extends StatefulWidget {
  const CoachingPage({super.key});

  @override
  State<CoachingPage> createState() => _CoachingPageState();
}

class _CoachingPageState extends State<CoachingPage> {
  List<CoachingEntity> coachings = [];
  List<CoachingEntity> filterCoachings = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CoachingBloc>().add(GetCoachingEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            coachings = state.coachings;
            filterCoachings = coachings;
            LoadingDialog.hide(context);
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
          'StringResources.employePage',
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
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
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
                  InkWell(
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
              filterCoachings.isNotEmpty
                  ? Column(
                      children: filterCoachings.map((e) {
                        return listCoaching(size, e);
                      }).toList(),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget listCoaching(Size size, CoachingEntity e) {
    return InkWell(
      onTap: () async {
        // Melakukan navigasi ke halaman detail
        await AppNavigator.push(
          DetailCoachingPage(coaching: e),
          transition: TransitionType.fade,
        );
        if (mounted) {
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
            // Kotak untuk foto
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Placeholder warna
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: e.isActive
                      ? AppColors.bgTrans
                      : AppColors.bgGreySecond, // Warna border merah
                  width: 2, // Ketebalan border
                ),
              ),
              child: const Icon(Icons.person, size: 30, color: Colors.grey),
            ),
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
                    e.position, // Pastikan ada field subtitle
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
    // Melakukan navigasi ke halaman detail
    await AppNavigator.push(
      const CreatedCoachingPage(),
      transition: TransitionType.fade,
    );
    if (mounted) {
      // Lakukan refresh atau panggil event untuk mengambil data coaching
      context.read<CoachingBloc>().add(GetCoachingEvent());
    }
  }

  void search(String query) {
    final lowerCaseQuery = query.toLowerCase(); // Pencarian berdasarkan nama
    List<CoachingEntity> init = coachings;
    filterCoachings = [];
    if (lowerCaseQuery != '') {
      filterCoachings = init.where((e) {
        final applicantName = e.name.toLowerCase();
        // Pencocokan query dengan nama pelamar
        bool matchesQuery = applicantName.contains(lowerCaseQuery);
        return matchesQuery;
      }).toList();
    } else {
      filterCoachings = coachings;
    }
    setState(() {});
  }
}
