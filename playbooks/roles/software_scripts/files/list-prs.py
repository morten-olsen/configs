#!/usr/bin/env python3
# Call GitHub API
# https://developer.github.com/v3/

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from math import floor


def time_ago(time=False):
    """
    Get a datetime object, an ISO standard date string, or a int()
    Epoch timestamp and return a pretty string like 'an hour ago',
    'Yesterday', '3 months ago', 'just now', etc.
    Modified from: http://stackoverflow.com/a/1551394/141084
    """
    now = datetime.now(tz=timezone.utc)
    if type(time) is int:
        diff = now - datetime.fromtimestamp(time, tz=timezone.utc)
    elif isinstance(time, datetime):
        diff = now - time
    elif type(time) is str:
        diff = now - datetime.strptime(time, "%Y-%m-%dT%H:%M:%SZ").replace(
            tzinfo=timezone.utc
        )
    elif not time:
        diff = now - now
    else:
        raise ValueError("invalid date %s of type %s" % (time, type(time)))
    second_diff = diff.seconds
    day_diff = diff.days

    if day_diff < 0:
        return ""

    if day_diff == 0:
        if second_diff < 10:
            return "just now"
        if second_diff < 60:
            return str(second_diff) + " seconds ago"
        if second_diff < 120:
            return "a minute ago"
        if second_diff < 3600:
            return str(floor(second_diff / 60)) + " minutes ago"
        if second_diff < 7200:
            return "an hour ago"
        if second_diff < 86400:
            return str(floor(second_diff / 3600)) + " hours ago"
    if day_diff == 1:
        return "Yesterday"
    if day_diff < 7:
        return str(floor(day_diff)) + " days ago"
    if day_diff < 31:
        return str(floor(day_diff / 7)) + " weeks ago"
    if day_diff < 365:
        return str(floor(day_diff / 30)) + " months ago"
    return str(floor(day_diff / 365)) + " years ago"


def get_repos_for_team(org_name: str, team_name: str) -> list[str]:
    """Get a list of repos for a team."""
    cmd_result = subprocess.run(
        [
            "gh",
            "api",
            f"/orgs/{org_name}/teams/{team_name}/repos",
            "-H",
            "Accept: application/vnd.github+json",
            "--jq",
            ".[].full_name",
        ],
        capture_output=True,
        text=True,
    )

    if cmd_result.returncode != 0:
        print(cmd_result.stderr)
        sys.exit(1)

    return cmd_result.stdout.split()


def get_prs_for_repo(repo_name: str) -> list[dict]:
    """Get a list of PRs for a repo."""
    # Available fields for PRs:
    #   additions
    #   assignees
    #   author
    #   baseRefName
    #   body
    #   changedFiles
    #   closed
    #   closedAt
    #   comments
    #   commits
    #   createdAt
    #   deletions
    #   files
    #   headRefName
    #   headRepository
    #   headRepositoryOwner
    #   id
    #   isCrossRepository
    #   isDraft
    #   labels
    #   latestReviews
    #   maintainerCanModify
    #   mergeCommit
    #   mergeStateStatus
    #   mergeable
    #   mergedAt
    #   mergedBy
    #   milestone
    #   number
    #   potentialMergeCommit
    #   projectCards
    #   reactionGroups
    #   reviewDecision
    #   reviewRequests
    #   reviews
    #   state
    #   statusCheckRollup
    #   title
    #   updatedAt
    #   url
    cmd_result = subprocess.run(
        [
            "gh",
            "pr",
            "list",
            "--json",
            "number,title,author,url,headRepository,createdAt,updatedAt,isDraft,headRefName,state,reviews",
            "--repo",
            repo_name,
        ],
        capture_output=True,
        text=True,
    )

    if cmd_result.returncode != 0:
        print(cmd_result.stderr)
        sys.exit(1)

    prs = json.loads(cmd_result.stdout)
    # Convert createdAt and updatedAt to human-readable
    for pr in prs:
        pr["createdAtTimeAgo"] = time_ago(pr["createdAt"])
        pr["updatedAtTimeAgo"] = time_ago(pr["updatedAt"])

    return prs


def printTable(myDict, colList=None):
    """Pretty print a list of dictionaries (myDict) as a dynamically sized table.
    If column names (colList) aren't specified, they will show in random order.
    Author: Thierry Husson - Use it as you want but don't blame me.
    """
    if not colList:
        colList = list(myDict[0].keys() if myDict else [])
    myList = [colList]  # 1st row = header
    for item in myDict:
        myList.append(
            [str(item[col] if item[col] is not None else "") for col in colList]
        )
    colSize = [max(map(len, col)) for col in zip(*myList)]
    formatStr = " | ".join(["{{:<{}}}".format(i) for i in colSize])
    myList.insert(1, ["-" * i for i in colSize])  # Seperating line
    for item in myList:
        print(formatStr.format(*item))


def get_pr_details(pr):
    """Extract relevant fields from pr dict."""
    number = f"PR {pr['number']}"
    title = pr["title"]
    repo = pr["headRepository"]["name"]
    url = pr["url"]
    author = pr["author"]["login"]
    created = pr["createdAtTimeAgo"]
    updated = pr["updatedAtTimeAgo"]
    is_draft = pr["isDraft"]
    return {
        "number": number,
        "title": title,
        "repo": repo,
        "url": url,
        "author": author,
        "updated": updated,
        "is_draft": is_draft,
    }


def main(
    org_name: str,
    team_name: str,
    ignore_repos: list[str],
    include_drafts: bool,
    include_dependabot: bool,
):
    """Get a list of PRs for a team."""
    repos = get_repos_for_team(org_name, team_name)
    prs = []
    for repo in repos:
        if repo.split("/")[1] in ignore_repos:
            continue
        prs.extend(get_prs_for_repo(repo))

    # Sort by updated date (descending)
    prs.sort(key=lambda pr: pr["updatedAt"], reverse=True)

    prs_relevant = [
        get_pr_details(pr)
        for pr in prs
        if pr["author"]["login"] != "dependabot" or include_dependabot
    ]

    # Filter out draft PRs
    if not include_drafts:
        prs_relevant = [pr for pr in prs_relevant if not pr["is_draft"]]

    printTable(prs_relevant, ["url", "title", "author", "updated"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--org", help="GitHub organization name", default="0north")
    parser.add_argument(
        "--team", help="GitHub team name", default="voyage-optimisation"
    )
    parser.add_argument(
        "--include-dependabot",
        help="Include dependabot PRs",
        action="store_true",
        default=False,
    )
    parser.add_argument(
        "--include-drafts", help="Include draft PRs", action="store_true", default=False
    )
    parser.add_argument(
        "--ignore-repos", "-i,", help="Ignore repos", nargs="+", default=[]
    )
    args = parser.parse_args()

    main(
        args.org,
        args.team,
        args.ignore_repos,
        args.include_drafts,
        args.include_dependabot,
    )
