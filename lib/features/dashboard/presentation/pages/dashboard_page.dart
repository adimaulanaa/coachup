import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/core/utils/ui_mode_helper.dart';
import 'package:coachup/features/coaching/data/models/coaching_model.dart';
import 'package:coachup/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:coachup/features/dashboard/presentation/widgets/widgets_view.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isHeader = false;
  String today = '';
  int totalCoach = 0;
  int totalPrivate = 0;
  int totalStudentCoach = 0;
  int totalStudentPrive = 0;
  DateTime now = DateTime.now();
  DashboardEntity dash = DashboardEntity();
  List<CoachModel> allCoaches = [];
  List<PrivatesModel> allPrivate = [];
  @override
  void initState() {
    super.initState();
    UiModeHelper.enableDefault();
    today = DateFormat('yyyy-MM-dd').format(now);
    context.read<DashboardBloc>().add(GetDashboardEvent(today));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: appbarView(size),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is GetDashboardLoading) {
            LoadingDialog.show();
          } else if (state is GetDashboardFailure) {
            LoadingDialog.hide();
            context.showSuccesSnackBar(
              state.message,
              onNavigate: () {}, // bottom close
            );
          } else if (state is GetDashboardLoaded) {
            dash = state.data;
            setInitData();
            LoadingDialog.hide();
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Row(
                          children: [
                            Text(
                              'Today',
                              style: transTextstyle.copyWith(
                                fontSize: 12,
                                fontWeight: bold,
                                color: AppColors.bgBlack,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(child: viewBoxInfoPrive(size)),
                        SizedBox(width: 10),
                        Expanded(child: viewBoxInfoCoach(size)),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.2),
                  Center(
                    child: Image.asset(
                      MediaRes.textLogo, // Ganti dengan path gambar Anda
                      width: MediaQuery.of(context).size.width * 0.8,
                      // height: MediaQuery.of(context).size.height * 0.21,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget viewBoxInfoPrive(Size size) {
    return Container(
      // height: size.height * 0.2,
      width: size.width,
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ViewTextTitle(
            icons: MediaRes.privates,
            type: 'Private',
            total: totalPrivate,
          ),
          SizedBox(height: 5),
          ViewTextTitle(
            icons: MediaRes.student,
            type: 'Murid',
            total: totalStudentPrive,
          ),
        ],
      ),
    );
  }

  Widget viewBoxInfoCoach(Size size) {
    return Container(
      // height: size.height * 0.2,
      width: size.width,
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ViewTextTitle(
            icons: MediaRes.coaching,
            type: 'Pelatihan',
            total: totalCoach,
          ),
          SizedBox(height: 5),
          ViewTextTitle(
            icons: MediaRes.student,
            type: 'Murid',
            total: totalStudentCoach,
          ),
        ],
      ),
    );
  }

  AppBar appbarView(Size size) {
    return AppBar(
      backgroundColor: AppColors.bgGrey,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage(
                MediaRes.omboarding,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * 0.6,
                child: Text(
                  dash.name == '' ? 'Your Name' : dash.name.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: blackTextstyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.6,
                child: Text(
                  dash.title == '' ? 'Your Title' : dash.title.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: transTextstyle.copyWith(
                    fontSize: 13,
                    fontWeight: medium,
                    color: AppColors.bgGreySecond,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        SvgPicture.asset(
          MediaRes.notification,
          fit: BoxFit.contain,
          width: 20,
          // ignore: deprecated_member_use
          color: AppColors.bgBlack,
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  void setInitData() {
    allCoaches = dash.coach;
    allPrivate = dash.private;
    if (allCoaches.isNotEmpty) {
      totalCoach = allCoaches.length;
      for (var e in allCoaches) {
        List<String> list = e.members
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        print(list.length);
      }
      // totalStudentCoach =
    }
    if (allPrivate.isNotEmpty) {
      totalPrivate = allPrivate.length;
      for (var e in allPrivate) {
        List<String> list = e.student
                ?.split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList() ??
            [];
        totalStudentPrive += list.length;
      }
      // totalStudentCoach =
    }
    setState(() {});
  }
}
