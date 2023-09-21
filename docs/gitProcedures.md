# Titi Monkey Technologies: Procedures & Best Practices for Git & Github

### The Development Cycle: Using Branches Effectively
Git uses a tree structure to store an evolving project over time. This structure allows those working on the project to freely make changes without worrying about "breaking" a current version of the project. Experimental changes to a project are best achieved using the notion of a _branch_.

To make a new branch of a project the terminal command is:

    git branch [name]

Where [name] should be replaced with the desired name for the branch, i.e. experimentalChange. This command makes a copy of the current branch but creates a new path where changes do not effect the original branch.



