import "@typespec/http"; 
import "@typespec/openapi3"; 
import "@microsoft/typespec-m365-copilot";

using TypeSpec.Http;
using TypeSpec.M365.Copilot.Agents;
using TypeSpec.M365.Copilot.Actions;

@agent(
  "github-agent0507",
  "Declarative agent created with Teams Toolkit" 
) 

@instructions(""" 
  You are a declarative agent and were created with Team Toolkit.
""")

@conversationStarter(#{
  text: "list my repos",
  title: "List Repos",
}) 

namespace githubAgent {
  @service
  @actions(#{ 
    nameForHuman: "github agent", 
    descriptionForModel: "github agent",
    privacyPolicyUrl: "https://test/privacy",
    legalInfoUrl: "https://test/legal",
    descriptionForHuman: "description for github agent"
  })
  @server("https://api.github.com", "github apis")
  namespace listRepos {
    /** 
    some description for the repair service
    */
    @useAuth(oauth)
    @route("/user/repos")
    @get
    op repos_list_for_authenticated_user(
      @query(#{ explode: true }) visibility?: "all" | "public" | "private" = "all",
      @query(#{ explode: true }) affiliation?: string = "owner,collaborator,organization_member",
      @query(#{ explode: true }) type?: "all" | "owner" | "public" | "private" | "member" = "all",
      @query(#{ explode: true }) sort?: "created" | "updated" | "pushed" | "full_name" = "full_name",
      @query(#{ explode: true }) direction?: "asc" | "desc",
    ): 
      | Body<repository[]>
      | NotModifiedResponse
      | (UnauthorizedResponse & `basic-error`)
      | (ForbiddenResponse & `basic-error`)
      | {
        @statusCode statusCode: 422;
        @body body: `validation-error`;
      };
  }
}

@summary("Repository")
model repository {
  /**
   * Unique identifier of the repository
   */
  id: integer;

  node_id: string;

  /**
   * The name of the repository.
   */
  name: string;

  full_name: string;
  license: `nullable-license-simple`;
  forks: integer;
  permissions?: {
    admin: boolean;
    pull: boolean;
    triage?: boolean;
    push: boolean;
    maintain?: boolean;
  };
  owner: `simple-user`;

  /**
   * Whether the repository is private or public.
   */
  private: boolean;

  html_url: url;
  description: string | null;
  fork: boolean;
  url: url;
  archive_url: string;
  assignees_url: string;
  blobs_url: string;
  branches_url: string;
  collaborators_url: string;
  comments_url: string;
  commits_url: string;
  compare_url: string;
  contents_url: string;
  contributors_url: url;
  deployments_url: url;
  downloads_url: url;
  events_url: url;
  forks_url: url;
  git_commits_url: string;
  git_refs_url: string;
  git_tags_url: string;
  git_url: string;
  issue_comment_url: string;
  issue_events_url: string;
  issues_url: string;
  keys_url: string;
  labels_url: string;
  languages_url: url;
  merges_url: url;
  milestones_url: string;
  notifications_url: string;
  pulls_url: string;
  releases_url: string;
  ssh_url: string;
  stargazers_url: url;
  statuses_url: string;
  subscribers_url: url;
  subscription_url: url;
  tags_url: url;
  teams_url: url;
  trees_url: string;
  clone_url: string;
  mirror_url: url | null;
  hooks_url: url;
  svn_url: url;
  homepage: url | null;
  language: string | null;
  forks_count: integer;
  stargazers_count: integer;
  watchers_count: integer;

  /**
   * The size of the repository, in kilobytes. Size is calculated hourly. When a repository is initially created, the size is 0.
   */
  size: integer;

  /**
   * The default branch of the repository.
   */
  default_branch: string;

  open_issues_count: integer;

  /**
   * Whether this repository acts as a template that can be used to generate new repositories.
   */
  is_template?: boolean;

  topics?: string[];

  /**
   * Whether issues are enabled.
   */
  has_issues: boolean = true;

  /**
   * Whether projects are enabled.
   */
  has_projects: boolean = true;

  /**
   * Whether the wiki is enabled.
   */
  has_wiki: boolean = true;

  has_pages: boolean;

  /**
   * Whether downloads are enabled.
   */
  has_downloads: boolean = true;

  /**
   * Whether discussions are enabled.
   */
  has_discussions?: boolean;

  /**
   * Whether the repository is archived.
   */
  archived: boolean;

  /**
   * Returns whether or not this repository disabled.
   */
  disabled: boolean;

  /**
   * The repository visibility: public, private, or internal.
   */
  visibility?: string = "public";

  pushed_at: utcDateTime | null;
  created_at: utcDateTime | null;
  updated_at: utcDateTime | null;

  /**
   * Whether to allow rebase merges for pull requests.
   */
  allow_rebase_merge?: boolean = true;

  temp_clone_token?: string;

  /**
   * Whether to allow squash merges for pull requests.
   */
  allow_squash_merge?: boolean = true;

  /**
   * Whether to allow Auto-merge to be used on pull requests.
   */
  allow_auto_merge?: boolean;

  /**
   * Whether to delete head branches when pull requests are merged
   */
  delete_branch_on_merge?: boolean;

  /**
   * Whether or not a pull request head branch that is behind its base branch can always be updated even if it is not required to be up to date before merging.
   */
  allow_update_branch?: boolean;

  /**
   * Whether a squash merge commit can use the pull request title as default. **This property has been deprecated. Please use `squash_merge_commit_title` instead.
   */
  use_squash_pr_title_as_default?: boolean;

  /**
   * The default value for a squash merge commit title:
   *
   * - `PR_TITLE` - default to the pull request's title.
   * - `COMMIT_OR_PR_TITLE` - default to the commit's title (if only one commit) or the pull request's title (when more than one commit).
   */
  squash_merge_commit_title?: "PR_TITLE" | "COMMIT_OR_PR_TITLE";

  /**
   * The default value for a squash merge commit message:
   *
   * - `PR_BODY` - default to the pull request's body.
   * - `COMMIT_MESSAGES` - default to the branch's commit messages.
   * - `BLANK` - default to a blank commit message.
   */
  squash_merge_commit_message?: "PR_BODY" | "COMMIT_MESSAGES" | "BLANK";

  /**
   * The default value for a merge commit title.
   *
   * - `PR_TITLE` - default to the pull request's title.
   * - `MERGE_MESSAGE` - default to the classic title for a merge message (e.g., Merge pull request #123 from branch-name).
   */
  merge_commit_title?: "PR_TITLE" | "MERGE_MESSAGE";

  /**
   * The default value for a merge commit message.
   *
   * - `PR_TITLE` - default to the pull request's title.
   * - `PR_BODY` - default to the pull request's body.
   * - `BLANK` - default to a blank commit message.
   */
  merge_commit_message?: "PR_BODY" | "PR_TITLE" | "BLANK";

  /**
   * Whether to allow merge commits for pull requests.
   */
  allow_merge_commit?: boolean = true;

  /**
   * Whether to allow forking this repo
   */
  allow_forking?: boolean;

  /**
   * Whether to require contributors to sign off on web-based commits
   */
  web_commit_signoff_required?: boolean;

  open_issues: integer;
  watchers: integer;
  master_branch?: string;
  starred_at?: string;

  /**
   * Whether anonymous git access is enabled for this repository
   */
  anonymous_access_enabled?: boolean;
}

@summary("Basic Error")
model `basic-error` {
  message?: string;
  documentation_url?: string;
  url?: string;
  status?: string;
}

@summary("Validation Error")
model `validation-error` {
  message: string;
  documentation_url: string;
  errors?: {
    resource?: string;
    field?: string;
    message?: string;
    code: string;
    index?: integer;

    value?: string | null | integer | null | string[] | null;
  }[];
}

@summary("Simple User")
model `simple-user` {
  name?: string | null;
  email?: string | null;
  login: string;
  id: integer;
  node_id: string;
  avatar_url: url;
  gravatar_id: string | null;
  url: url;
  html_url: url;
  followers_url: url;
  following_url: string;
  gists_url: string;
  starred_url: string;
  subscriptions_url: url;
  organizations_url: url;
  repos_url: url;
  events_url: string;
  received_events_url: url;
  type: string;
  site_admin: boolean;
  starred_at?: string;
}

@summary("License Simple")
model `nullable-license-simple` {
  key?: string;
  name?: string;
  url?: string;
  spdx_id?: string;
  node_id?: string;
}

@authReferenceId("NzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3IyMzODM5YjI5YS0yYzYxLTQzZGEtYTA2Ni1lYThiMDkwM2RkNDE=")
model oauth is OAuth2Auth<
  [
    {
      type: OAuth2FlowType.authorizationCode;
      authorizationUrl: "https://github.com/login/oauth/authorize";
      tokenUrl: "https://github.com/login/oauth/access_token"
    }
  ],
  ["repo"],
>;
