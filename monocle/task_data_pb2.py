# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: monocle/task_data.proto
"""Generated protocol buffer code."""
from google.protobuf.internal import enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database

# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


from google.protobuf import timestamp_pb2 as google_dot_protobuf_dot_timestamp__pb2


DESCRIPTOR = _descriptor.FileDescriptor(
    name="monocle/task_data.proto",
    package="monocle_task_data",
    syntax="proto3",
    serialized_options=b"Z\021monocle/task_data",
    create_key=_descriptor._internal_create_key,
    serialized_pb=b'\n\x17monocle/task_data.proto\x12\x11monocle_task_data\x1a\x1fgoogle/protobuf/timestamp.proto"v\n\x15TaskDataCommitRequest\x12\r\n\x05index\x18\x01 \x01(\t\x12\x0f\n\x07\x63rawler\x18\x02 \x01(\t\x12\x0e\n\x06\x61pikey\x18\x03 \x01(\t\x12-\n\ttimestamp\x18\x04 \x01(\x0b\x32\x1a.google.protobuf.Timestamp"\x8c\x01\n\x16TaskDataCommitResponse\x12\x37\n\x05\x65rror\x18\x01 \x01(\x0e\x32&.monocle_task_data.TaskDataCommitErrorH\x00\x12/\n\ttimestamp\x18\x02 \x01(\x0b\x32\x1a.google.protobuf.TimestampH\x00\x42\x08\n\x06result"?\n\x1dTaskDataGetLastUpdatedRequest\x12\r\n\x05index\x18\x01 \x01(\t\x12\x0f\n\x07\x63rawler\x18\x02 \x01(\t"\x9c\x01\n\x1eTaskDataGetLastUpdatedResponse\x12?\n\x05\x65rror\x18\x01 \x01(\x0e\x32..monocle_task_data.TaskDataGetLastUpdatedErrorH\x00\x12/\n\ttimestamp\x18\x02 \x01(\x0b\x32\x1a.google.protobuf.TimestampH\x00\x42\x08\n\x06result"\xb9\x01\n\x08TaskData\x12.\n\nupdated_at\x18\x01 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x12\n\nchange_url\x18\x02 \x01(\t\x12\r\n\x05ttype\x18\x03 \x03(\t\x12\x0b\n\x03tid\x18\x04 \x01(\t\x12\x0b\n\x03url\x18\x05 \x01(\t\x12\r\n\x05title\x18\x06 \x01(\t\x12\x10\n\x08severity\x18\x07 \x01(\t\x12\x10\n\x08priority\x18\x08 \x01(\t\x12\r\n\x05score\x18\t \x01(\x05"h\n\nAddRequest\x12\r\n\x05index\x18\x01 \x01(\t\x12\x0f\n\x07\x63rawler\x18\x02 \x01(\t\x12\x0e\n\x06\x61pikey\x18\x03 \x01(\t\x12*\n\x05items\x18\x04 \x03(\x0b\x32\x1b.monocle_task_data.TaskData"P\n\x0b\x41\x64\x64Response\x12\x37\n\x05\x65rror\x18\x01 \x01(\x0e\x32&.monocle_task_data.TaskDataCommitErrorH\x00\x42\x08\n\x06result*\x81\x01\n\x13TaskDataCommitError\x12\x10\n\x0cUnknownIndex\x10\x00\x12\x12\n\x0eUnknownCrawler\x10\x01\x12\x11\n\rUnknownApiKey\x10\x02\x12"\n\x1e\x43ommitDateInferiorThanPrevious\x10\x03\x12\r\n\tAddFailed\x10\x04*I\n\x1bTaskDataGetLastUpdatedError\x12\x13\n\x0fGetUnknownIndex\x10\x00\x12\x15\n\x11GetUnknownCrawler\x10\x01\x42\x13Z\x11monocle/task_datab\x06proto3',
    dependencies=[
        google_dot_protobuf_dot_timestamp__pb2.DESCRIPTOR,
    ],
)

_TASKDATACOMMITERROR = _descriptor.EnumDescriptor(
    name="TaskDataCommitError",
    full_name="monocle_task_data.TaskDataCommitError",
    filename=None,
    file=DESCRIPTOR,
    create_key=_descriptor._internal_create_key,
    values=[
        _descriptor.EnumValueDescriptor(
            name="UnknownIndex",
            index=0,
            number=0,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="UnknownCrawler",
            index=1,
            number=1,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="UnknownApiKey",
            index=2,
            number=2,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="CommitDateInferiorThanPrevious",
            index=3,
            number=3,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="AddFailed",
            index=4,
            number=4,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    containing_type=None,
    serialized_options=None,
    serialized_start=943,
    serialized_end=1072,
)
_sym_db.RegisterEnumDescriptor(_TASKDATACOMMITERROR)

TaskDataCommitError = enum_type_wrapper.EnumTypeWrapper(_TASKDATACOMMITERROR)
_TASKDATAGETLASTUPDATEDERROR = _descriptor.EnumDescriptor(
    name="TaskDataGetLastUpdatedError",
    full_name="monocle_task_data.TaskDataGetLastUpdatedError",
    filename=None,
    file=DESCRIPTOR,
    create_key=_descriptor._internal_create_key,
    values=[
        _descriptor.EnumValueDescriptor(
            name="GetUnknownIndex",
            index=0,
            number=0,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="GetUnknownCrawler",
            index=1,
            number=1,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    containing_type=None,
    serialized_options=None,
    serialized_start=1074,
    serialized_end=1147,
)
_sym_db.RegisterEnumDescriptor(_TASKDATAGETLASTUPDATEDERROR)

TaskDataGetLastUpdatedError = enum_type_wrapper.EnumTypeWrapper(
    _TASKDATAGETLASTUPDATEDERROR
)
UnknownIndex = 0
UnknownCrawler = 1
UnknownApiKey = 2
CommitDateInferiorThanPrevious = 3
AddFailed = 4
GetUnknownIndex = 0
GetUnknownCrawler = 1


_TASKDATACOMMITREQUEST = _descriptor.Descriptor(
    name="TaskDataCommitRequest",
    full_name="monocle_task_data.TaskDataCommitRequest",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="index",
            full_name="monocle_task_data.TaskDataCommitRequest.index",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="crawler",
            full_name="monocle_task_data.TaskDataCommitRequest.crawler",
            index=1,
            number=2,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="apikey",
            full_name="monocle_task_data.TaskDataCommitRequest.apikey",
            index=2,
            number=3,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="timestamp",
            full_name="monocle_task_data.TaskDataCommitRequest.timestamp",
            index=3,
            number=4,
            type=11,
            cpp_type=10,
            label=1,
            has_default_value=False,
            default_value=None,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=79,
    serialized_end=197,
)


_TASKDATACOMMITRESPONSE = _descriptor.Descriptor(
    name="TaskDataCommitResponse",
    full_name="monocle_task_data.TaskDataCommitResponse",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="error",
            full_name="monocle_task_data.TaskDataCommitResponse.error",
            index=0,
            number=1,
            type=14,
            cpp_type=8,
            label=1,
            has_default_value=False,
            default_value=0,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="timestamp",
            full_name="monocle_task_data.TaskDataCommitResponse.timestamp",
            index=1,
            number=2,
            type=11,
            cpp_type=10,
            label=1,
            has_default_value=False,
            default_value=None,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[
        _descriptor.OneofDescriptor(
            name="result",
            full_name="monocle_task_data.TaskDataCommitResponse.result",
            index=0,
            containing_type=None,
            create_key=_descriptor._internal_create_key,
            fields=[],
        ),
    ],
    serialized_start=200,
    serialized_end=340,
)


_TASKDATAGETLASTUPDATEDREQUEST = _descriptor.Descriptor(
    name="TaskDataGetLastUpdatedRequest",
    full_name="monocle_task_data.TaskDataGetLastUpdatedRequest",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="index",
            full_name="monocle_task_data.TaskDataGetLastUpdatedRequest.index",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="crawler",
            full_name="monocle_task_data.TaskDataGetLastUpdatedRequest.crawler",
            index=1,
            number=2,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=342,
    serialized_end=405,
)


_TASKDATAGETLASTUPDATEDRESPONSE = _descriptor.Descriptor(
    name="TaskDataGetLastUpdatedResponse",
    full_name="monocle_task_data.TaskDataGetLastUpdatedResponse",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="error",
            full_name="monocle_task_data.TaskDataGetLastUpdatedResponse.error",
            index=0,
            number=1,
            type=14,
            cpp_type=8,
            label=1,
            has_default_value=False,
            default_value=0,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="timestamp",
            full_name="monocle_task_data.TaskDataGetLastUpdatedResponse.timestamp",
            index=1,
            number=2,
            type=11,
            cpp_type=10,
            label=1,
            has_default_value=False,
            default_value=None,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[
        _descriptor.OneofDescriptor(
            name="result",
            full_name="monocle_task_data.TaskDataGetLastUpdatedResponse.result",
            index=0,
            containing_type=None,
            create_key=_descriptor._internal_create_key,
            fields=[],
        ),
    ],
    serialized_start=408,
    serialized_end=564,
)


_TASKDATA = _descriptor.Descriptor(
    name="TaskData",
    full_name="monocle_task_data.TaskData",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="updated_at",
            full_name="monocle_task_data.TaskData.updated_at",
            index=0,
            number=1,
            type=11,
            cpp_type=10,
            label=1,
            has_default_value=False,
            default_value=None,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="change_url",
            full_name="monocle_task_data.TaskData.change_url",
            index=1,
            number=2,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="ttype",
            full_name="monocle_task_data.TaskData.ttype",
            index=2,
            number=3,
            type=9,
            cpp_type=9,
            label=3,
            has_default_value=False,
            default_value=[],
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="tid",
            full_name="monocle_task_data.TaskData.tid",
            index=3,
            number=4,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="url",
            full_name="monocle_task_data.TaskData.url",
            index=4,
            number=5,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="title",
            full_name="monocle_task_data.TaskData.title",
            index=5,
            number=6,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="severity",
            full_name="monocle_task_data.TaskData.severity",
            index=6,
            number=7,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="priority",
            full_name="monocle_task_data.TaskData.priority",
            index=7,
            number=8,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="score",
            full_name="monocle_task_data.TaskData.score",
            index=8,
            number=9,
            type=5,
            cpp_type=1,
            label=1,
            has_default_value=False,
            default_value=0,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=567,
    serialized_end=752,
)


_ADDREQUEST = _descriptor.Descriptor(
    name="AddRequest",
    full_name="monocle_task_data.AddRequest",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="index",
            full_name="monocle_task_data.AddRequest.index",
            index=0,
            number=1,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="crawler",
            full_name="monocle_task_data.AddRequest.crawler",
            index=1,
            number=2,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="apikey",
            full_name="monocle_task_data.AddRequest.apikey",
            index=2,
            number=3,
            type=9,
            cpp_type=9,
            label=1,
            has_default_value=False,
            default_value=b"".decode("utf-8"),
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.FieldDescriptor(
            name="items",
            full_name="monocle_task_data.AddRequest.items",
            index=3,
            number=4,
            type=11,
            cpp_type=10,
            label=3,
            has_default_value=False,
            default_value=[],
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[],
    serialized_start=754,
    serialized_end=858,
)


_ADDRESPONSE = _descriptor.Descriptor(
    name="AddResponse",
    full_name="monocle_task_data.AddResponse",
    filename=None,
    file=DESCRIPTOR,
    containing_type=None,
    create_key=_descriptor._internal_create_key,
    fields=[
        _descriptor.FieldDescriptor(
            name="error",
            full_name="monocle_task_data.AddResponse.error",
            index=0,
            number=1,
            type=14,
            cpp_type=8,
            label=1,
            has_default_value=False,
            default_value=0,
            message_type=None,
            enum_type=None,
            containing_type=None,
            is_extension=False,
            extension_scope=None,
            serialized_options=None,
            file=DESCRIPTOR,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    extensions=[],
    nested_types=[],
    enum_types=[],
    serialized_options=None,
    is_extendable=False,
    syntax="proto3",
    extension_ranges=[],
    oneofs=[
        _descriptor.OneofDescriptor(
            name="result",
            full_name="monocle_task_data.AddResponse.result",
            index=0,
            containing_type=None,
            create_key=_descriptor._internal_create_key,
            fields=[],
        ),
    ],
    serialized_start=860,
    serialized_end=940,
)

_TASKDATACOMMITREQUEST.fields_by_name[
    "timestamp"
].message_type = google_dot_protobuf_dot_timestamp__pb2._TIMESTAMP
_TASKDATACOMMITRESPONSE.fields_by_name["error"].enum_type = _TASKDATACOMMITERROR
_TASKDATACOMMITRESPONSE.fields_by_name[
    "timestamp"
].message_type = google_dot_protobuf_dot_timestamp__pb2._TIMESTAMP
_TASKDATACOMMITRESPONSE.oneofs_by_name["result"].fields.append(
    _TASKDATACOMMITRESPONSE.fields_by_name["error"]
)
_TASKDATACOMMITRESPONSE.fields_by_name[
    "error"
].containing_oneof = _TASKDATACOMMITRESPONSE.oneofs_by_name["result"]
_TASKDATACOMMITRESPONSE.oneofs_by_name["result"].fields.append(
    _TASKDATACOMMITRESPONSE.fields_by_name["timestamp"]
)
_TASKDATACOMMITRESPONSE.fields_by_name[
    "timestamp"
].containing_oneof = _TASKDATACOMMITRESPONSE.oneofs_by_name["result"]
_TASKDATAGETLASTUPDATEDRESPONSE.fields_by_name[
    "error"
].enum_type = _TASKDATAGETLASTUPDATEDERROR
_TASKDATAGETLASTUPDATEDRESPONSE.fields_by_name[
    "timestamp"
].message_type = google_dot_protobuf_dot_timestamp__pb2._TIMESTAMP
_TASKDATAGETLASTUPDATEDRESPONSE.oneofs_by_name["result"].fields.append(
    _TASKDATAGETLASTUPDATEDRESPONSE.fields_by_name["error"]
)
_TASKDATAGETLASTUPDATEDRESPONSE.fields_by_name[
    "error"
].containing_oneof = _TASKDATAGETLASTUPDATEDRESPONSE.oneofs_by_name["result"]
_TASKDATAGETLASTUPDATEDRESPONSE.oneofs_by_name["result"].fields.append(
    _TASKDATAGETLASTUPDATEDRESPONSE.fields_by_name["timestamp"]
)
_TASKDATAGETLASTUPDATEDRESPONSE.fields_by_name[
    "timestamp"
].containing_oneof = _TASKDATAGETLASTUPDATEDRESPONSE.oneofs_by_name["result"]
_TASKDATA.fields_by_name[
    "updated_at"
].message_type = google_dot_protobuf_dot_timestamp__pb2._TIMESTAMP
_ADDREQUEST.fields_by_name["items"].message_type = _TASKDATA
_ADDRESPONSE.fields_by_name["error"].enum_type = _TASKDATACOMMITERROR
_ADDRESPONSE.oneofs_by_name["result"].fields.append(
    _ADDRESPONSE.fields_by_name["error"]
)
_ADDRESPONSE.fields_by_name["error"].containing_oneof = _ADDRESPONSE.oneofs_by_name[
    "result"
]
DESCRIPTOR.message_types_by_name["TaskDataCommitRequest"] = _TASKDATACOMMITREQUEST
DESCRIPTOR.message_types_by_name["TaskDataCommitResponse"] = _TASKDATACOMMITRESPONSE
DESCRIPTOR.message_types_by_name[
    "TaskDataGetLastUpdatedRequest"
] = _TASKDATAGETLASTUPDATEDREQUEST
DESCRIPTOR.message_types_by_name[
    "TaskDataGetLastUpdatedResponse"
] = _TASKDATAGETLASTUPDATEDRESPONSE
DESCRIPTOR.message_types_by_name["TaskData"] = _TASKDATA
DESCRIPTOR.message_types_by_name["AddRequest"] = _ADDREQUEST
DESCRIPTOR.message_types_by_name["AddResponse"] = _ADDRESPONSE
DESCRIPTOR.enum_types_by_name["TaskDataCommitError"] = _TASKDATACOMMITERROR
DESCRIPTOR.enum_types_by_name[
    "TaskDataGetLastUpdatedError"
] = _TASKDATAGETLASTUPDATEDERROR
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

TaskDataCommitRequest = _reflection.GeneratedProtocolMessageType(
    "TaskDataCommitRequest",
    (_message.Message,),
    {
        "DESCRIPTOR": _TASKDATACOMMITREQUEST,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.TaskDataCommitRequest)
    },
)
_sym_db.RegisterMessage(TaskDataCommitRequest)

TaskDataCommitResponse = _reflection.GeneratedProtocolMessageType(
    "TaskDataCommitResponse",
    (_message.Message,),
    {
        "DESCRIPTOR": _TASKDATACOMMITRESPONSE,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.TaskDataCommitResponse)
    },
)
_sym_db.RegisterMessage(TaskDataCommitResponse)

TaskDataGetLastUpdatedRequest = _reflection.GeneratedProtocolMessageType(
    "TaskDataGetLastUpdatedRequest",
    (_message.Message,),
    {
        "DESCRIPTOR": _TASKDATAGETLASTUPDATEDREQUEST,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.TaskDataGetLastUpdatedRequest)
    },
)
_sym_db.RegisterMessage(TaskDataGetLastUpdatedRequest)

TaskDataGetLastUpdatedResponse = _reflection.GeneratedProtocolMessageType(
    "TaskDataGetLastUpdatedResponse",
    (_message.Message,),
    {
        "DESCRIPTOR": _TASKDATAGETLASTUPDATEDRESPONSE,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.TaskDataGetLastUpdatedResponse)
    },
)
_sym_db.RegisterMessage(TaskDataGetLastUpdatedResponse)

TaskData = _reflection.GeneratedProtocolMessageType(
    "TaskData",
    (_message.Message,),
    {
        "DESCRIPTOR": _TASKDATA,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.TaskData)
    },
)
_sym_db.RegisterMessage(TaskData)

AddRequest = _reflection.GeneratedProtocolMessageType(
    "AddRequest",
    (_message.Message,),
    {
        "DESCRIPTOR": _ADDREQUEST,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.AddRequest)
    },
)
_sym_db.RegisterMessage(AddRequest)

AddResponse = _reflection.GeneratedProtocolMessageType(
    "AddResponse",
    (_message.Message,),
    {
        "DESCRIPTOR": _ADDRESPONSE,
        "__module__": "monocle.task_data_pb2"
        # @@protoc_insertion_point(class_scope:monocle_task_data.AddResponse)
    },
)
_sym_db.RegisterMessage(AddResponse)


DESCRIPTOR._options = None
# @@protoc_insertion_point(module_scope)
