import 'package:flutter/material.dart';
import 'package:meetup/utils/ui_spacer.dart';
import 'package:meetup/widgets/states/empty.state.dart';
import 'package:meetup/widgets/states/loading.shimmer.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomListView extends StatelessWidget {
  //
  final Widget? title;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final List<dynamic> dataSet;
  final bool isLoading;
  final bool hasError;
  final bool justList;
  final bool reversed;
  final bool noScrollPhysics;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;

  //
  final bool canRefresh;
  final RefreshController? refreshController;
  final Function? onRefresh;
  final Function? onLoading;
  final bool canPullUp;

  const CustomListView({
    required this.dataSet,
    this.title,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isLoading = false,
    this.hasError = false,
    this.justList = true,
    this.reversed = false,
    this.noScrollPhysics = false,
    this.scrollDirection = Axis.vertical,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,

    //
    this.canRefresh = false,
    this.refreshController,
    this.onRefresh,
    this.onLoading,
    this.canPullUp = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return justList
        ? _getBody()
        : VStack(
            [
              title ?? UiSpacer.emptySpace(),
              _getBody(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          );
  }

  Widget _getBody() {
    return isLoading
        ? loadingWidget ?? const LoadingShimmer()
        : hasError
            ? errorWidget ?? const EmptyState()
            : justList
                ? dataSet.isEmpty
                    ? emptyWidget ?? UiSpacer.emptySpace()
                    : _getBodyList()
                : Expanded(
                    child: _getBodyList(),
                  );
  }

  //
  Widget _getBodyList() {
    //try error if can refresh is true but refresh controller is null using assert
    assert(
      !canRefresh || refreshController != null,
      "Refresh controller cannot be null if canRefresh is true",
    );

    return canRefresh
        ? SmartRefresher(
            scrollDirection: scrollDirection,
            enablePullDown: true,
            enablePullUp: canPullUp,
            controller: refreshController!,
            onRefresh: () => onRefresh != null ? onRefresh!() : null,
            onLoading: () => onLoading != null ? onLoading!() : null,
            child: _getListView(),
          )
        : _getListView();
  }

  //get listview
  Widget _getListView() {
    return ListView.separated(
      padding: padding,
      shrinkWrap: true,
      reverse: reversed,
      physics: noScrollPhysics ? const NeverScrollableScrollPhysics() : null,
      scrollDirection: scrollDirection,
      itemBuilder: itemBuilder,
      itemCount: dataSet.length,
      separatorBuilder: separatorBuilder ??
          (context, index) => scrollDirection == Axis.vertical
              ? UiSpacer.verticalSpace()
              : UiSpacer.horizontalSpace(),
    );
  }
}
