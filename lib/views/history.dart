import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_finance/backend/backend.dart';
import 'package:self_finance/constants/constants.dart';
import 'package:self_finance/models/transaction_model.dart';
import 'package:self_finance/theme/colors.dart';
import 'package:self_finance/widgets/detail_card_widget.dart';
import 'package:self_finance/widgets/dilogbox_widget.dart';
import 'package:self_finance/widgets/title_widget.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late Future<List<Transactions>> _dataFuture;
  List<Transactions> _shodowData = [];

  @override
  void initState() {
    super.initState();
    _dataFuture = BackEnd.fetchLatestTransactions();
  }

  Widget _showErrorAlert(error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertDilogs.alertDialogWithOneAction(context, "error", 'Error fetching data: $error');
    });

    // Return a placeholder widget, or an empty container
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _dataFuture;
    _shodowData;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
      child: RefreshIndicator.adaptive(
        onRefresh: () => _dataFuture = _dataFuture = BackEnd.fetchLatestTransactions(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleWidget(text: history),
            SizedBox(height: 18.sp),
            _buildSearchBar(),
            SizedBox(height: 18.sp),
            _buildData(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Transactions>> _buildData() {
    return FutureBuilder<List<Transactions>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive()); // Placeholder for loading state
        } else if (snapshot.hasError) {
          // return Text(snapshot.error.toString());
          print(snapshot.error);
          return _showErrorAlert(snapshot.error);
        } else {
          // Check if data is null or empty
          final List<Transactions>? data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(
              child: Text("No transactions found."),
            );
          }
          _shodowData = data;
          return _buildCards(data);
        }
      },
    );
  }

  Widget _buildCards(List<Transactions> data) {
    if (data.isEmpty || data == []) {
      return const Center(
        child: Text("No transactions found."),
      );
    }

    return Expanded(
      child: ListView.builder(
        key: ValueKey(data),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return DetailCardWidget(data: data[index]);
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return CupertinoSearchTextField(
          style: const TextStyle(color: getPrimaryColor),
          onSubmitted: (value) => _doSearch(controller.text),
          placeholder: "Please enter mobile number",
          keyboardType: TextInputType.phone,
          controller: controller,
          onChanged: (_) {
            _doSearch(controller.text);
          },
        );
      },
      isFullScreen: false,
      dividerColor: getPrimaryTextColor,
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(
          _shodowData.length,
          (int index) {
            final String item = _shodowData[index].mobileNumber;
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(
                  () {
                    _doSearch(item);
                    controller.closeView(item);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // void _doSearch(String mobileNumber) async {
  //   try {
  //     if (mobileNumber.isEmpty) {
  //       setState(() {
  //         _dataFuture = BackEnd.fetchLatestTransactions();
  //       });
  //     } else {
  //       List<Transactions> queryData = await BackEnd.getTransactionsEntriesByMobileNumber(mobileNumber);
  //       setState(() {
  //         _dataFuture = Future.value(queryData);
  //       });
  //     }
  //   } catch (error) {
  //     _showErrorAlert(error);
  //   }
  // }

  void _doSearch(String mobileNumber) async {
    try {
      List<Transactions> queryData = [];

      if (mobileNumber.isNotEmpty) {
        queryData = await BackEnd.getTransactionsEntriesByMobileNumber(mobileNumber);
      }

      setState(() {
        _dataFuture = Future.value(queryData);
      });
    } catch (error) {
      _showErrorAlert(error);
    }
  }
}
