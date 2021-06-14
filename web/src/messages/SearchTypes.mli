(** search.proto Types *)



(** {2 Types} *)

type search_suggestions_request = {
  index : string;
}

type search_suggestions_response = {
  task_types : string list;
  authors : string list;
  approvals : string list;
  priorities : string list;
  severities : string list;
}

type fields_request = {
  version : string;
}

type field_type =
  | Field_date 
  | Field_number 
  | Field_text 
  | Field_bool 
  | Field_regex 

type field = {
  name : string;
  description : string;
  type_ : field_type;
}

type fields_response = {
  fields : field list;
}

type query_error = {
  message : string;
  position : int32;
}

type query_request = {
  index : string;
  query : string;
  username : string;
}

type file = {
  additions : int32;
  deletions : int32;
  path : string;
}

type commit = {
  sha : string;
  title : string;
  author : string;
  authored_at : TimestampTypes.timestamp option;
  committer : string;
  committed_at : TimestampTypes.timestamp option;
  additions : int32;
  deletions : int32;
}

type change_merged_by_m =
  | Merged_by of string

and change = {
  change_id : string;
  author : string;
  title : string;
  url : string;
  repository_fullname : string;
  state : string;
  branch : string;
  target_branch : string;
  created_at : TimestampTypes.timestamp option;
  updated_at : TimestampTypes.timestamp option;
  merged_at : TimestampTypes.timestamp option;
  merged_by_m : change_merged_by_m;
  text : string;
  additions : int32;
  deletions : int32;
  approval : string list;
  assignees : string list;
  labels : string list;
  draft : bool;
  mergeable : bool;
  changed_files : file list;
  changed_files_count : int32;
  commits : commit list;
  commits_count : int32;
  task_data : TaskDataTypes.task_data list;
}

type changes = {
  changes : change list;
}

type query_response =
  | Error of query_error
  | Items of changes

type changes_histos_event = {
  doc_count : int32;
  key : int64;
  key_as_string : string;
}

type changes_histos = {
  change_abandoned_event : changes_histos_event list;
  change_commit_force_pushed_event : changes_histos_event list;
  change_commit_pushed_event : changes_histos_event list;
  change_created_event : changes_histos_event list;
  change_merged_event : changes_histos_event list;
}

type changes_lifecycle_event = {
  authors_count : int32;
  events_count : int32;
}

type changes_lifecycle_ratios = {
  abandoned : float;
  iterations : float;
  merged : float;
  self_merged : float;
}

type changes_lifecycle = {
  change_commit_force_pushed_event : changes_lifecycle_event option;
  change_commit_pushed_event : changes_lifecycle_event option;
  change_created_event : changes_lifecycle_event option;
  abandoned : int32;
  commits : float;
  duration : float;
  duration_variability : float;
  histos : changes_histos option;
  merged : int32;
  opened : int32;
  ratios : changes_lifecycle_ratios option;
  self_merged : int32;
  tests : float;
}


(** {2 Default values} *)

val default_search_suggestions_request : 
  ?index:string ->
  unit ->
  search_suggestions_request
(** [default_search_suggestions_request ()] is the default value for type [search_suggestions_request] *)

val default_search_suggestions_response : 
  ?task_types:string list ->
  ?authors:string list ->
  ?approvals:string list ->
  ?priorities:string list ->
  ?severities:string list ->
  unit ->
  search_suggestions_response
(** [default_search_suggestions_response ()] is the default value for type [search_suggestions_response] *)

val default_fields_request : 
  ?version:string ->
  unit ->
  fields_request
(** [default_fields_request ()] is the default value for type [fields_request] *)

val default_field_type : unit -> field_type
(** [default_field_type ()] is the default value for type [field_type] *)

val default_field : 
  ?name:string ->
  ?description:string ->
  ?type_:field_type ->
  unit ->
  field
(** [default_field ()] is the default value for type [field] *)

val default_fields_response : 
  ?fields:field list ->
  unit ->
  fields_response
(** [default_fields_response ()] is the default value for type [fields_response] *)

val default_query_error : 
  ?message:string ->
  ?position:int32 ->
  unit ->
  query_error
(** [default_query_error ()] is the default value for type [query_error] *)

val default_query_request : 
  ?index:string ->
  ?query:string ->
  ?username:string ->
  unit ->
  query_request
(** [default_query_request ()] is the default value for type [query_request] *)

val default_file : 
  ?additions:int32 ->
  ?deletions:int32 ->
  ?path:string ->
  unit ->
  file
(** [default_file ()] is the default value for type [file] *)

val default_commit : 
  ?sha:string ->
  ?title:string ->
  ?author:string ->
  ?authored_at:TimestampTypes.timestamp option ->
  ?committer:string ->
  ?committed_at:TimestampTypes.timestamp option ->
  ?additions:int32 ->
  ?deletions:int32 ->
  unit ->
  commit
(** [default_commit ()] is the default value for type [commit] *)

val default_change_merged_by_m : unit -> change_merged_by_m
(** [default_change_merged_by_m ()] is the default value for type [change_merged_by_m] *)

val default_change : 
  ?change_id:string ->
  ?author:string ->
  ?title:string ->
  ?url:string ->
  ?repository_fullname:string ->
  ?state:string ->
  ?branch:string ->
  ?target_branch:string ->
  ?created_at:TimestampTypes.timestamp option ->
  ?updated_at:TimestampTypes.timestamp option ->
  ?merged_at:TimestampTypes.timestamp option ->
  ?merged_by_m:change_merged_by_m ->
  ?text:string ->
  ?additions:int32 ->
  ?deletions:int32 ->
  ?approval:string list ->
  ?assignees:string list ->
  ?labels:string list ->
  ?draft:bool ->
  ?mergeable:bool ->
  ?changed_files:file list ->
  ?changed_files_count:int32 ->
  ?commits:commit list ->
  ?commits_count:int32 ->
  ?task_data:TaskDataTypes.task_data list ->
  unit ->
  change
(** [default_change ()] is the default value for type [change] *)

val default_changes : 
  ?changes:change list ->
  unit ->
  changes
(** [default_changes ()] is the default value for type [changes] *)

val default_query_response : unit -> query_response
(** [default_query_response ()] is the default value for type [query_response] *)

val default_changes_histos_event : 
  ?doc_count:int32 ->
  ?key:int64 ->
  ?key_as_string:string ->
  unit ->
  changes_histos_event
(** [default_changes_histos_event ()] is the default value for type [changes_histos_event] *)

val default_changes_histos : 
  ?change_abandoned_event:changes_histos_event list ->
  ?change_commit_force_pushed_event:changes_histos_event list ->
  ?change_commit_pushed_event:changes_histos_event list ->
  ?change_created_event:changes_histos_event list ->
  ?change_merged_event:changes_histos_event list ->
  unit ->
  changes_histos
(** [default_changes_histos ()] is the default value for type [changes_histos] *)

val default_changes_lifecycle_event : 
  ?authors_count:int32 ->
  ?events_count:int32 ->
  unit ->
  changes_lifecycle_event
(** [default_changes_lifecycle_event ()] is the default value for type [changes_lifecycle_event] *)

val default_changes_lifecycle_ratios : 
  ?abandoned:float ->
  ?iterations:float ->
  ?merged:float ->
  ?self_merged:float ->
  unit ->
  changes_lifecycle_ratios
(** [default_changes_lifecycle_ratios ()] is the default value for type [changes_lifecycle_ratios] *)

val default_changes_lifecycle : 
  ?change_commit_force_pushed_event:changes_lifecycle_event option ->
  ?change_commit_pushed_event:changes_lifecycle_event option ->
  ?change_created_event:changes_lifecycle_event option ->
  ?abandoned:int32 ->
  ?commits:float ->
  ?duration:float ->
  ?duration_variability:float ->
  ?histos:changes_histos option ->
  ?merged:int32 ->
  ?opened:int32 ->
  ?ratios:changes_lifecycle_ratios option ->
  ?self_merged:int32 ->
  ?tests:float ->
  unit ->
  changes_lifecycle
(** [default_changes_lifecycle ()] is the default value for type [changes_lifecycle] *)
