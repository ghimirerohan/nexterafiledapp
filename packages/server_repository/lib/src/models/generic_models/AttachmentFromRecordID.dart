
class AttachmentsFromRecordID {
  List<Attachments>? attachments;

  AttachmentsFromRecordID({this.attachments});

  AttachmentsFromRecordID.fromJson(Map<String, dynamic> json) {
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  String? name;
  String? contentType;

  Attachments({this.name, this.contentType});

  Attachments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contentType'] = this.contentType;
    return data;
  }
}
