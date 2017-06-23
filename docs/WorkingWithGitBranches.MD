## Working with Git and Branches
####@author: Andrew Brown

In the Git version control system, branches are a way to experiment with new features whilst maintaining a record of commit history. This allows you to make commits and progress within your branch without contaminating the "production" branch (for our purposes typically called *master*).

Essentially, a branch keeps track of the changes that have occured since a common ancestor/parent commit. Subsequent changes to the repository result in divergence of the branches, depending on which branch those changes are committed to. But, because of the known parent-child relationships between commits, changes made on related branches can be merged with or rebased from other branches with relative ease. 

Some branching principles:
 * Branch early and branch often. Branches are cheap, so don't be afraid to use them.
 * Don't let branches diverge too much if you can avoid it (at least rebase to *master* periodically, see below). 
 * Maintaining branches for individual projects allows issues of varying scale to be addressed and updated without affecting non-target components. Further, it allows one to quickly change gears and track progress in sub-projects within the repository.

As with any version control system, care needs to be taken to not create conflicting changes in parallel branches (that is, editing the same code simultaneously in both branches) as these will have to be manually reconciled, which can be time-consuming. See the `git merge` documentation (link at bottom of page) for a much more indepth discussion of resolving conflicts.

This helpfile assumes that `git` is available via the command-line (by adding the git bin path to your USER %PATH% variable) or that you are using Git Shell. All the same functionality is also available through the GUI version of Git.

### Creating a local repository
Use `git init` to create an empty Git repository or reinitialize an existing repository. 
Use `git clone` to create an instance of an existing Git repository in a new directory.

```
git init MyRepo
```

```
git clone https://github.com/github-username/MyRepository.git
```

### Saving your changes to the local repository 

Use `git add` to add files that you have changed within your repository to the "staging area" for a commit. The `-a` parameter for `git add` will stage all uncommited changes (be careful!) within the repository. You can use a .gitignore file  to specify files to never include in your unstaged changes list (.RData, temp files, large output, binaries etc. are all good candidates for gitignore).

Use `git commit` to save changes that are staged and assign them a unique commit hash code. The state of the repository at time of commit can be retreived and referenced based on this unique code. 

```
git add *.R
git commit -m "Added all the R files. Some descriptive message about what you changed in this commit."
```

### Creating a branch

When in a child directory of the repository, execute `git branch` to create a new branch

```
git branch MyBranch
```

You can execute `git status` to check which branch you are on and where that branch is relative to the remote/origin repository. 

### Switching to an existing branch

Use `git checkout` to check out an existing branch:
```
git checkout MyBranch
```

The above command will change the contents of your local repository (directory structure, files, file contents, etc.) to reflect the status of *MyBranch*. 

Once you have checked out your branch, proceed to make your edits. Experiment. Make regular commits with meaningful explanations. All the while, you are without fear of overwriting the HEAD of the *master* branch before your code is production ready. It is not wise to have significant uncommitted changes, and that is why you are using a branch other than *master*.

You can swap to a different branches as needed. As with when working on the *master* branch, your changes will be kept in your local repository until you push. 

### Pushing branch changes to the remote repository for the first time (from a new branch) 

After creating a branch in your local repository and making some changes/commits, you have to set the upstream Git reference before you can push your changes to the remote repository. You can do this with an additional argument to `git push`. 

The below command will set your upstream reference to the origin and create the branch *MyBranch* on the remote repository. This assumes the origin is set in your local repository (which it will be if it was created from a clone of the remote). You will need to create a remote repository (for example on the GitHub website) to push to if the repository originated locally.

```
git push --set-upstream origin MyBranch
```

### Rebasing *master* into your branch (update your branch from *master*)

Switch to the master branch with `git checkout` then make sure local copy is up to date with the remote using `git pull`. Then use `git rebase` to bring the new changes from *master* into *MyBranch*. This essentially moves the commit your branch "branches off from" to the most up-to-date commit in *master*. 

After applying the commits from your branch to the parent commit from the master branch, and assuming there are no conflicts with parallel changes in the master branch on same code, you will have your *MyBranch* changes plus any additional changes from *master*.

```
git checkout master 
git pull
git rebase MyBranch
```

### Merging your branch into *master* (update *master* from your branch)

Make sure you don't have uncommitted changes. These may be hard to recover in case conflicts occur during the merge.
```
git checkout master
git pull
git merge MyBranch
```

### Dealing with conflicts

If a merge action results in conflicts, you can abort using:
```
git merge --abort
```

Alternately, you can use a graphical merge tool such as:
```
git mergetool
```

Also, you can look at the 3-way difference (HEAD, MERGED HEAD, your branch) between the conflicting commits
```
git diff
```

### Installing an R package from a branch

If you have created a branch of a repository that is an R package, you can install your branch in package form using `devtools::install_github()` and specifying the `ref` argument. The default value for `ref` is *master*. 

The below code would install an R package using the current state of the branch *MyBranch*. This is very helpful for testing out new components of packages before they are production ready.
```
devtools::install_github("github-username/MyRepository", ref="MyBranch" ,dependencies=FALSE, upgrade_dependencies=FALSE)
```

## Helpful links
 * https://git-scm.com/docs
 
 * https://git-scm.com/docs/git-add

 * https://git-scm.com/docs/git-commit
 
 * https://git-scm.com/docs/git-pull
 
 * https://git-scm.com/docs/git-push

 * https://git-scm.com/docs/git-checkout

 * https://git-scm.com/docs/git-branch

 * https://git-scm.com/docs/git-merge

 * https://git-scm.com/docs/git-rebase