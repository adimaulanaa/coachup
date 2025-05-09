
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:coachup/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is GetDashboardLoading) {
          LoadingDialog.show(context);
        } else if (state is GetDashboardSuccess) {
          LoadingDialog.hide(context);
          context.showSuccesSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        } else if (state is GetDashboardFailure) {
          LoadingDialog.hide(context);
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgGrey,
        appBar: AppBar(
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
                      'companyName',
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
                      'companyAddress',
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
              MediaRes.warning,
              fit: BoxFit.contain,
              width: 25,
              // ignore: deprecated_member_use
              color: AppColors.bgBlack,
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.2,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              const Center(child: Text("dashboard")),
            ],
          ),
        ),
      ),
    );
  }
}
