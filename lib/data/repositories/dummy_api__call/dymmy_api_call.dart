

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../core/MiscController.dart';
import '../../data_sources/api_core/api.dart';
import '../../data_sources/api_core/api_with_ssl_pinning.dart';
import '../../data_sources/localDB/Repo_controller.dart';
import 'Leave/history/model/leave_model.dart';

import 'package:boilerplate_of_cubit/library.dart';

class OffLineOrOnlineLeaveRepository {

  APIServiceWithSSLPining api = APIServiceWithSSLPining();
  final _repository = LocalDBRepository();
  final _miscController = MiscController();

  //region fetchData
  Future fetchData({
    required Function(bool isSuccess, String message, List<LeaveModel> apiDataList, List<LeaveModel> offlineDataList) onComplete
  }) async {
    List<LeaveModel> apiList = [];
    List<LeaveModel> offlineList = [];

    final hasInternet = await _miscController.checkInternet();

    // Always load offline data first
    offlineList = await _repository.getAllData<LeaveModel>(
      tableName: "Leave",
      fromJson: (json) => LeaveModel.fromJson(json),
    );

    if (!hasInternet.contains('ignore')) {
      // Online - fetch API data
      final apiResponse = await api.fetchListData(
        endpoint: "/leaveapplication/",
        token: AppCache().userInfo?.token.toString(),
      );

      final jsonMap = jsonDecode(apiResponse);
      final success = jsonMap['Success'];
      final message = jsonMap['Message'];

      if (success) {
        try {
          final packetList = jsonMap['PacketList'];
          if (packetList != null) {
            apiList.clear();

            // Clear old data and save new offline data from API
            await _repository.delete(tableName: "Leave");

            for (var item in packetList) {
              final model = LeaveModel.fromJson(item);
              apiList.add(model);
              await _repository.insertData(
                tableName: "Leave",
                object: model.toJson(),
              );
            }

            onComplete(true, 'Data downloaded successfully', apiList, offlineList);
          } else {
            // No data from API, return offline only
            onComplete(false, 'Download Error!\nAPI packet is Null', [], offlineList);
          }
        } catch (ex) {
          onComplete(false, 'Download Error!\n${ex.toString()}', [], offlineList);
        }
      } else {
        onComplete(false, 'Download Error!\n$message', [], offlineList);
      }
    } else {
      // Offline - return offline data only
      if (offlineList.isNotEmpty) {
        onComplete(true, "Offline data loaded", [], offlineList);
      } else {
        onComplete(false, "No offline data available", [], []);
      }
    }
  }


  //endregion

  //region Filter
  Future<void> filterByDateOffline({
    required String date,
    required Function(bool isSuccess, String message, List<LeaveModel> dataList) onComplete,
  }) async {
    final filtered = await _repository.getAllData<LeaveModel>(
      tableName: "Leave",
      where: "StartDate = ?",
      whereArgs: [date],
      fromJson: (map) => LeaveModel.fromJson(map),
    );

    if (filtered.isNotEmpty) {
      onComplete(true, "Offline data found", filtered);
    } else {
      onComplete(false, "No offline data found for the given date", []);
    }
  }

  //endregion

  void submitData({
    required BuildContext context,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    required String imagePath,
    required Function(bool isSuccess, String message) onComplete,
  }) async {
    _miscController.showAlertDialog(
      context: context,
      cancelable: false,
      title: "Do you want to send?",
      subTitle: "Leave Type: $leaveType,\nStart date: $startDate,\nEnd date: $endDate",
      okText: "Send",
      okPressed: () async {
        _miscController.navigateBack(context: context);
        _miscController.showProgressDialog(context: context);

        bool isOnline = !(await _miscController.checkInternet()).contains("ignore");

        if (!isOnline) {
          // 🔌 Save to local DB instead of API
          await LocalDBRepository().insertData(
            tableName: "LeaveOfflineQueue",
            object: {
              "LeaveTypes": leaveType,
              "StartDate": startDate,
              "EndDate": endDate,
              "Reason": reason,
              "ImagePath": imagePath,
            },
          );
          _miscController.navigateBack(context: context);
          onComplete(true, "No internet! Leave saved locally and will sync automatically.");
          return;
        }

        try {
          // 🖼️ Attach image if exists
          File imageFile = File(imagePath);
          MultipartFile multipartFile = imagePath.isNotEmpty && await imageFile.exists()
              ? await MultipartFile.fromFile(imagePath, filename: "attendance_image.jpg")
              : MultipartFile.fromBytes([], filename: "attendance_image.jpg");

          FormData formData = FormData.fromMap({
            "leave_types": leaveType,
            "start_date": startDate,
            "end_date": endDate,
            "reason": reason,
            "image": imagePath.isNotEmpty ? multipartFile : "",
          });

          var apiResponse = await api.postData(
            endpoint: "/leaveapplication/",
            token: AppCache().userInfo?.token.toString(),
            data: formData,
          );

          _miscController.navigateBack(context: context);
          var response = jsonDecode(apiResponse);
          bool success = response['Success'];
          String message = response['Message'];

          if (success) {
            onComplete(true, 'Your leave request added successfully');
          //  emit(state.copyWith(success: true, message: message));
          } else {
            onComplete(false, 'Upload Failed: $message');
          //  emit(state.copyWith(success: false, message: "Something went wrong"));
          }
        } catch (e) {
          _miscController.navigateBack(context: context);
          print("Upload Error: $e");
          onComplete(false, 'Upload Error: ${e.toString()}');
        //  emit(state.copyWith(success: false, message: "Something went wrong"));
        }
      },
      cancelText: "No",
      cancelPressed: () => _miscController.navigateBack(context: context),
    );
  }


  Future<void> syncOfflineLeaves() async {
    bool isOnline = !(await _miscController.checkInternet()).contains("ignore");

    if (!isOnline) return;

    final db = LocalDBRepository();

    final List<Map<String, dynamic>> pendingLeaves = await db.getAllData<Map<String, dynamic>>(
      tableName: "LeaveOfflineQueue",
      fromJson: (map) => map,
    );

    for (var leave in pendingLeaves) {
      try {
        String imagePath = leave["ImagePath"];
        MultipartFile multipartFile = imagePath.isNotEmpty && await File(imagePath).exists()
            ? await MultipartFile.fromFile(imagePath, filename: "attendance_image.jpg")
            : MultipartFile.fromBytes([], filename: "attendance_image.jpg");

        FormData formData = FormData.fromMap({
          "leave_types": leave["LeaveTypes"],
          "start_date": leave["StartDate"],
          "end_date": leave["EndDate"],
          "reason": leave["Reason"],
          "image": imagePath.isNotEmpty ? multipartFile : "",
        });

        var response = await APIServiceWithSSLPining().postData(
          endpoint: "/leaveapplication/",
          token: AppCache().userInfo?.token.toString(),
          data: formData,
        );

        var result = jsonDecode(response);
        if (result["Success"] == true) {
          // ✅ Remove after successful upload
          await db.delete(
            tableName: "LeaveOfflineQueue",
            where: "Id = ?",
            whereArgs: [leave["Id"]],
          );
        }
      } catch (e) {
        print("Sync Error: $e");
      }
    }
  }


}