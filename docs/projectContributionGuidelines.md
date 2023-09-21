# Titi Monkey Tchnology: project guidelines

The titi monkey technology project is maintained on GitHub where collaboration,
and project contributions are managed using a combination of [issues](https://help.github.com/articles/about-issues/)
and [project boards](https://help.github.com/articles/about-project-boards/).
Becuase of the importance of data integrity contributions are batched into
[milestones](https://help.github.com/articles/about-milestones/) that are
thuroughly tested before integrating into the master branch. Changes always
have the possibility of corrupting experimental data, and in order to minimize
the potential impact of such bugs changes are mapped to versions the are
then associated with experiment sessions. If issues occur this workflow is
designed to isolate possibly corrupted data to the problem version.

## Release version number breakdown
Version numbers are formatted in three parts using decimal seperation: AA.BB.CC 
that each signal different levels of project progress. Version numbers are
meant to signal changes to the master branch of the project.

### Section A 
The top level of the version number increments every 3 months _if and only if_
at least 5 milestones have been completed. As project contribution slows down
this top level version number will remain static, signaling that the project
is in a stable/static state.

### Section B 
The middle section of the version number increments with a completed milestone. A
milestone is initialized with several issues that are batched together with an
estimated time to complete of 1--3 weeks. Ideally a milestone contains related
issues, but the only requirement is that all issues are defined at the start
of a milestone. Note that the milestone is merged into the master branch as
a completed unit, issues completed first will wait until the entire milestone
is completed before actually being integrated into the master branch.

### Section C 
The final section of the version number increments if critical bugs/fixes/updates
**must** be merged into the master branch wihtout waiting for a completed
milestone.

## Managing milestones
Milestones are simply a collection of issues that the project manager has
batched together with a deadline/expected time to complete. In order to make
the project manageable milestones should not grow arbitrarily since before
integrating a milestone into the master branch we need to:

1. Preform integration tests before merging the milestone into master
    - Since all issues in a milestone are merged together, bugs that are found
during integration testing hold up every issue (even the bug free ones) from
being merged
    - The more changes introduced in a given milestone the more potential their
are for bugs in general

2. Ensure that all changes are reflected in the documentation
    - Because of the scientific nature of the project, documentation must be
well maintained, and as easy to understand as possible
    - A large batch of changes neccessitates a large amount of documentation
which can significantly slow down improvements to the application

3. Complete every issue.

Milestones should also be (within reason) inflexible. Adding and removing
issues from a milestone should be avoided since adding issues to a milestone
as they pop up extends the time for all issues already in the milestone to
be merged into the master branch, and removing issues from the milestone
implies that either the issue or the milestone was not thought out well enough.
Removing an issue from a milestone should only occur if:

1. The issue is significantly more complex then originally thought, and should
be broken down into sever sub issues.

2. The issue is intractable / not possible and is being removed / redesigned

3. The issue has lost its purpose, and is being removed from the project

Issues should only be added to a milestone if they meet all of the following:

1. Closely related to an existing issue

2. Has no reasonable chance to push the deadline back

3. Would become a critical need before the next milestone is finished

Note that critical changes are handled outside of milestones and thus avoid
these requirements.

## Managing issues
Issues can be proposed by any contributer, but should typically not be worked
outside of a milestone, or direction from the project manager. Issues begin
with the _backlog_ label and exactly one of the following additional labels:

- change request: An alteration to an existing feature by enchancing the
functionality of the feature or cleaning it up (refactoring, name changes, etc)
- feature request: A new feature
- bug: A feature is not behaving as intended
- docs: Proposed code clean ups (refactoring, name change, etc),
or a required update to documentation

Issues should remain unassigned until they are incorporated in a milestone with
the exception of bugs. Bugs should be directed to whoever wrote the code
resulting in the bug to assess first.

### Issue formatting / required information
In order to efficently process issues they should have an expected/common
format that leaves little to interpretation.

#### Change requests
A change request should:
1. Reference the feature it changes using a [permanent link](https://help.github.com/articles/creating-a-permanent-link-to-a-code-snippet/)
2. Formally specify the requirments of the change
3. Justify the need for the original feature to be changed

#### Feature request
A feature request needs to both describe the feature using the "scrum" styled 
user story paradigm adapted to the language of the experiment, and outline 
the steps needed to achieve the requirements.
An example feature request description:
 
    Description:
    The subject is prompted to participate in a trial with a wait screen that
    blinks on and off at one second intervals. When the subject touches the
    screen a trial begins.

    Outline:
    1. Create a time based trigger to toggle the wait screen on and off
    2. Invalidate the timer when a trial is initiated
    3. Revalidate the timer after a trial is completed
    4. Ensure that a trial can be initiated whether the wait screen is on or off

#### Docs
Typically part of completing an issue is documenting the changes in the project
wiki. If Areas are discovered that are unclear, outdated, or otherwise in need
of revision the docs label can be used. The general format of a docs issue
should specify the area in code that requires documentation using a 
permenant link, and a brief description of what needs to be changed in the
documentation to better describe that code.

### Closing an issue
An issue should be closed using the [automated process](https://help.github.com/articles/closing-issues-using-keywords/)
 which maps a git commit to an issue. The git commit should be brief, relying
on the issue it references to describe what it did. A short summary
of the issue can be provided on the first line after the issue closing keyword.
An example of an issue closing git commit:

    Fixes #19 - Add blinking behavior to waitscreen

## Merging to master branch - pull requests
When a milestone is completely finished, tested, and documented it is merged
into the master branch using a pull request. A pull request can be initiated by
anyone, but must be approved by the owner of the git repository. The pull
request is the last opportunity to confirm that changes are working as intended
before being applied to the version of the software that is used in the lab.

### Initiating a pull request
When a milestone is deemed complete by the individuals working it a pull request is made to merge it into the master branch. The pull request represents the final opportunity to check all changes made in the milestone for potential errors before bringing those errors into the master branch. Ideally a member of the team not directly involved in the changes reviews the milestone for:
    - Integration test coverage—making sure the changes made are captured by the current testing framework
    - Complete documentation—making sure all changes are reflected in the documentation, and are easy for this member to understand
    - Passing integration test—making sure that now errors are being generated by the integration test
    - Commit messages are complete, detailed, idiomatic
Once this checklist has been reviewed and the member agrees the milestone is complete, the pull request can be approved, and the milestone branch can be removed.

