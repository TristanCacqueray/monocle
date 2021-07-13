{ tenants :
    List
      { crawlers :
          List
            { name : Text
            , provider :
                < BugzillaProvider :
                    { bugzilla_api_key : Text
                    , bugzilla_url : Text
                    , products : List Text
                    }
                | GerritProvider :
                    { gerrit_url : Text
                    , gerrit_url_insecure : Bool
                    , prefix : Optional Text
                    , repositories : Optional (List Text)
                    }
                | GithubProvider :
                    { github_token : Text
                    , github_url : Text
                    , organization : Text
                    , repositories : Optional (List Text)
                    }
                | GitlabProvider :
                    { gitlab_api_key : Text
                    , gitlab_organizations : Optional (List Text)
                    , gitlab_repositories : Optional (List Text)
                    , gitlab_url : Text
                    }
                | TaskDataProvider
                >
            , update_since : Text
            }
      , crawlers_api_key : Text
      , idents :
          Optional
            ( List
                { aliases : List Text
                , groups : Optional (List Text)
                , ident : Text
                }
            )
      , index : Text
      , projects :
          Optional
            ( List
                { branch_regex : Optional Text
                , file_regex : Optional Text
                , name : Text
                , repository_regex : Optional Text
                }
            )
      , search_aliases : Optional (List { alias : Text, name : Text })
      }
}
