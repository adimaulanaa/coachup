import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/app_navigator.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_search_field.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/custom_view_coach.dart';
import 'package:coachup/core/utils/empty_list_data.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
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
  late CoachingBloc _coachingBloc;
  List<CoachModel> coaching = [];
  List<CoachModel> filterCoaching = [];
  TextEditingController searchController = TextEditingController();
  final TextEditingController dateStrCtr = TextEditingController();
  final TextEditingController dateFnsCtr = TextEditingController();
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _coachingBloc = context.read<CoachingBloc>();
    requestSearch();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocListener<CoachingBloc, CoachingState>(
        listener: (context, state) {
          if (state is ListCoachingLoading) {
            LoadingDialog.show();
          } else if (state is ListCoachingFailure) {
            LoadingDialog.hide();
            context.showErrorSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
          } else if (state is ListCoachingLoaded) {
            coaching = state.coaching;
            filterCoaching = coaching;
            initialized = true;
            LoadingDialog.hide();
          }
        },
        child: BlocBuilder<CoachingBloc, CoachingState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomSearchField(
                            controller: searchController,
                            hintText: 'Cari nama sekolah...',
                            onChanged: (value) {
                              search(value);
                            },
                            onClear: () {
                              searchController.clear();
                              search('');
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        CustomInkWell(
                          onTap: () {
                            navCreated();
                          },
                          child: SvgPicture.asset(
                            MediaRes.created,
                            // ignore: deprecated_member_use
                            color: AppColors.bgGreySecond,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // 🔽 Date Filter Widget
                    Row(
                      children: [
                        Expanded(
                          child: CustomDateField(
                            controller: dateStrCtr,
                            label: StringResources.prDateStr,
                            onDatePicked: (_) => requestSearch(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomDateField(
                            controller: dateFnsCtr,
                            label: StringResources.prDateFns,
                            onDatePicked: (_) => requestSearch(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listCoaching(Size size, CoachModel e) {
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
          requestSearch();
        }
      },
      child: ListCoaching(dt: e, size: size),
    );
  }

  void requestSearch() {
    _coachingBloc.add(ListCoachingEvent(dateStrCtr.text, dateFnsCtr.text));
  }

  void navCreated() async {
    await AppNavigator.push(
      const CreatedCoachingPage(),
      transition: TransitionType.fade,
    );
    if (mounted) {
      initialized = false; // reset biar filter di-refresh
      requestSearch();
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
