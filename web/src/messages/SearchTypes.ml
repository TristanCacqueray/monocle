[@@@ocaml.warning "-27-30-39"]


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

type changes_query_request = {
  index : string;
  query : string;
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
  task_data : TaskDataTypes.new_task_data list;
}

type changes = {
  changes : change list;
}

type changes_query_response =
  | Error of query_error
  | Items of changes

let rec default_search_suggestions_request 
  ?index:((index:string) = "")
  () : search_suggestions_request  = {
  index;
}

let rec default_search_suggestions_response 
  ?task_types:((task_types:string list) = [])
  ?authors:((authors:string list) = [])
  ?approvals:((approvals:string list) = [])
  ?priorities:((priorities:string list) = [])
  ?severities:((severities:string list) = [])
  () : search_suggestions_response  = {
  task_types;
  authors;
  approvals;
  priorities;
  severities;
}

let rec default_fields_request 
  ?version:((version:string) = "")
  () : fields_request  = {
  version;
}

let rec default_field_type () = (Field_date:field_type)

let rec default_field 
  ?name:((name:string) = "")
  ?description:((description:string) = "")
  ?type_:((type_:field_type) = default_field_type ())
  () : field  = {
  name;
  description;
  type_;
}

let rec default_fields_response 
  ?fields:((fields:field list) = [])
  () : fields_response  = {
  fields;
}

let rec default_query_error 
  ?message:((message:string) = "")
  ?position:((position:int32) = 0l)
  () : query_error  = {
  message;
  position;
}

let rec default_changes_query_request 
  ?index:((index:string) = "")
  ?query:((query:string) = "")
  () : changes_query_request  = {
  index;
  query;
}

let rec default_file 
  ?additions:((additions:int32) = 0l)
  ?deletions:((deletions:int32) = 0l)
  ?path:((path:string) = "")
  () : file  = {
  additions;
  deletions;
  path;
}

let rec default_commit 
  ?sha:((sha:string) = "")
  ?title:((title:string) = "")
  ?author:((author:string) = "")
  ?authored_at:((authored_at:TimestampTypes.timestamp option) = None)
  ?committer:((committer:string) = "")
  ?committed_at:((committed_at:TimestampTypes.timestamp option) = None)
  ?additions:((additions:int32) = 0l)
  ?deletions:((deletions:int32) = 0l)
  () : commit  = {
  sha;
  title;
  author;
  authored_at;
  committer;
  committed_at;
  additions;
  deletions;
}

let rec default_change_merged_by_m () : change_merged_by_m = Merged_by ("")

and default_change 
  ?change_id:((change_id:string) = "")
  ?author:((author:string) = "")
  ?title:((title:string) = "")
  ?url:((url:string) = "")
  ?repository_fullname:((repository_fullname:string) = "")
  ?state:((state:string) = "")
  ?branch:((branch:string) = "")
  ?target_branch:((target_branch:string) = "")
  ?created_at:((created_at:TimestampTypes.timestamp option) = None)
  ?updated_at:((updated_at:TimestampTypes.timestamp option) = None)
  ?merged_at:((merged_at:TimestampTypes.timestamp option) = None)
  ?merged_by_m:((merged_by_m:change_merged_by_m) = Merged_by (""))
  ?text:((text:string) = "")
  ?additions:((additions:int32) = 0l)
  ?deletions:((deletions:int32) = 0l)
  ?approval:((approval:string list) = [])
  ?assignees:((assignees:string list) = [])
  ?labels:((labels:string list) = [])
  ?draft:((draft:bool) = false)
  ?mergeable:((mergeable:bool) = false)
  ?changed_files:((changed_files:file list) = [])
  ?changed_files_count:((changed_files_count:int32) = 0l)
  ?commits:((commits:commit list) = [])
  ?commits_count:((commits_count:int32) = 0l)
  ?task_data:((task_data:TaskDataTypes.new_task_data list) = [])
  () : change  = {
  change_id;
  author;
  title;
  url;
  repository_fullname;
  state;
  branch;
  target_branch;
  created_at;
  updated_at;
  merged_at;
  merged_by_m;
  text;
  additions;
  deletions;
  approval;
  assignees;
  labels;
  draft;
  mergeable;
  changed_files;
  changed_files_count;
  commits;
  commits_count;
  task_data;
}

let rec default_changes 
  ?changes:((changes:change list) = [])
  () : changes  = {
  changes;
}

let rec default_changes_query_response () : changes_query_response = Error (default_query_error ())
