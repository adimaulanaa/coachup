import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/media/media_colors.dart';
import 'package:coachup/core/media/media_res.dart';
import 'package:coachup/core/media/media_text.dart';
import 'package:coachup/core/utils/custom_inkwell.dart';
import 'package:coachup/core/utils/custom_textfield.dart';
import 'package:coachup/core/utils/loading_dialog.dart';
import 'package:coachup/core/utils/snackbar_extension.dart';
import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:coachup/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:coachup/features/profile/presentation/bloc/profile_event.dart';
import 'package:coachup/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isProfile = false;
  bool isExport = false;
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController titleCtr = TextEditingController();
  final TextEditingController tlpnCtr = TextEditingController();
  final TextEditingController headerCtr = TextEditingController();
  final TextEditingController subHeaderCtr = TextEditingController();
  final TextEditingController footerPicCtr = TextEditingController();
  final TextEditingController footerCoachCtr = TextEditingController();
  ProfileEntity profile = ProfileEntity();
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is GetProfileLoading || state is UpdateProfileLoading) {
          LoadingDialog.show();
        } else if (state is GetProfileLoaded) {
          profile = state.data;
          LoadingDialog.hide();
          setData();
        } else if (state is UpdateProfileSuccess) {
          FocusScope.of(context).unfocus();
          context.read<ProfileBloc>().add(GetProfileEvent());
          LoadingDialog.hide();
          context.showSuccesSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        } else if (state is GetProfileFailure) {
          LoadingDialog.hide();
          context.showSuccesSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        } else if (state is UpdateProfileFailure) {
          LoadingDialog.hide();
          context.showErrorSnackBar(
            state.message,
            onNavigate: () {}, // bottom close
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return bodyForm();
        },
      ),
    );
  }

  Widget bodyForm() {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.bgGrey,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringResources.profile,
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
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              detailProfile(),
              const SizedBox(height: 10),
              detailExport(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Detail Profile',
              style: blackTextstyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
            CustomInkWell(
              onTap: () => saveProfile(),
              child: SvgPicture.asset(
                isProfile ? MediaRes.saved : MediaRes.edited,
                fit: BoxFit.contain,
                width: isProfile ? 17 : 20,
                // ignore: deprecated_member_use
                color: AppColors.bgBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: nameCtr,
          label: StringResources.pName,
          enabled: isProfile,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: titleCtr,
          label: StringResources.pTitle,
          enabled: isProfile,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: tlpnCtr,
          label: StringResources.pTlpn,
          enabled: isProfile,
        ),
      ],
    );
  }

  Widget detailExport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Detail Export Data',
              style: blackTextstyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
            CustomInkWell(
              onTap: () => saveExport(),
              child: SvgPicture.asset(
                isExport ? MediaRes.saved : MediaRes.edited,
                fit: BoxFit.contain,
                width: isExport ? 17 : 20,
                // ignore: deprecated_member_use
                color: AppColors.bgBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: headerCtr,
          label: StringResources.pHeader,
          enabled: isExport,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: subHeaderCtr,
          label: StringResources.pSubHeader,
          enabled: isExport,
        ),
        CustomTextField(
          controller: footerPicCtr,
          label: StringResources.pFPic,
          enabled: isExport,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: footerCoachCtr,
          label: StringResources.pFCoach,
          enabled: isExport,
        ),
      ],
    );
  }

  void setData() {
    nameCtr.text = profile.name ?? '';
    titleCtr.text = profile.title ?? '';
    tlpnCtr.text = profile.tlpn ?? '';
    headerCtr.text = profile.header ?? '';
    subHeaderCtr.text = profile.subHeader ?? '';
    footerPicCtr.text = profile.footerPic ?? '';
    footerCoachCtr.text = profile.footerCoach ?? '';
    setState(() {});
  }

  void saveProfile() {
    isProfile = !isProfile;
    if (!isProfile) {
      ProfileEntity model = initialData();
      context.read<ProfileBloc>().add(UpdateProfileEvent(model));
    }
    setState(() {});
  }

  void saveExport() {
    isExport = !isExport;
    if (!isExport) {
      ProfileEntity model = initialData();
      context.read<ProfileBloc>().add(UpdateProfileEvent(model));
    }
    setState(() {});
  }

  ProfileEntity initialData() {
    ProfileEntity model = ProfileEntity(
      name: nameCtr.text,
      title: titleCtr.text,
      tlpn: tlpnCtr.text,
      header: headerCtr.text,
      subHeader: subHeaderCtr.text,
      footerPic: footerPicCtr.text,
      footerCoach: footerCoachCtr.text,
    );
    return model;
  }
}
